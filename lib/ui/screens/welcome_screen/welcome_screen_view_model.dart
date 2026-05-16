import 'package:enzer_app/core/others/base_view_model.dart';
import 'package:enzer_app/core/others/logger_customizations/custom_logger.dart';
import 'package:enzer_app/ui/screens/auth_signup/login/login_screen.dart';
import 'package:enzer_app/ui/screens/auth_signup/signup_screen/sign_up_screen.dart';
import 'package:get/get.dart';

class WelcomeScreenViewModel extends BaseViewModel {
  final CustomLogger log = CustomLogger(className: 'WelcomeScreenViewModel');

  void onGetEarlyAccessPressed() {
    log.d('Get Early Access pressed');
    Get.to(() => const SignUpScreen());
  }

  void onSignInPressed() {
    Get.to(() => LoginScreen());
  }
}
