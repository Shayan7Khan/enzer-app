import 'package:supabase_flutter/supabase_flutter.dart';

class AppExceptions {
  AppExceptions._();

  static String handleAuthError(AuthException e) {
    switch (e.code) {
      case 'invalid_credentials':
        return 'incorrect_credentials';
      case 'user_not_found':
        return 'user_not_found';
      case 'user_already_exists':
      case 'phone_exists':
      case 'email_exists':
        return 'already_exists';
      case 'user_banned':
        return 'user_banned';
      case 'phone_not_confirmed':
        return 'phone_not_confirmed';
      case 'phone_provider_disabled':
        return 'provider_disabled';
      case 'signup_disabled':
        return 'signup_disabled';
      case 'otp_expired':
        return 'otp_expired';
      case 'otp_disabled':
        return 'otp_disabled';
      case 'over_request_rate_limit':
      case 'over_sms_send_rate_limit':
      case 'over_email_send_rate_limit':
        return 'rate_limited';
      case 'weak_password':
        return 'weak_password';
      case 'session_expired':
      case 'session_not_found':
      case 'refresh_token_not_found':
      case 'refresh_token_already_used':
        return 'session_expired';
      case 'request_timeout':
        return 'timeout';
      case 'unexpected_failure':
        return 'server_error';
      case 'validation_failed':
        return 'validation_failed';
      case 'bad_jwt':
        return 'session_expired';
      case 'conflict':
        return 'conflict';
      case 'sms_send_failed':
        return 'sms_failed';
      default:
        return 'unknown_auth_error:${e.code}:${e.message}';
    }
  }

  static bool isNetworkError(dynamic e) {
    final msg = e.toString().toLowerCase();
    return msg.contains('socketexception') ||
        msg.contains('network') ||
        msg.contains('connection') ||
        msg.contains('internet') ||
        msg.contains('host lookup') ||
        msg.contains('no address associated') ||
        msg.contains('connection refused') ||
        msg.contains('connection reset') ||
        msg.contains('handshake') ||
        msg.contains('timeout') ||
        msg.contains('timed out');
  }

  static String handleDatabaseError(Object e) {
    final message = e.toString().toLowerCase();
    if (message.contains('duplicate') || message.contains('unique')) {
      return 'This record already exists.';
    }
    if (message.contains('foreign key') || message.contains('violates')) {
      return 'Invalid reference. Please try again.';
    }
    if (message.contains('network') || message.contains('connection')) {
      return 'No internet connection. Please try again.';
    }
    if (message.contains('permission') || message.contains('not authorized')) {
      return 'You do not have permission to perform this action.';
    }
    return 'Something went wrong. Please try again.';
  }

  static const String generic = 'generic';
  static const String noSession = 'no_session';
  static const String loginFailed = 'login_failed';
  static const String signupFailed = 'signup_failed';
  static const String otpFailed = 'otp_failed';
  static const String cnicNotFound = 'cnic_not_found';
  static const String missingCredentials = 'missing_credentials';
  static const String cnicTaken = 'cnic_taken';
  static const String networkError = 'network_error';
}
