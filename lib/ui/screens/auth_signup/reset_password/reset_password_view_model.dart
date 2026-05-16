import 'package:enzer_app/core/error/app_exception.dart';

import 'package:enzer_app/core/enums/view_state.dart';
import 'package:enzer_app/core/others/base_view_model.dart';
import 'package:enzer_app/core/others/logger_customizations/custom_logger.dart';
import 'package:enzer_app/core/services/auth_service.dart';
import 'package:enzer_app/locator.dart';
import 'package:enzer_app/ui/custom_widgets/dialogs/app_dialog.dart';
import 'package:enzer_app/ui/screens/auth_signup/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordViewModel extends BaseViewModel {
  final log = CustomLogger(className: 'ResetPasswordViewModel');

  final AuthService _authService = locator<AuthService>();

  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  String? validatePassword(String? val) {
    if (val == null || val.isEmpty) return 'Password is required';
    if (val.length < 8) return 'Must be at least 8 characters';
    return null;
  }

  String? validateConfirmPassword(String? val) {
    if (val == null || val.isEmpty) return 'Please confirm your password';
    if (val != passwordCtrl.text) return 'Passwords do not match';
    return null;
  }

  Future<void> onResetPassword() async {
    if (!formKey.currentState!.validate()) return;

    try {
      setState(ViewState.busy);

      final phone = Get.arguments?['phone'] ?? '';
      final newPassword = passwordCtrl.text.trim();

      log.d('@onResetPassword: phone=$phone');

      final isSame = await _authService.isOldPassword(phone, newPassword);
      if (isSame) {
        Get.dialog(
          const AppDialog(
            title: 'Same Password',
            message:
                'This is your current password. Please choose a different one.',
          ),
        );
        setState(ViewState.idle);
        return;
      }

      await _authService.updatePasswordByPhone(phone, newPassword);
      //! will be used in production:
      // await _authService.updatePassword(newPassword);

      // Success, navigate to login after OK is tapped
      Get.dialog(
        const AppDialog(
          title: 'Password Reset!',
          message: 'Your password has been changed successfully. Please login.',
          isSuccess: true,
        ),
      ).then((_) => Get.offAll(LoginScreen()));
    } on AppException catch (e) {
      log.e('@onResetPassword AppException: ${e.devMessage}');
      _showDialog(title: 'Reset Failed', message: e.userMessage);
    } catch (e, st) {
      log.e('@onResetPassword Unexpected Exception: $e\n$st');
      _showDialog(
        title: 'Reset Failed',
        message: 'Failed to reset password. Please try again.',
      );
    }

    setState(ViewState.idle);
  }

  void _showDialog({required String title, required String message}) {
    Get.dialog(AppDialog(title: title, message: message));
  }

  @override
  void dispose() {
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }
}
