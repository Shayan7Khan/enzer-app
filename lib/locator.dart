import 'package:enzer_app/core/config/config.dart';
import 'package:enzer_app/core/enums/env.dart';
import 'package:enzer_app/core/services/fcm_service.dart';
import 'package:enzer_app/core/services/referral_service.dart';
import 'package:enzer_app/core/services/supabase_service.dart';
import 'package:enzer_app/core/services/supabase_storage_service.dart';
import 'package:enzer_app/ui/screens/activity_screen/activity_screen_view_model.dart';
import 'package:get_it/get_it.dart';

import 'core/services/api_services.dart';
import 'core/services/auth_service.dart';
import 'core/services/file_picker_service.dart';
import 'core/services/local_storage_service.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator(Env env) async {
  locator.registerSingleton(Config(env));
  final localStorageService = LocalStorageService();
  await localStorageService.init();
  locator.registerSingleton(localStorageService);
  locator.registerSingleton(ApiServices());
  locator.registerLazySingleton<SupabaseService>(() => SupabaseService());
  locator.registerLazySingleton(() => SupabaseStorageService());
  locator.registerLazySingleton(() => ActivityViewModel());
  locator.registerLazySingleton(() => FCMService());
  locator.registerLazySingleton(() => ReferralService());
  locator.registerSingleton<AuthService>(AuthService());
  locator.registerLazySingleton(() => FilePickerService());
}
