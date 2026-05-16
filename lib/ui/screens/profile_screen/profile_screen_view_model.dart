import 'package:enzer_app/core/enums/view_state.dart';
import 'package:enzer_app/core/models/invited_user.dart';
import 'package:enzer_app/core/others/base_view_model.dart';
import 'package:enzer_app/core/others/logger_customizations/custom_logger.dart';
import 'package:enzer_app/core/services/auth_service.dart';
import 'package:enzer_app/core/services/referral_service.dart';
import 'package:enzer_app/core/services/supabase_service.dart';
import 'package:enzer_app/locator.dart';
import 'package:enzer_app/ui/custom_widgets/dialogs/app_dialog.dart';
import 'package:enzer_app/ui/screens/auth_signup/login/login_screen.dart';
import 'package:enzer_app/ui/screens/edit_profile/edit_profile_screen.dart';
import 'package:enzer_app/ui/screens/welcome_screen/welcome_screen.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileViewModel extends BaseViewModel {
  static final _log = CustomLogger(className: 'ProfileViewModel');
  final _supabase = locator<SupabaseService>();
  final _supabaseClient = Supabase.instance.client;
  final _auth = locator<AuthService>();
  final _referral = locator<ReferralService>();

  String _avatarCacheKey = DateTime.now().millisecondsSinceEpoch.toString();
  bool isRefreshing = false;
  RealtimeChannel? _channel;

  String? get avatarUrl {
    final url = _auth.userProfile?.avatarUrl;
    if (url == null || url.isEmpty) return null;
    return '$url?t=$_avatarCacheKey';
  }

  String userName = '';
  String cnic = '';
  int rank = 0;
  int totalInvites = 0;
  String referralCode = '';
  String referralLink = '';
  List<InvitedUser> invitedUsers = [];

  String get roleBadge => _auth.userProfile?.statusName ?? 'Starter';

  ProfileViewModel() {
    loadData();
    _subscribeToChanges();
  }

  void _subscribeToChanges() {
    final userId = _auth.userProfile?.id;
    if (userId == null) return;

    _channel = _supabaseClient
        .channel('profile:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'user_invites',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'inviter_user_id',
            value: userId,
          ),
          callback: (_) => _reloadWithRefresh(),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'user_invites',
          callback: (_) => _reloadWithRefresh(),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'profiles',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: userId,
          ),
          callback: (_) => _reloadWithRefresh(),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'user_invites',
          callback: (_) => _reloadWithRefresh(),
        )
        .subscribe();
  }

  Future<void> _reloadWithRefresh() async {
    isRefreshing = true;
    notifyListeners();
    await loadData();
    isRefreshing = false;
    notifyListeners();
  }

  Future<void> loadData() async {
    setState(ViewState.busy);
    try {
      final userId = _auth.userProfile?.id;
      if (userId == null) return;

      // refresh profile to get latest statusName from Supabase
      await _auth.refreshProfile();
      _log.d(
        'statusName: ${_auth.userProfile?.statusName} | roleBadge: $roleBadge',
      );

      final results = await Future.wait([
        _supabase.getUserLeaderboardEntry(userId),
        _supabase.getInvitedUsers(userId),
        _referral.getUserReferralCode(userId),
      ]);

      final leaderboardEntry = results[0] as Map<String, dynamic>?;
      final invites = results[1] as List<Map<String, dynamic>>;
      final code = results[2] as String?;

      userName = _auth.userProfile?.fullName ?? '';
      cnic = _auth.userProfile?.cnic ?? '';

      if (leaderboardEntry != null) {
        rank = (leaderboardEntry['rank'] as num).toInt();
        totalInvites = (leaderboardEntry['invite_count'] as num).toInt();
      }

      referralCode = code ?? '';

      invitedUsers = invites.asMap().entries.map((e) {
        final profile = e.value['profiles'] as Map<String, dynamic>?;
        return InvitedUser(
          no: e.key + 1,
          name: profile?['full_name'] ?? 'Unknown',
        );
      }).toList();

      if (referralCode.isNotEmpty) {
        referralLink =
            await _referral.getReferralLink(
              userId: userId,
              referralCode: referralCode,
            ) ??
            referralCode;
        _log.d('referralLink ready: $referralLink');
      }
    } catch (e) {
      _log.e('loadData error: $e');
    }
    setState(ViewState.idle);
  }

  Future<void> copyReferralCode() async {
    final text = referralCode;
    if (text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
    _log.d('Copied: $text');
  }

  Future<void> shareInviteLink() async {
    final text = referralLink.isNotEmpty ? referralLink : referralCode;
    // ignore: deprecated_member_use
    await Share.share(
      'Join me on Enzer — Shop Now, Pay Later!\nSign up using my referral link: $text',
      subject: 'Join Enzer App',
    );
    _log.d('Shared: $text');
  }

  Future<void> deleteAccount() async {
    try {
      setState(ViewState.busy);
      final userId =
          _auth.userProfile?.id ?? _supabaseClient.auth.currentUser?.id;
      if (userId == null) return;

      await _supabaseClient
          .from('profiles')
          .update({
            'is_deleted': true,
            'deleted_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      await _auth.logout();
      Get.offAll(() => const WelcomeScreen());
    } catch (e) {
      _log.e('deleteAccount error: $e');
      Get.dialog(
        AppDialog(
          title: 'Error',
          message: 'Failed to delete account. Please try again.',
        ),
      );
    }
    setState(ViewState.idle);
  }

  Future<void> getToEditScreen() async {
    await Get.to(EditProfileScreen());
    await _auth.refreshProfile();
    _avatarCacheKey = DateTime.now().millisecondsSinceEpoch.toString();
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _auth.logout();
      Get.offAll(LoginScreen());
    } catch (e) {
      _log.e('logout error: $e');
    }
  }

  @override
  void dispose() {
    if (_channel != null) _supabaseClient.removeChannel(_channel!);
    super.dispose();
  }
}
