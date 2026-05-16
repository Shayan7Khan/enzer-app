import 'package:enzer_app/core/services/localization_service.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/screens/root/root_screen_view_model.dart';
import 'package:enzer_app/ui/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  final String title;
  static const double _designWidth = 390;
  static const double _designHeight = 844;

  /// Root navigator key so overlays (e.g. FCM banner) can use a context with [Overlay].
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => RootScreenViewModel())],
      child: ScreenUtilInit(
        designSize: const Size(_designWidth, _designHeight),
        useInheritedMediaQuery: true,
        ensureScreenSize: true,
        builder: (context, widget) => GetMaterialApp(
          navigatorKey: navigatorKey,
          translations: LocalizationService(),
          locale: const Locale("en"),
          title: title,
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
