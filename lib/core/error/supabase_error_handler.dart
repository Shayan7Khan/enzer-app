import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_exception.dart';

class SupabaseErrorHandler {
  SupabaseErrorHandler._();

  static AppException handle(dynamic error) {
    if (error is PostgrestException) {
      return _handlePostgrestError(error);
    }
    if (error is AuthException) {
      return _handleAuthError(error);
    }
    return AppException(
      userMessage: 'Something went wrong. Please try again.',
      devMessage: 'Unhandled error type: ${error.runtimeType} — $error',
      originalError: error,
    );
  }

  static AppException _handlePostgrestError(PostgrestException e) {
    switch (e.code) {
      case '23503':
        return AppException(
          userMessage: 'Related record not found. Please try again.',
          devMessage:
              'Foreign key violation: ${e.message} | details: ${e.details}',
          originalError: e,
        );
      case '23505':
        return AppException(
          userMessage:
              'This record already exists. (Phone or CNIC may already be registered.)',
          devMessage:
              'Uniqueness violation: ${e.message} | details: ${e.details}',
          originalError: e,
        );
      case '42501':
        return AppException(
          userMessage: 'You don\'t have permission to do this.',
          devMessage: 'RLS / insufficient privileges: ${e.message}',
          originalError: e,
        );
      case '42883':
        return AppException(
          userMessage:
              'A server function was not found. Please contact support.',
          devMessage: 'Undefined function: ${e.message}',
          originalError: e,
        );
      case '42P01':
        return AppException(
          userMessage: 'A server error occurred. Please contact support.',
          devMessage: 'Undefined table: ${e.message}',
          originalError: e,
        );
      case 'PGRST116':
        return AppException(
          userMessage: 'No matching record was found.',
          devMessage:
              'PGRST116 — .single() returned 0 or multiple rows: ${e.message}',
          originalError: e,
        );
      case 'PGRST200':
        return AppException(
          userMessage: 'Could not load related data. Please try again.',
          devMessage: 'PGRST200 — Stale/missing FK relationship: ${e.message}',
          originalError: e,
        );
      case 'PGRST204':
        return AppException(
          userMessage: 'A server error occurred. Please contact support.',
          devMessage: 'PGRST204 — Column not found: ${e.message}',
          originalError: e,
        );
      case 'PGRST301':
        return AppException(
          userMessage: 'Your session has expired. Please log in again.',
          devMessage: 'PGRST301 — Invalid/expired JWT: ${e.message}',
          originalError: e,
        );
      case 'PGRST302':
        return AppException(
          userMessage: 'Please log in to continue.',
          devMessage:
              'PGRST302 — Missing auth header or anon role disabled: ${e.message}',
          originalError: e,
        );
      default:
        return AppException(
          userMessage: 'A database error occurred. Please try again.',
          devMessage:
              'Unhandled PostgrestException — code: ${e.code} | message: ${e.message} | details: ${e.details}',
          originalError: e,
        );
    }
  }

  static AppException _handleAuthError(AuthException e) {
    switch (e.code) {
      case 'invalid_credentials':
        return AppException(
          userMessage: 'Incorrect phone number or password. Please try again.',
          devMessage: 'Auth — invalid_credentials: ${e.message}',
          originalError: e,
        );
      case 'user_not_found':
        return AppException(
          userMessage:
              'No account found with these details. Please sign up first.',
          devMessage: 'Auth — user_not_found: ${e.message}',
          originalError: e,
        );
      case 'user_already_exists':
      case 'phone_exists':
      case 'email_exists':
        return AppException(
          userMessage:
              'An account with this phone number already exists. Please login instead.',
          devMessage: 'Auth — user_already_exists/phone_exists: ${e.message}',
          originalError: e,
        );
      case 'user_banned':
        return AppException(
          userMessage:
              'Your account has been suspended. Please contact support.',
          devMessage: 'Auth — user_banned: ${e.message}',
          originalError: e,
        );
      case 'phone_not_confirmed':
        return AppException(
          userMessage:
              'Your phone number has not been verified. Please verify your number first.',
          devMessage: 'Auth — phone_not_confirmed: ${e.message}',
          originalError: e,
        );
      case 'phone_provider_disabled':
        return AppException(
          userMessage:
              'Phone sign in is currently unavailable. Please contact support.',
          devMessage: 'Auth — phone_provider_disabled: ${e.message}',
          originalError: e,
        );
      case 'signup_disabled':
        return AppException(
          userMessage:
              'New registrations are currently disabled. Please try again later.',
          devMessage: 'Auth — signup_disabled: ${e.message}',
          originalError: e,
        );
      case 'otp_expired':
        return AppException(
          userMessage: 'Your OTP has expired. Please request a new one.',
          devMessage: 'Auth — otp_expired: ${e.message}',
          originalError: e,
        );
      case 'otp_disabled':
        return AppException(
          userMessage:
              'OTP sign in is currently disabled. Please try another method.',
          devMessage: 'Auth — otp_disabled: ${e.message}',
          originalError: e,
        );
      case 'over_request_rate_limit':
      case 'over_sms_send_rate_limit':
      case 'over_email_send_rate_limit':
        return AppException(
          userMessage:
              'Too many attempts. Please wait a few minutes and try again.',
          devMessage: 'Auth — rate_limit: ${e.message}',
          originalError: e,
        );
      case 'weak_password':
        return AppException(
          userMessage:
              'Your password is too weak. Please use at least 8 characters with a mix of letters and numbers.',
          devMessage: 'Auth — weak_password: ${e.message}',
          originalError: e,
        );
      case 'session_expired':
      case 'session_not_found':
      case 'refresh_token_not_found':
      case 'refresh_token_already_used':
        return AppException(
          userMessage: 'Your session has expired. Please log in again.',
          devMessage: 'Auth — session_expired/not_found: ${e.message}',
          originalError: e,
        );
      case 'request_timeout':
        return AppException(
          userMessage:
              'Request timed out. Please check your connection and try again.',
          devMessage: 'Auth — request_timeout: ${e.message}',
          originalError: e,
        );
      case 'unexpected_failure':
        return AppException(
          userMessage:
              'Something went wrong on our end. Please try again shortly.',
          devMessage: 'Auth — unexpected_failure: ${e.message}',
          originalError: e,
        );
      case 'validation_failed':
        return AppException(
          userMessage:
              'The information you entered is not valid. Please check and try again.',
          devMessage: 'Auth — validation_failed: ${e.message}',
          originalError: e,
        );
      case 'bad_jwt':
        return AppException(
          userMessage: 'Your session is invalid. Please log in again.',
          devMessage: 'Auth — bad_jwt: ${e.message}',
          originalError: e,
        );
      case 'conflict':
        return AppException(
          userMessage: 'A conflict occurred. Please try again.',
          devMessage: 'Auth — conflict: ${e.message}',
          originalError: e,
        );
      case 'sms_send_failed':
        return AppException(
          userMessage:
              'Failed to send SMS. Please check your phone number and try again.',
          devMessage: 'Auth — sms_send_failed: ${e.message}',
          originalError: e,
        );
      default:
        return AppException(
          userMessage: 'Authentication failed. Please try again.',
          devMessage:
              'Unhandled AuthException — code: ${e.code} | message: ${e.message} | statusCode: ${e.statusCode}',
          originalError: e,
        );
    }
  }
}
