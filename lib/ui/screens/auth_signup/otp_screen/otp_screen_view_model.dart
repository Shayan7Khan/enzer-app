import 'dart:async';

import 'package:enzer_app/core/enums/view_state.dart';
import 'package:enzer_app/core/error/app_exception.dart';
import 'package:enzer_app/core/models/body/signup_body.dart';
import 'package:enzer_app/core/others/base_view_model.dart';
import 'package:enzer_app/core/others/logger_customizations/custom_logger.dart';
import 'package:enzer_app/core/services/auth_service.dart';
import 'package:enzer_app/locator.dart';
import 'package:enzer_app/ui/custom_widgets/dialogs/app_dialog.dart';
import 'package:enzer_app/ui/screens/auth_signup/account_created_screen/account_created_screen.dart';
import 'package:enzer_app/ui/screens/auth_signup/reset_password/reset_password.dart';
import 'package:get/get.dart';

class OtpViewModel extends BaseViewModel {
  final log = CustomLogger(className: 'OtpViewModel');

  final AuthService _authService = locator<AuthService>();

  //! TESTING ONLY — remove before production
  static const String _masterOtp = '12345';

  // Args
  String phone = '';
  late SignUpBody signUpBody;
  late bool isResetPassword;

  String otp = '';

  // State
  bool isResendEnabled = false;
  int resendSeconds = 60;
  Timer? _resendTimer;

  OtpViewModel() {
    final args = Get.arguments as Map<String, dynamic>?;
    phone = args?['phone'] ?? '';
    signUpBody = args?['signUpBody'] ?? SignUpBody();
    isResetPassword = args?['isResetPassword'] == true;

    log.d(
      'OtpViewModel init — phone: $phone | isResetPassword: $isResetPassword',
    );
    _startCountdown();
  }

  String get formattedCountdown {
    final minutes = (resendSeconds ~/ 60).toString().padLeft(1, '0');
    final seconds = (resendSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void onOtpChanged(String value) {
    otp = value;
    notifyListeners();
  }

  void routeToAccountCreatedScreen() {
    Get.offAll(() => const AccountCreatedScreen());
  }

  Future<void> verifyOtp() async {
    log.d('Entered OTP: $otp | isResetPassword: $isResetPassword');

    if (otp.length != 5) {
      Get.dialog(
        AppDialog(
          title: 'Invalid Code',
          message: 'Please enter the complete 5-digit code.',
        ),
      );
      return;
    }

    try {
      setState(ViewState.busy);

      //! TESTING ONLY BLOCK — comment out entire block in production
      if (otp == _masterOtp) {
        log.d('@verifyOtp: Master OTP entered');

        if (isResetPassword) {
          log.d('@verifyOtp: Master OTP — navigating to ResetPasswordScreen');
          Get.to(
            () => const ResetPasswordScreen(),
            arguments: {'phone': phone},
          );
          setState(ViewState.idle);
          return;
        }

        log.d('@verifyOtp: Master OTP — creating profile');
        final response = await _authService.createProfileForMasterOtp(
          signUpBody,
        );
        if (response.success) {
          log.d('@verifyOtp: Profile created via master OTP');
          routeToAccountCreatedScreen();
        } else {
          log.e('@verifyOtp: Profile creation failed — ${response.error}');
          _showFailedDialog(response.error ?? 'Something went wrong.');
        }
        setState(ViewState.idle);
        return;
      }
      //! END TESTING ONLY BLOCK

      //* PRODUCTION PATH — real Supabase OTP verification
      if (isResetPassword) {
        final response = await _authService.verifyOtpAndFinalizeSignup(
          otp,
          signUpBody,
        );
        if (response.success) {
          log.d('@verifyOtp: OTP verified — navigating to ResetPasswordScreen');
          Get.to(
            () => const ResetPasswordScreen(),
            arguments: {'phone': phone},
          );
        } else {
          log.e('@verifyOtp: Reset OTP failed — ${response.error}');
          _clearFields();
          _showFailedDialog(
            response.error ?? 'Invalid code. Please try again.',
          );
        }
      } else {
        final response = await _authService.verifyOtpAndFinalizeSignup(
          otp,
          signUpBody,
        );
        if (response.success) {
          log.d('@verifyOtp: Verification successful — profile created');
          routeToAccountCreatedScreen();
        } else {
          log.e('@verifyOtp: Failed — ${response.error}');
          _clearFields();
          _showFailedDialog(
            response.error ?? 'Invalid code. Please try again.',
          );
        }
      }
    } on AppException catch (e) {
      log.e('@verifyOtp AppException: ${e.devMessage}');
      _clearFields();
      _handleErrorForUser(e);
    } catch (e, stackTrace) {
      log.e('@verifyOtp Unexpected Exception: $e');
      log.e(stackTrace);
      _showFailedDialog('Something went wrong. Please try again.');
    }

    setState(ViewState.idle);
  }

  Future<void> resendOtp() async {
    if (!isResendEnabled) return;
    try {
      setState(ViewState.busy);
      final response = await _authService.registerWithPhoneAndPassword(
        signUpBody,
      );
      if (response.success) {
        log.d('@resendOtp: OTP resent to $phone');
        _clearFields();
        isResendEnabled = false;
        resendSeconds = 60;
        _startCountdown();
      } else {
        _showFailedDialog(response.error ?? 'Failed to resend code.');
      }
    } on AppException catch (e) {
      log.e('@resendOtp AppException: ${e.devMessage}');
      _handleErrorForUser(e);
    } catch (e, stackTrace) {
      log.e('@resendOtp Unexpected Exception: $e');
      log.e(stackTrace);
      _showFailedDialog('Something went wrong. Please try again.');
    }
    setState(ViewState.idle);
  }

  void _handleErrorForUser(AppException e) {
    final msg = e.userMessage.toLowerCase();

    if (msg.contains('connection') || msg.contains('internet')) {
      Get.dialog(
        const AppDialog(
          title: 'No Internet',
          message: 'Please check your connection and try again.',
        ),
      );
    } else {
      Get.dialog(
        AppDialog(title: 'Verification Failed', message: e.userMessage),
      );
    }
  }

  void _showFailedDialog(String message) {
    Get.dialog(AppDialog(title: 'Verification Failed', message: message));
  }

  void _startCountdown() {
    _resendTimer?.cancel();
    resendSeconds = 60;
    isResendEnabled = false;
    notifyListeners();

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds > 0) {
        resendSeconds--;
        notifyListeners();
      } else {
        isResendEnabled = true;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  void _clearFields() {
    otp = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }
}
