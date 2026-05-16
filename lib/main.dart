import 'package:enzer_app/app.dart';
import 'package:enzer_app/core/config/chottu_link_config.dart';
import 'package:enzer_app/core/enums/env.dart';
import 'package:enzer_app/core/others/logger_customizations/custom_logger.dart';
import 'package:enzer_app/firebase_options.dart';
import 'package:enzer_app/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/config/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );
  final log = CustomLogger(className: 'main');
  try {
    await dotenv.load(fileName: ".env");
    log.i('Testing info logs');
    log.d('Testing debug logs');
    log.e('Testing error logs');
    log.w('Testing WTF logs');

    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabasePublishableKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY'];

    await supabaseInitalise(supabaseUrl!, supabasePublishableKey!);

    await setupLocator(Env.production);

    final mobileSdkIntegrationKey = dotenv.env['MOBLE_SDK_INTEGRATION_KEY'];

    chottuLInkInitialise(mobileSdkIntegrationKey!);

    runApp(const MyApp(title: 'Enzer'));
  } catch (e, s) {
    log.e(e.toString());
    log.e(s.toString());
  }
}
