import 'package:enzer_app/core/enums/view_state.dart';
import 'package:enzer_app/core/others/base_view_model.dart';
import 'package:enzer_app/core/others/logger_customizations/custom_logger.dart';
import 'package:enzer_app/ui/screens/auth_signup/otp_screen/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  final log = CustomLogger(className: 'ForgotPasswordViewModel');

  final TextEditingController phoneCtrl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? validatePhone(String? val) {
    if (val == null || val.trim().isEmpty) return 'Phone number is required';
    if (val.trim().length != 10) return 'Enter a valid 10-digit number';
    return null;
  }

  Future<void> onSendCode() async {
    if (!formKey.currentState!.validate()) return;

    try {
      setState(ViewState.busy);

      final phone = '+92${phoneCtrl.text.trim()}';
      log.d('@onSendCode: Sending OTP to $phone');

      //?will be used in production for sending real sms
      // await _authService.sendOtp(phone);

      Get.to(
        () => const OtpScreen(),
        arguments: {'phone': phone, 'isResetPassword': true},
      );
    } catch (e, stackTrace) {
      log.e('@onSendCode Exception: $e');
      log.e(stackTrace);
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: const Text('Something went wrong. Please try again.'),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('OK')),
          ],
        ),
      );
    }

    setState(ViewState.idle);
  }

  @override
  void dispose() {
    phoneCtrl.dispose();
    super.dispose();
  }
}
