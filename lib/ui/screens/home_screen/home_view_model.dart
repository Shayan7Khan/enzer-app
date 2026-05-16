import 'package:enzer_app/core/constants/image_path.dart';
import 'package:enzer_app/core/enums/view_state.dart';
import 'package:enzer_app/core/models/leader_board_entry.dart';
import 'package:enzer_app/core/models/reward_tier.dart';
import 'package:enzer_app/core/others/base_view_model.dart';
import 'package:enzer_app/core/others/logger_customizations/custom_logger.dart';
import 'package:enzer_app/core/services/auth_service.dart';
import 'package:enzer_app/core/services/referral_service.dart';
import 'package:enzer_app/core/services/supabase_service.dart';
import 'package:enzer_app/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeViewModel extends BaseViewModel {
  final log = CustomLogger(className: 'HomeViewModel');
  final _supabase = locator<SupabaseService>();
  final _supabaseClient = Supabase.instance.client;
  final _auth = locator<AuthService>();
  final _referral = locator<ReferralService>();

  bool isRewardsTab = true;
  int userRank = 0;
  int totalWaitlist = 0;
  int userInviteCount = 0;
  String _referralCode = '';
  String _referralLink = '';
  bool isRefreshing = false;
  VoidCallback? onRefreshNeeded;

  RealtimeChannel? _channel;

  final currentUserKey = GlobalKey();
  final PageController cardPageController = PageController();

  int currentCardPage = 0;

  bool get showFloatingCard {
    final inPodium = topThree.any((e) => e.rank == currentUser.rank);
    final inRestList = restOfLeaderboard.any((e) => e.rank == currentUser.rank);
    return !inPodium && !inRestList && currentUser.rank != 0;
  }

  // card data
  final List<String> cardAssets = [
    premiumCardImage,
    executiveCardImage,
    enzerFamilyClubCardImage,
  ];

  final List<int> cardThresholds = [5, 10, 20];

  final List<String> cardTitles = [
    'Unlock the Premium Card',
    'Unlock the Executive Card',
    'Unlock the Enzer Founder Club',
  ];

  final List<String> cardDescriptions = [
    'Enjoy up to 50k limit with simple payments \nacross 4 instalments.',
    'Enjoy up to 150k shopping limit with simple \npayments in 12 instalments.',
    'Get up to 200,000 shopping limit with exclusive \nperks and 18-month instalments.',
  ];

  double cardProgress(int cardIndex) {
    final threshold = cardThresholds[cardIndex];
    return (userInviteCount / threshold).clamp(0.0, 1.0);
  }

  String cardProgressLabel(int cardIndex) {
    final threshold = cardThresholds[cardIndex];
    final count = userInviteCount.clamp(0, threshold);
    return '$count / $threshold Friends';
  }

  String cardGoalText(int cardIndex) {
    final threshold = cardThresholds[cardIndex];
    if (userInviteCount >= threshold) {
      return cardIndex == cardThresholds.length - 1
          ? '🎉 You are part of the Enzer Founder Club!'
          : '🎉 Unlocked! Swipe to see next reward.';
    }
    final remaining = threshold - userInviteCount;
    return 'Invite $remaining more friend${remaining == 1 ? '' : 's'} to unlock!';
  }

  // reward tiers for rewards section (fallback when no DB)
  static const List<int> _tierThresholds = [1, 3, 5, 10, 20];
  static const List<String> _tierTitles = [
    'Invite 1 Confirm Friend',
    'Invite 3 Confirm Friends',
    'Invite 5 Confirm Friends',
    'Invite 10 Confirm Friends',
    'Enzer Founder Club',
  ];
  static const List<String> _tierDescriptions = [
    '5% discount on Installment.',
    '10% discount on Installment.',
    'Reward Enzer Premium Card.',
    'Reward Enzer Executive card',
    'Minimum 20 confirm invitations to be eligible in the pool.',
  ];

  List<Map<String, dynamic>> _rewardTiersFromDb = [];

  List<RewardTier> get rewardTiers {
    if (_rewardTiersFromDb.isNotEmpty) {
      return _rewardTiersFromDb.map((row) {
        final threshold = (row['threshold'] as num?)?.toInt() ?? 0;
        return RewardTier(
          title: row['title'] as String? ?? '',
          description: row['description'] as String? ?? '',
          isCompleted: userInviteCount >= threshold,
        );
      }).toList();
    }
    return List.generate(
      _tierThresholds.length,
      (i) => RewardTier(
        title: _tierTitles[i],
        description: _tierDescriptions[i],
        isCompleted: userInviteCount >= _tierThresholds[i],
      ),
    );
  }

  List<LeaderboardEntry> topThree = [];
  List<LeaderboardEntry> restOfLeaderboard = [];
  LeaderboardEntry currentUser = LeaderboardEntry(
    rank: 0,
    name: 'You',
    invites: 0,
  );

  HomeViewModel() {
    loadData();
    _subscribeToChanges();
  }

  void _subscribeToChanges() {
    final userId = _auth.userProfile?.id;
    if (userId == null) return;

    _channel = _supabaseClient
        .channel('home:$userId')
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

      await _auth.refreshProfile();

      final results = await Future.wait([
        _supabase.getLeaderboard(limit: 50),
        _supabase.getTotalWaitlistCount(),
        if (userId != null)
          _supabase.getUserLeaderboardEntry(userId)
        else
          Future.value(null),
        if (userId != null)
          _referral.getUserReferralCode(userId)
        else
          Future.value(null),
        _supabase.getRewardTiers(),
      ]);

      final leaderboard = results[0] as List<Map<String, dynamic>>;
      totalWaitlist = results[1] as int;
      final userEntry = results[2] as Map<String, dynamic>?;
      _referralCode = (results[3] as String?) ?? '';
      _rewardTiersFromDb = results[4] as List<Map<String, dynamic>>;

      final allEntries = leaderboard.asMap().entries.map((e) {
        final data = e.value;
        return LeaderboardEntry(
          rank: (data['rank'] as num).toInt(),
          name: data['full_name'] ?? 'Unknown',
          invites: (data['invite_count'] as num).toInt(),
        );
      }).toList();

      if (userEntry != null) {
        userRank = userEntry['rank'] as int;
        userInviteCount = (userEntry['invite_count'] as num).toInt();
        currentUser = LeaderboardEntry(
          rank: userRank,
          name: '${_auth.userProfile?.fullName ?? 'You'} (You)',
          invites: userInviteCount,
        );
        log.d(
          'userInviteCount: $userInviteCount | '
          'rewardTiers: ${rewardTiers.map((t) => '${t.title}: ${t.isCompleted}').toList()}',
        );
      }

      topThree = allEntries.where((e) => e.rank <= 3).toList();
      log.d('topThree count: ${topThree.length}');
      log.d(
        'topThree: ${topThree.map((e) => 'rank=${e.rank} name=${e.name} invites=${e.invites}').toList()}',
      );
      log.d('allEntries count: ${allEntries.length}');
      log.d(
        'allEntries: ${allEntries.map((e) => 'rank=${e.rank} name=${e.name}').toList()}',
      );

      log.d(
        'topThree: ${topThree.map((e) => 'rank=${e.rank} name=${e.name}').toList()}',
      );

      final rest = allEntries.where((e) => e.rank > 3).toList()
        ..sort((a, b) => a.rank.compareTo(b.rank));
      restOfLeaderboard = rest.take(7).toList();

      if (userId != null && _referralCode.isNotEmpty) {
        _referralLink =
            await _referral.getReferralLink(
              userId: userId,
              referralCode: _referralCode,
            ) ??
            _referralCode;
        log.d('Referral link ready: $_referralLink');
      }
    } catch (e) {
      log.e('loadData error: $e');
    }
    setState(ViewState.idle);
  }

  void onCardPageChanged(int index) {
    currentCardPage = index;
    notifyListeners();
  }

  Future<void> onInviteFriend() async {
    final link = _referralLink.isNotEmpty ? _referralLink : _referralCode;
    if (link.isEmpty) {
      log.e('onInviteFriend: no referral link available');
      return;
    }
    // ignore: deprecated_member_use
    await Share.share(
      'Join me on Enzer — Shop Now, Pay Later!\nSign up using my referral link: $link',
      subject: 'Join Enzer App',
    );
    log.d('Shared: $link');
  }

  Future<void> copyInviteLink() async {
    final link = _referralLink.isNotEmpty ? _referralLink : _referralCode;
    if (link.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: link));
    Get.snackbar(
      'Link Copied!',
      'Share your referral link to skip the waitlist.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF7C3AED),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
    log.d('Copied: $link');
  }

  @override
  void dispose() {
    if (_channel != null) _supabaseClient.removeChannel(_channel!);
    cardPageController.dispose();
    super.dispose();
  }
}
