import 'package:supabase_flutter/supabase_flutter.dart';

//initialising supabase
Future<void> supabaseInitalise(
  String supabaseUrl,
  String supabasePublishableKey,
) async {
  await Supabase.initialize(url: supabaseUrl, anonKey: supabasePublishableKey);
}
