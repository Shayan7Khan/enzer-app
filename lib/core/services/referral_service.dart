import 'package:chottu_link/chottu_link.dart';
import 'package:chottu_link/dynamic_link/cl_dynamic_link_behaviour.dart';
import 'package:chottu_link/dynamic_link/cl_dynamic_link_parameters.dart';
import 'package:enzer_app/core/others/logger_customizations/custom_logger.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReferralService {
  static final Logger _log = CustomLogger(className: 'ReferralService');
  final _supabase = Supabase.instance.client;

  // your ChottuLink domain
  static const String _domain = 'enzer-app.chottu.link';

  // destination URL — where the link takes the user
  // this should be your website or a custom domain you own
  // for now using a placeholder — replace with your actual site URL
  static const String _appBaseUrl = 'https://enzerapp.com';

  /// Fetches user's own referral code from referrals table
  Future<String?> getUserReferralCode(String userId) async {
    try {
      final data = await _supabase
          .from('referrals')
          .select('code')
          .eq('user_id', userId)
          .maybeSingle();
      _log.d('getUserReferralCode: ${data?['code']}');
      return data?['code'] as String?;
    } catch (e, st) {
      _log.e('getUserReferralCode: $e\n$st');
      return null;
    }
  }

  /// Returns saved ChottuLink short URL, generates one if not yet created
  Future<String?> getReferralLink({
    required String userId,
    required String referralCode,
  }) async {
    try {
      final data = await _supabase
          .from('referrals')
          .select('referral_link')
          .eq('user_id', userId)
          .maybeSingle();

      final existing = data?['referral_link'] as String?;
      if (existing != null && existing.isNotEmpty) {
        _log.d('Existing referral link found: $existing');
        return existing;
      }

      _log.d('No referral link found — generating...');
      return await _generateAndSave(userId: userId, referralCode: referralCode);
    } catch (e, st) {
      _log.e('getReferralLink: $e\n$st');
      return null;
    }
  }

  Future<String?> _generateAndSave({
    required String userId,
    required String referralCode,
  }) async {
    try {
      // destination URL — NOT the chottulink domain, must be a different URL
      final deepLink = Uri.parse('$_appBaseUrl/referral?code=$referralCode');

      // path must not contain dashes — strip them
      final safePath = referralCode.replaceAll('-', '').toLowerCase();

      String? shortLink;
      bool completed = false;

      final fallbackLink = 'https://$_domain/$safePath';

      ChottuLink.createDynamicLink(
        parameters: CLDynamicLinkParameters(
          link: deepLink,
          domain: _domain,
          androidBehaviour: CLDynamicLinkBehaviour.app,
          iosBehaviour: CLDynamicLinkBehaviour.app,
          selectedPath: safePath, // e.g. enzer8ob2026
          linkName: 'Enzer Referral $referralCode',
          socialTitle: 'Join me on Enzer!',
          socialDescription:
              'Shop Now, Pay Later. Use my referral code $referralCode to sign up.',
          utmCampaign: 'referral',
          utmMedium: 'share',
          utmSource: 'app',
        ),
        onSuccess: (link) async {
          shortLink = link;
          completed = true;
          _log.d('ChottuLink created: $link');
          await _supabase
              .from('referrals')
              .update({'referral_link': link})
              .eq('user_id', userId);
          _log.d('referral_link saved to referrals table');
        },
        onError: (error) async {
          completed = true;
          final desc = error.description ?? '';
          if (desc.contains('already exist') ||
              desc.contains('Path already exist')) {
            shortLink = fallbackLink;
            _log.d('ChottuLink path already exists, using: $shortLink');
            await _supabase
                .from('referrals')
                .update({'referral_link': shortLink})
                .eq('user_id', userId);
          } else {
            _log.e('ChottuLink error: $desc');
          }
        },
      );

      // wait for async callback (max 10 seconds)
      int waited = 0;
      while (!completed && waited < 10000) {
        await Future.delayed(const Duration(milliseconds: 100));
        waited += 100;
      }

      return shortLink;
    } catch (e, st) {
      _log.e('_generateAndSave: $e\n$st');
      return null;
    }
  }

  /// Call once in SplashViewModel to handle incoming referral deep links
  void listenForIncomingLinks({
    required void Function(String referralCode) onReferralReceived,
  }) {
    ChottuLink.onLinkReceived.listen((String link) {
      _log.d('Incoming ChottuLink: $link');
      try {
        final uri = Uri.parse(link);
        final code = uri.queryParameters['code'];
        if (code != null && code.isNotEmpty) {
          _log.d('Referral code from deep link: $code');
          onReferralReceived(code);
        }
      } catch (e) {
        _log.e('listenForIncomingLinks parse error: $e');
      }
    });
  }
}
