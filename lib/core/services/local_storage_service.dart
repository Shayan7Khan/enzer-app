import 'package:enzer_app/core/others/logger_customizations/custom_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final log = CustomLogger(className: 'Local Storage Service');
  static SharedPreferences? _preferences;

  ///
  /// List of const keys
  ///
  static const String onboardingCountKey = 'onBoardingCount';
  static const String notificationsCountKey = 'notificationsCount';
  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';
  static const String userDataKey = 'userData';
  static const String isLoggedInKey = 'isLoggedIn';
  static const String pendingReferralCodeKey = 'pendingReferralCode';

  ///
  /// Setters and getters
  ///
  int get onBoardingPageCount => _getFromDisk(onboardingCountKey) ?? 0;
  set onBoardingPageCount(int count) => _saveToDisk(onboardingCountKey, count);

  int get setNotificationsCount => _getFromDisk(notificationsCountKey) ?? 0;
  set setNotificationsCount(int count) =>
      _saveToDisk(notificationsCountKey, count);

  String? get pendingReferralCode => _getFromDisk(pendingReferralCodeKey);
  set pendingReferralCode(String? value) =>
      _saveToDisk(pendingReferralCodeKey, value);

  dynamic get accessToken => _getFromDisk(accessTokenKey);
  // ignore: strict_top_level_inference
  set accessToken(token) => _saveToDisk(accessTokenKey, token);

  dynamic get refreshToken => _getFromDisk(refreshTokenKey);
  // ignore: strict_top_level_inference
  set refreshToken(token) => _saveToDisk(refreshTokenKey, token);

  String? get userData => _getFromDisk(userDataKey);
  set userData(String? data) => _saveToDisk(userDataKey, data);

  bool get isLoggedIn => _getFromDisk(isLoggedInKey) ?? false;
  set isLoggedIn(bool value) => _saveToDisk(isLoggedInKey, value);

  ///
  ///initializing instance
  ///
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  dynamic _getFromDisk(String key) {
    if (_preferences == null) {
      log.e('@_getFromDisk: SharedPreferences not initialized for key: $key');
      return null;
    }
    var value = _preferences!.get(key);
    log.d('@_getFromDisk. key: $key value: $value');
    return value;
  }

  void _saveToDisk<T>(String key, T? content) {
    log.d('@_saveToDisk. key: $key value: $content');
    if (_preferences == null) {
      log.e('@_saveToDisk: SharedPreferences not initialized for key: $key');
      return;
    }

    if (content is String) _preferences!.setString(key, content);
    if (content is bool) _preferences!.setBool(key, content);
    if (content is int) _preferences!.setInt(key, content);
    if (content is double) _preferences!.setDouble(key, content);
    if (content is List<String>) _preferences!.setStringList(key, content);
    if (content == null) _preferences!.remove(key);
  }

  /// Clear all user authentication data
  void clearUserData() {
    accessToken = null;
    refreshToken = null;
    userData = null;
    isLoggedIn = false;
    log.d('@clearUserData: All user data cleared');
  }
}
