import 'package:enzer_app/app.dart';
import 'package:enzer_app/core/others/logger_customizations/custom_logger.dart';
import 'package:enzer_app/core/services/auth_service.dart';
import 'package:enzer_app/locator.dart';
import 'package:enzer_app/ui/custom_widgets/notification_banner.dart';
import 'package:enzer_app/ui/screens/root/root_screen.dart';
import 'package:enzer_app/ui/screens/root/root_screen_view_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await _showLocalNotification(message);
}

final FlutterLocalNotificationsPlugin _localNotifications =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'enzer_high_importance',
  'Enzer Notifications',
  description: 'Enzer referral and activity notifications',
  importance: Importance.high,
  playSound: true,
  enableVibration: true,
);

Future<void> _showLocalNotification(RemoteMessage message) async {
  final notification = message.notification;
  if (notification == null) return;

  await _localNotifications.show(
    id: notification.hashCode,
    title: notification.title,
    body: notification.body,
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: const Color(0xFFBF00FF),
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        styleInformation: BigTextStyleInformation(
          notification.body ?? '',
          htmlFormatBigText: false,
          contentTitle: notification.title,
          htmlFormatContentTitle: false,
          summaryText: 'Tap to view',
          htmlFormatSummaryText: false,
        ),
        subText: 'Enzer',
        ticker: notification.title,
        colorized: true,
        actions: [
          AndroidNotificationAction(
            'view_action',
            'View',
            showsUserInterface: true,
          ),
        ],
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    ),
  );
}

class FCMService {
  final _log = CustomLogger(className: 'FCMService');
  final _messaging = FirebaseMessaging.instance;
  final _supabase = Supabase.instance.client;
  final _auth = locator<AuthService>();

  Future<void> init() async {
    final settings = await _messaging.getNotificationSettings();
    _log.d('FCM permission: ${settings.authorizationStatus}');

    // register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // create android notification channel
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (details) {
        Get.offAll(() => const RootScreen());
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.context?.read<RootScreenViewModel>().updatedScreenIndex(2);
        });
      },
    );

    // iOS — suppress system notification in foreground, show in-app banner instead
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: false,
          badge: true,
          sound: false,
        );

    // get token and save
    try {
      final token = await _messaging.getToken();
      _log.d('FCM TOKEN: $token');
      if (token != null) {
        await _saveFcmToken(token);
      }
    } catch (e) {
      _log.e('FCM getToken error (simulator?): $e');
    }

    // refresh token — fires when token changes
    _messaging.onTokenRefresh.listen(_saveFcmToken);

    // foreground — insert banner into overlay directly (Overlay.of(overlay.context) fails
    // because the Overlay widget's context has no Overlay ancestor)
    FirebaseMessaging.onMessage.listen((message) {
      _log.d('Foreground message: ${message.notification?.title}');
      final overlay = MyApp.navigatorKey.currentState?.overlay;

      final displayText = message.notification?.title?.isNotEmpty == true
          ? message.notification!.title!
          : message.notification?.body ?? '';

      if (overlay != null) {
        NotificationBanner.showWithOverlay(
          overlay,
          title: displayText,
          body: '',
          onViewTap: () {
            Get.context?.read<RootScreenViewModel>().updatedScreenIndex(2);
          },
        );
      } else {
        _showLocalNotification(message);
      }
    });
    // tapped from background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);

    // tapped from terminated
    final initial = await _messaging.getInitialMessage();
    if (initial != null) _handleTap(initial);
  }

  Future<void> _saveFcmToken(String token) async {
    try {
      final userId = _auth.userProfile?.id ?? _supabase.auth.currentUser?.id;

      if (userId == null) {
        _log.w('_saveFcmToken: no userId available — token not saved');
        return;
      }

      await _supabase
          .from('profiles')
          .update({'fcm_token': token})
          .eq('id', userId);

      _log.d('FCM token saved for $userId');
    } catch (e) {
      _log.e('_saveFcmToken error: $e');
    }
  }

  void _handleTap(RemoteMessage message) {
    _log.d('Notification tapped — navigating to Activity');
    // navigate to root and switch to activity tab (index 2)
    Get.offAll(() => const RootScreen());
    // switch to activity tab after navigation
    Future.delayed(const Duration(milliseconds: 300), () {
      final context = Get.context;
      if (context != null) {
        // ignore: use_build_context_synchronously
        context.read<RootScreenViewModel>().updatedScreenIndex(2);
      }
    });
  }
}
