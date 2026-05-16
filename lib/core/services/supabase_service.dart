import 'package:enzer_app/core/error/supabase_error_handler.dart';
import 'package:enzer_app/core/models/body/signup_body.dart';
import 'package:enzer_app/core/models/other_models/user_profile.dart';
import 'package:enzer_app/core/others/logger_customizations/custom_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final log = CustomLogger(className: 'Supabase Service Class');
  final _supabase = Supabase.instance.client;

  SupabaseClient get client => _supabase;
  Session? get currentSession => _supabase.auth.currentSession;
  User? get currentUser => _supabase.auth.currentUser;

  //signup
  Future<AuthResponse> signUp(String phone, String password) async {
    try {
      return await _supabase.auth.signUp(phone: phone, password: password);
    } catch (e) {
      throw SupabaseErrorHandler.handle(e);
    }
  }

  //verify otp
  Future<AuthResponse> verifyOtp(String phone, String token) async {
    try {
      return await _supabase.auth.verifyOTP(
        phone: phone,
        token: token,
        type: OtpType.sms,
      );
    } catch (e) {
      throw SupabaseErrorHandler.handle(e);
    }
  }

  //signin
  Future<AuthResponse> signIn(String phone, String password) async {
    try {
      return await _supabase.auth.signInWithPassword(
        phone: phone,
        password: password,
      );
    } catch (e) {
      throw SupabaseErrorHandler.handle(e);
    }
  }

  //signout
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw SupabaseErrorHandler.handle(e);
    }
  }

  //sendOtp
  Future<void> sendOtp(String phone) async {
    try {
      await _supabase.auth.signInWithOtp(phone: phone);
    } catch (e) {
      throw SupabaseErrorHandler.handle(e);
    }
  }

  //update password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      throw SupabaseErrorHandler.handle(e);
    }
  }

  //
  Future<bool> isCnicRegistered(String cnic) async {
    try {
      final result = await _supabase
          .from('profiles')
          .select('phone')
          .eq('cnic', cnic)
          .maybeSingle();
      return result != null;
    } catch (e) {
      throw SupabaseErrorHandler.handle(e);
    }
  }

  Future<String?> getPhoneByCnic(String cnic) async {
    try {
      final result = await _supabase
          .from('profiles')
          .select('phone')
          .eq('cnic', cnic)
          .maybeSingle();
      return result?['phone'] as String?;
    } catch (e) {
      throw SupabaseErrorHandler.handle(e);
    }
  }

  Future<void> upsertProfile(
    String userId,
    SignUpBody body,
    String normalizedPhone,
  ) async {
    try {
      // get starter status id
      final statusData = await _supabase
          .from('member_statuses')
          .select('id')
          .eq('name', 'Starter')
          .single();

      await _supabase.from('profiles').upsert({
        'id': userId,
        'full_name': body.fullName,
        'cnic': body.cnic,
        'phone': normalizedPhone,
        'signup_referral_code': body.referralCode,
        'status_id': statusData['id'],
        'created_at': DateTime.now().toIso8601String(),
      });
      log.d('Profile upserted for $userId');
    } catch (e) {
      log.e('upsertProfile failed: $e');
      throw SupabaseErrorHandler.handle(e);
    }
  }

  Future<UserProfile?> getProfile(String userId) async {
    try {
      final data = await _supabase
          .from('profiles')
          .select('*, member_statuses!profiles_status_id_fkey(name)')
          .eq('id', userId)
          .single();
      return UserProfile.fromJson(data);
    } catch (e) {
      log.e('getProfile failed: $e');
      if (e is PostgrestException && e.code == 'PGRST116') return null;
      throw SupabaseErrorHandler.handle(e);
    }
  }

  Future<bool> doesPhoneExist(String phone) async {
    try {
      final result = await _supabase
          .from('profiles')
          .select('phone')
          .eq('phone', phone)
          .maybeSingle();
      return result != null;
    } catch (e) {
      throw SupabaseErrorHandler.handle(e);
    }
  }

  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 10}) async {
    try {
      final data = await _supabase
          .from('leaderboard')
          .select()
          .order('rank', ascending: true)
          .limit(limit);
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      throw SupabaseErrorHandler.handle(e);
    }
  }

  Future<Map<String, dynamic>?> getUserLeaderboardEntry(String userId) async {
    try {
      final data = await _supabase
          .from('leaderboard')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return data;
    } catch (e) {
      throw SupabaseErrorHandler.handle(e);
    }
  }

  /// Fetches reward tiers from DB (table: reward_tiers).
  /// Expected columns: threshold (int), title (text), description (text). Optional: sort_order (int).
  /// Returns empty list if table missing or query fails (UI uses static fallback).
  Future<List<Map<String, dynamic>>> getRewardTiers() async {
    try {
      final data = await _supabase
          .from('reward_tiers')
          .select('threshold, title, description, sort_order')
          .order('threshold', ascending: true);
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      // PGRST205 = table not found; expected until reward_tiers table is created
      if (e.toString().contains('PGRST205')) return [];
      log.d('getRewardTiers failed: $e');
      return [];
    }
  }

  Future<int> getTotalWaitlistCount() async {
    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .count(CountOption.exact);
      return data.count;
    } catch (e) {
      throw SupabaseErrorHandler.handle(e);
    }
  }

  Future<List<Map<String, dynamic>>> getInvitedUsers(String userId) async {
    try {
      final data = await _supabase
          .from('user_invites')
          .select('invited_user_id, profiles!invited_user_id(full_name)')
          .eq('inviter_user_id', userId)
          .order('created_at');
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      // PGRST200 = relationship/join error — check your FK setup in Supabase
      log.e('getInvitedUsers failed (check FK relationships): $e');
      throw SupabaseErrorHandler.handle(e);
    }
  }

  Future<String?> getUserReferralCode(String userId) async {
    try {
      final data = await _supabase
          .from('referrals')
          .select('code')
          .eq('user_id', userId)
          .maybeSingle();
      return data?['code'] as String?;
    } catch (e) {
      throw SupabaseErrorHandler.handle(e);
    }
  }

  Future<void> insertReferralCode(String userId, String code) async {
    try {
      await _supabase.from('referrals').upsert({
        'user_id': userId,
        'code': code,
        'created_at': DateTime.now().toIso8601String(),
      });
      log.d('Referral code inserted: $code for $userId');
    } catch (e) {
      log.e('insertReferralCode failed: $e');
      throw SupabaseErrorHandler.handle(e);
    }
  }

  Future<void> processReferral({
    required String referralCode,
    required String newUserId,
  }) async {
    try {
      // get the referrals row (need the row ID for the FK, not just user_id)
      final referrerData = await _supabase
          .from('referrals')
          .select('id, user_id')
          .eq('code', referralCode)
          .maybeSingle();

      if (referrerData == null) {
        log.e('processReferral: No referrer found for code $referralCode');
        return; // invalid code — just skip, don't crash signup
      }

      final referrerId = referrerData['user_id'] as String;
      final referralRowId = referrerData['id'] as String; // referrals.id for FK

      // prevent self-referral
      if (referrerId == newUserId) {
        log.w('processReferral: self-referral attempted, skipping');
        return;
      }

      // insert user_invites row — trigger fires notify_on_referral
      await _supabase.from('user_invites').insert({
        'inviter_user_id': referrerId,
        'invited_user_id': newUserId,
        'referral_code': referralCode,
        'created_at': DateTime.now().toIso8601String(),
      });

      // update profile with referral row ID (FK points to referrals.id not user_id)
      await _supabase
          .from('profiles')
          .update({'signup_referral_id': referralRowId})
          .eq('id', newUserId);

      log.d('processReferral done: $referrerId invited $newUserId');
    } catch (e) {
      if (e is PostgrestException && e.code == '23505') {
        log.w('processReferral: duplicate invite ignored for $newUserId');
        return; // already invited — not an error
      }
      // log but don't rethrow — referral failure should NOT block signup
      log.e('processReferral failed: $e');
    }
  }

  Future<bool> isOldPassword(String phone, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        phone: normalizePhone(phone),
        password: password,
      );
      return response.user != null;
    } catch (e) {
      // For this check, a failure just means "not the old password"
      return false;
    }
  }

  String normalizePhone(String phone) =>
      phone.startsWith('+') ? phone.substring(1) : phone;
}
