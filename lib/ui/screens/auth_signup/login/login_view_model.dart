import 'package:enzer_app/core/error/app_exception.dart';
import 'package:enzer_app/core/enums/view_state.dart';
import 'package:enzer_app/core/exceptions/app_exceptions.dart';
import 'package:enzer_app/core/models/body/login_body.dart';
import 'package:enzer_app/core/others/base_view_model.dart';
import 'package:enzer_app/core/others/logger_customizations/custom_logger.dart';
import 'package:enzer_app/core/services/auth_service.dart';
import 'package:enzer_app/locator.dart';
import 'package:enzer_app/ui/custom_widgets/dialogs/app_dialog.dart';
import 'package:enzer_app/ui/screens/auth_signup/forget_password/forget_password_screen.dart';
import 'package:enzer_app/ui/screens/auth_signup/signup_screen/sign_up_screen.dart';
import 'package:enzer_app/ui/screens/root/root_screen.dart';
import 'package:enzer_app/ui/screens/root/root_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LoginViewModel extends BaseViewModel {
  final log = CustomLogger(className: 'LoginViewModel');
  final AuthService _authService = locator<AuthService>();

  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController cnicCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;
  bool isPhoneTab = true;
  String? errorMessage;

  void switchTab(bool toPhone) {
    if (isPhoneTab == toPhone) return;
    isPhoneTab = toPhone;
    errorMessage = null;
    phoneCtrl.clear();
    cnicCtrl.clear();
    passwordCtrl.clear();
    notifyListeners();
  }

  String? validatePhone(String? val) {
    if (val == null || val.trim().isEmpty) return 'Phone number is required';
    if (val.trim().length != 11) return 'Enter a valid 11-digit number';
    return null;
  }

  String? validateNic(String? val) {
    final clean = val?.replaceAll('-', '') ?? '';
    if (clean.isEmpty) return 'NIC is required';
    if (clean.length != 13) return 'Enter a valid 13-digit NIC';
    return null;
  }

  String? validatePassword(String? val) {
    if (val == null || val.isEmpty) return 'Password is required';
    if (val.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    errorMessage = null;
    notifyListeners();

    try {
      setState(ViewState.busy);

      final LoginBody body = LoginBody(
        phone: isPhoneTab ? '+92${phoneCtrl.text.trim()}' : null,
        cnic: isPhoneTab ? null : cnicCtrl.text.replaceAll('-', '').trim(),
        password: passwordCtrl.text.trim(),
      );

      log.d('@login: Attempting with ${isPhoneTab ? 'phone' : 'NIC'}');

      final response = await _authService.loginWithPhoneOrCnic(body);

      if (response.success) {
        log.d('@login: Success');
        Get.context?.read<RootScreenViewModel>().updatedScreenIndex(0);
        Get.offAll(() => RootScreen());
      } else {
        log.e('@login: Failed — ${response.error}');
        _showLoginError(response.error ?? 'generic');
      }
    } on AppException catch (e) {
      log.e('@login AppException: ${e.devMessage}');
      _showErrorDialog('Login Failed', e.userMessage);
    } catch (e, stackTrace) {
      log.e('@login Unexpected: $e\n$stackTrace');
      if (AppExceptions.isNetworkError(e)) {
        _showErrorDialog(
          'No Internet Connection',
          'Please check your internet connection and try again.',
        );
      } else {
        _showErrorDialog(
          'Login Failed',
          'Something went wrong. Please try again.',
        );
      }
    }

    setState(ViewState.idle);
  }

  void _showLoginError(String errorCode) {
    switch (errorCode) {
      case 'incorrect_credentials':
        _showErrorDialog(
          'Incorrect Credentials',
          isPhoneTab
              ? 'The phone number or password you entered is incorrect. Please try again.'
              : 'The NIC or password you entered is incorrect. Please try again.',
        );
        break;
      case 'user_not_found':
      case 'cnic_not_found':
        _showErrorDialog(
          'Account Not Found',
          'No account found with these details. Please sign up first.',
        );
        break;
      case 'user_banned':
        _showErrorDialog(
          'Account Suspended',
          'Your account has been suspended. Please contact support.',
        );
        break;
      case 'account_deleted':
        _showErrorDialog(
          'Account Deleted',
          'This account has been deleted. Please contact support to recover it.',
        );
        break;
      case 'phone_not_confirmed':
        _showErrorDialog(
          'Phone Not Verified',
          'Your phone number has not been verified. Please verify your number first.',
        );
        break;
      case 'provider_disabled':
      case 'signup_disabled':
        _showErrorDialog(
          'Service Unavailable',
          'This service is currently unavailable. Please try again later.',
        );
        break;
      case 'session_expired':
        _showErrorDialog(
          'Session Expired',
          'Your session has expired. Please log in again.',
        );
        break;
      case 'rate_limited':
        _showErrorDialog(
          'Too Many Attempts',
          'Too many login attempts. Please wait a few minutes and try again.',
        );
        break;
      case 'timeout':
      case 'network_error':
        _showErrorDialog(
          'No Internet Connection',
          'Unable to connect. Please check your internet connection and try again.',
        );
        break;
      case 'server_error':
        _showErrorDialog(
          'Server Error',
          'Something went wrong on our end. Please try again shortly.',
        );
        break;
      case 'missing_credentials':
        _showErrorDialog(
          'Missing Information',
          'Please provide your phone number or NIC.',
        );
        break;
      case 'login_failed':
      case 'generic':
      default:
        _showErrorDialog(
          'Login Failed',
          'Unable to log in. Please check your details and try again.',
        );
    }
  }

  void _showErrorDialog(String title, String message) {
    Get.dialog(AppDialog(title: title, message: message));
  }

  void onForgotPassword() {
    Get.to(ForgotPasswordScreen());
  }

  void onSignUpPressed() {
    Get.to(SignUpScreen());
  }

  @override
  void dispose() {
    phoneCtrl.dispose();
    cnicCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }
}
