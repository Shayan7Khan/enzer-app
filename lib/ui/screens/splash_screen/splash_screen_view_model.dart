import 'package:enzer_app/core/others/base_view_model.dart';
import 'package:enzer_app/core/others/logger_customizations/custom_logger.dart';
import 'package:enzer_app/core/services/auth_service.dart';
import 'package:enzer_app/core/services/local_storage_service.dart';
import 'package:enzer_app/core/services/referral_service.dart';
import 'package:enzer_app/locator.dart';
import 'package:enzer_app/ui/screens/auth_signup/login/login_screen.dart';
import 'package:enzer_app/ui/screens/root/root_screen.dart';
import 'package:enzer_app/ui/screens/welcome_screen/welcome_screen.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final LocalStorageService _localStorage = locator<LocalStorageService>();
  final ReferralService _referral = locator<ReferralService>();
  static final Logger log = CustomLogger(className: 'SplashViewModel');

  SplashViewModel() {
    log.d('SplashViewModel created');

    _referral.listenForIncomingLinks(
      onReferralReceived: (code) {
        log.d('App opened via referral code: $code');
        _localStorage.pendingReferralCode = code;
      },
    );

    SchedulerBinding.instance.addPostFrameCallback((_) => _handleNavigation());
  }

  Future<void> _handleNavigation() async {
    log.d('_handleNavigation started');

    // debug permission status before requesting
    final status = await Permission.notification.status;
    log.d('PERMISSION STATUS BEFORE REQUEST: $status');

    await _requestNotificationPermission();

    final statusAfter = await Permission.notification.status;
    log.d('PERMISSION STATUS AFTER REQUEST: $statusAfter');

    // request notification permission on first launch
    await _requestNotificationPermission();

    await Future.delayed(const Duration(seconds: 1));

    try {
      log.d('calling doSetup...');
      await _authService.doSetup();
      log.d(
        'doSetup done — isLogin: ${_authService.isLogin} | localStorage.isLoggedIn: ${_localStorage.isLoggedIn}',
      );

      if (_authService.isLogin) {
        log.d('navigating to HomeScreen');
        Get.offAll(() => const RootScreen());
        return;
      }

      if (_localStorage.isLoggedIn) {
        log.d('token expired — navigating to LoginScreen');
        Get.offAll(() => const LoginScreen());
        return;
      }

      log.d('navigating to WelcomeScreen');
      Get.offAll(() => const WelcomeScreen());
    } catch (e, st) {
      log.e('_handleNavigation error: $e\n$st');
      Get.offAll(() => const WelcomeScreen());
    }
  }

  Future<void> _requestNotificationPermission() async {
    try {
      // Android 13+ requires explicit permission request
      final status = await Permission.notification.status;
      log.d('Notification permission status: $status');

      if (status.isDenied) {
        // show system dialog
        final result = await Permission.notification.request();
        log.d('Permission result: $result');
      } else if (status.isPermanentlyDenied) {
        log.d('Permission permanently denied');
      } else {
        log.d('Permission already granted: $status');
      }
    } catch (e) {
      log.e('_requestNotificationPermission error: $e');
    }
  }
}
