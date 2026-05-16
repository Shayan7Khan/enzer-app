import 'package:enzer_app/core/exceptions/app_exceptions.dart';
import 'package:enzer_app/core/models/body/login_body.dart';
import 'package:enzer_app/core/models/body/signup_body.dart';
import 'package:enzer_app/core/models/other_models/user_profile.dart';
import 'package:enzer_app/core/models/responses/auth_response.dart';
// ignore: library_prefixes
import 'package:enzer_app/core/models/user.dart' as appModels;
import 'package:enzer_app/core/others/logger_customizations/custom_logger.dart';
import 'package:enzer_app/core/services/fcm_service.dart';
import 'package:enzer_app/core/services/local_storage_service.dart';
import 'package:enzer_app/core/services/supabase_service.dart';
import 'package:enzer_app/locator.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthResponse;

class AuthService {
  final _localStorage = locator<LocalStorageService>();
  final _supabase = locator<SupabaseService>();
  static final Logger _log = CustomLogger(className: 'AuthService');

  bool get isLoggedIn => _supabase.currentSession != null;
  bool isLogin = false;

  UserProfile? userProfile;
  appModels.User? currentUser;
  String? fcmToken;

  static final Logger log = CustomLogger(className: 'AuthService');

  Future<void> doSetup() async {
    final session = _supabase.currentSession;
    isLogin = session != null;
    if (isLogin) {
      log.d('User already logged in: ${session!.user.phone}');
      await _loadUserProfile(session.user.id);
      await locator<FCMService>().init();
      // profile is null means user was deleted from DB (force sign out)
      if (userProfile == null) {
        log.d('Profile not found — user deleted, signing out');
        await _supabase.signOut();
        isLogin = false;
      }
    } else {
      log.d('@doSetup: User is not logged in');
    }
  }

  // Load User Profile
  Future<void> _loadUserProfile(String userId) async {
    try {
      userProfile = await _supabase.getProfile(userId);
      log.d('Loaded user profile: ${userProfile?.toJson()}');
    } catch (e) {
      log.e('Error loading user profile: $e');
    }
  }

  Future<AuthResponse> registerWithPhoneAndPassword(SignUpBody body) async {
    try {
      if (await _supabase.isCnicRegistered(body.cnic!)) {
        return AuthResponse(false, error: AppExceptions.cnicTaken);
      }
      final response = await _supabase.signUp(
        normalizePhone(body.phone!),
        body.password!,
      );
      if (response.user == null) {
        return AuthResponse(false, error: AppExceptions.signupFailed);
      }
      _log.d('OTP sent to ${body.phone}');
      return AuthResponse(true);
    } on AuthException catch (e) {
      _log.e(
        'registerWithPhoneAndPassword: code=${e.code} message=${e.message}',
      );
      return AuthResponse(false, error: AppExceptions.handleAuthError(e));
    } catch (e, st) {
      _log.e('registerWithPhoneAndPassword: $e\n$st');
      if (AppExceptions.isNetworkError(e)) {
        return AuthResponse(false, error: AppExceptions.networkError);
      }
      return AuthResponse(false, error: AppExceptions.generic);
    }
  }

  /// Testing-only... will remove before production release.
  Future<AuthResponse> createProfileForMasterOtp(SignUpBody body) async {
    try {
      final user = _supabase.currentUser;
      final session = _supabase.currentSession;
      if (user == null || session == null) {
        return AuthResponse(false, error: AppExceptions.noSession);
      }

      final normalizedPhone = normalizePhone(body.phone!);

      // Save profile
      await _supabase.upsertProfile(user.id, body, normalizedPhone);

      // Process incoming referral if user signed up with one
      if (body.referralCode != null && body.referralCode!.isNotEmpty) {
        await _supabase.processReferral(
          referralCode: body.referralCode!,
          newUserId: user.id,
        );
      }

      // Load profile into memory
      userProfile = await _supabase.getProfile(user.id);

      _saveSession(session.accessToken);
      return AuthResponse(true, accessToken: session.accessToken);
    } catch (e, st) {
      _log.e('createProfileForMasterOtp: $e\n$st');
      return AuthResponse(false, error: AppExceptions.generic);
    }
  }

  //will be used in production
  Future<AuthResponse> verifyOtpAndFinalizeSignup(
    String otp,
    SignUpBody body,
  ) async {
    try {
      final normalizedPhone = normalizePhone(body.phone!);
      final response = await _supabase.verifyOtp(normalizedPhone, otp);
      final user = response.user;
      final session = response.session;

      if (user == null || session == null) {
        return AuthResponse(false, error: AppExceptions.otpFailed);
      }

      await _supabase.upsertProfile(user.id, body, normalizedPhone);

      if (body.referralCode != null && body.referralCode!.isNotEmpty) {
        await _supabase.processReferral(
          referralCode: body.referralCode!,
          newUserId: user.id,
        );
      }

      userProfile = await _supabase.getProfile(user.id);
      _saveSession(session.accessToken);
      return AuthResponse(true, accessToken: session.accessToken);
    } on AuthException catch (e) {
      _log.e('verifyOtpAndFinalizeSignup: code=${e.code} message=${e.message}');
      return AuthResponse(false, error: AppExceptions.handleAuthError(e));
    } catch (e, st) {
      _log.e('verifyOtpAndFinalizeSignup: $e\n$st');
      if (AppExceptions.isNetworkError(e)) {
        return AuthResponse(false, error: AppExceptions.networkError);
      }
      return AuthResponse(false, error: AppExceptions.generic);
    }
  }

  Future<AuthResponse> loginWithPhoneOrCnic(LoginBody body) async {
    try {
      final phone = await _resolvePhone(body);
      if (phone == null) {
        return AuthResponse(false, error: _resolvePhoneError(body));
      }

      final response = await _supabase.signIn(phone, body.password!);
      final user = response.user;
      final session = response.session;

      if (user == null || session == null) {
        return AuthResponse(false, error: AppExceptions.loginFailed);
      }
      _saveSession(session.accessToken);
      await _loadUserProfile(user.id);

      if (userProfile?.isDeleted == true) {
        await _supabase.signOut();
        isLogin = false;
        userProfile = null;
        return AuthResponse(false, error: 'account_deleted');
      }

      await locator<FCMService>().init();
      _log.d('Login success: ${user.phone}');
      return AuthResponse(true, accessToken: session.accessToken);
    } on AuthException catch (e) {
      _log.e('loginWithPhoneOrCnic: code=${e.code} message=${e.message}');
      return AuthResponse(false, error: AppExceptions.handleAuthError(e));
    } catch (e, st) {
      _log.e('loginWithPhoneOrCnic: $e\n$st');
      if (AppExceptions.isNetworkError(e)) {
        return AuthResponse(false, error: AppExceptions.networkError);
      }
      return AuthResponse(false, error: AppExceptions.generic);
    }
  }

  Future<void> updatePasswordByPhone(String phone, String newPassword) async {
    await _supabase.client.rpc(
      'update_user_password',
      params: {'user_phone': phone, 'new_password': newPassword},
    );
    _log.d('Password updated for $phone');
  }

  Future<bool> doesPhoneExist(String phone) async {
    return await _supabase.doesPhoneExist(phone);
  }

  Future<void> sendForgotPasswordOtp(String phone) async {
    await _supabase.sendOtp(phone);
  }

  Future<void> updatePassword(String newPassword) async {
    await _supabase.updatePassword(newPassword);
  }

  Future<String?> _resolvePhone(LoginBody body) async {
    if (body.phone?.isNotEmpty == true) {
      return normalizePhone(body.phone!);
    }
    if (body.cnic?.isNotEmpty == true) {
      return _supabase.getPhoneByCnic(body.cnic!);
    }
    return null;
  }

  Future<void> refreshProfile() async {
    try {
      final userId = _supabase.currentUser?.id;
      if (userId == null) return;
      userProfile = await _supabase.getProfile(userId);
      _log.d('Profile refreshed: ${userProfile?.toJson()}');
    } catch (e) {
      _log.e('refreshProfile error: $e');
    }
  }

  String _resolvePhoneError(LoginBody body) => body.cnic?.isNotEmpty == true
      ? AppExceptions.cnicNotFound
      : AppExceptions.missingCredentials;

  Future<void> logout() async {
    try {
      await _supabase.signOut();
      isLogin = false;
      userProfile = null;
      currentUser = null;
      _localStorage.clearUserData();
      _log.d('User logged out');
    } catch (e, st) {
      _log.e('logout: $e\n$st');
    }
  }

  Future<bool> isOldPassword(String phone, String password) async {
    return await _supabase.isOldPassword(phone, password);
  }

  static String normalizePhone(String phone) {
    final trimmed = phone.trim();
    return trimmed.startsWith('+') ? trimmed : '+$trimmed';
  }

  void _saveSession(String accessToken) {
    _localStorage.accessToken = accessToken;
    _localStorage.isLoggedIn = true;
    _log.d('Session saved');
  }

  void signupWithApple() {}
  void signupWithGmail() {}
  void signupWithFacebook() {}
}
