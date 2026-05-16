import 'package:enzer_app/core/enums/view_state.dart';
import 'package:enzer_app/core/error/app_exception.dart';
import 'package:enzer_app/core/exceptions/app_exceptions.dart';
import 'package:enzer_app/core/models/body/signup_body.dart';
import 'package:enzer_app/core/others/base_view_model.dart';
import 'package:enzer_app/core/others/logger_customizations/custom_logger.dart';
import 'package:enzer_app/core/services/auth_service.dart';
import 'package:enzer_app/core/services/local_storage_service.dart';
import 'package:enzer_app/locator.dart';
import 'package:enzer_app/ui/custom_widgets/dialogs/app_dialog.dart';
import 'package:enzer_app/ui/screens/auth_signup/login/login_screen.dart';
import 'package:enzer_app/ui/screens/auth_signup/otp_screen/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpViewModel extends BaseViewModel {
  final log = CustomLogger(className: 'SignUpViewModel');
  final AuthService _authService = locator<AuthService>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  final TextEditingController fullNameCtrl = TextEditingController();
  final TextEditingController cnicCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController referralCtrl = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode phoneFocusNode = FocusNode();

  bool isPasswordVisible = true;

  SignUpViewModel() {
    _prefillReferralCode();
  }

  void _prefillReferralCode() {
    final pending = _localStorageService.pendingReferralCode;
    if (pending != null && pending.isNotEmpty) {
      referralCtrl.text = pending;
      _localStorageService.pendingReferralCode = null;
      log.d('Pre-filled referral code from deep link: $pending');
    }
  }

  String? validateFullName(String? val) {
    if (val == null || val.trim().isEmpty) return 'Full name is required';
    if (val.trim().length < 3) return 'Name must be at least 3 characters';
    return null;
  }

  String? validateNic(String? val) {
    final clean = val?.replaceAll('-', '') ?? '';
    if (clean.isEmpty) return 'NIC is required';
    if (clean.length != 13) return 'Enter a valid 13-digit NIC';
    return null;
  }

  String? validatePhone(String? val) {
    if (val == null || val.trim().isEmpty) return 'Phone number is required';
    if (val.trim().length != 11) return 'Enter a valid 11-digit number';
    return null;
  }

  String? validatePassword(String? val) {
    if (val == null || val.isEmpty) return 'Password is required';
    if (val.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  String? validateReferralCode(String? val) {
    if (val != null && val.isNotEmpty && val.trim().length < 4) {
      return 'Enter a valid referral code';
    }
    return null;
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<void> requestSignUp() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    try {
      setState(ViewState.busy);

      final SignUpBody body = SignUpBody(
        fullName: fullNameCtrl.text.trim(),
        cnic: cnicCtrl.text.replaceAll('-', '').trim(),
        phone: '+92${phoneCtrl.text.trim()}',
        password: passwordCtrl.text.trim(),
        referralCode: referralCtrl.text.trim().isEmpty
            ? null
            : referralCtrl.text.trim().toUpperCase(),
      );

      log.d('@requestSignUp: Attempting signup for ${body.phone}');

      final response = await _authService.registerWithPhoneAndPassword(body);

      if (response.success) {
        log.d('@requestSignUp: OTP sent — navigating to OTP screen');
        _clearControllers();
        Get.to(
          () => const OtpScreen(),
          arguments: {'phone': body.phone, 'signUpBody': body},
        );
      } else {
        log.e('@requestSignUp: Failed — ${response.error}');
        _showSignUpError(response.error ?? 'generic');
      }
    } on AppException catch (e) {
      log.e('@requestSignUp AppException: ${e.devMessage}');
      _showErrorDialog('Sign Up Failed', e.userMessage);
    } catch (e, stackTrace) {
      log.e('@requestSignUp Exception: $e\n$stackTrace');
      if (AppExceptions.isNetworkError(e)) {
        _showErrorDialog(
          'No Internet Connection',
          'Please check your internet connection and try again.',
        );
      } else {
        _showErrorDialog(
          'Sign Up Failed',
          'Something went wrong. Please try again.',
        );
      }
    }

    setState(ViewState.idle);
  }

  void _showSignUpError(String errorCode) {
    switch (errorCode) {
      case 'already_exists':
        _showErrorDialog(
          'Account Already Exists',
          'An account with this phone number already exists. Please login instead.',
        );
        break;
      case 'cnic_taken':
        _showErrorDialog(
          'NIC Already Registered',
          'This NIC is already registered with another phone number.',
        );
        break;
      case 'weak_password':
        _showErrorDialog(
          'Weak Password',
          'Your password is too weak. Please use at least 8 characters with a mix of letters and numbers.',
        );
        break;
      case 'signup_disabled':
      case 'provider_disabled':
        _showErrorDialog(
          'Registration Unavailable',
          'New registrations are currently disabled. Please try again later.',
        );
        break;
      case 'rate_limited':
        _showErrorDialog(
          'Too Many Attempts',
          'Too many attempts. Please wait a few minutes and try again.',
        );
        break;
      case 'sms_failed':
        _showErrorDialog(
          'SMS Failed',
          'Failed to send verification SMS. Please check your phone number and try again.',
        );
        break;
      case 'timeout':
      case 'network_error':
        _showErrorDialog(
          'No Internet Connection',
          'Unable to connect. Please check your internet connection and try again.',
        );
        break;
      case 'validation_failed':
        _showErrorDialog(
          'Invalid Information',
          'The information you entered is not valid. Please check and try again.',
        );
        break;
      case 'server_error':
        _showErrorDialog(
          'Server Error',
          'Something went wrong on our end. Please try again shortly.',
        );
        break;
      case 'signup_failed':
      case 'generic':
      default:
        _showErrorDialog(
          'Sign Up Failed',
          'Unable to create your account. Please try again.',
        );
    }
  }

  void onSignInPressed() {
    Get.to(LoginScreen());
  }

  void _showErrorDialog(String title, String message) {
    Get.dialog(AppDialog(title: title, message: message));
  }

  void _clearControllers() {
    fullNameCtrl.clear();
    cnicCtrl.clear();
    phoneCtrl.clear();
    passwordCtrl.clear();
    referralCtrl.clear();
  }

  @override
  void dispose() {
    fullNameCtrl.dispose();
    cnicCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    referralCtrl.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }
}
