import 'package:chottu_link/chottu_link.dart';

Future<void> chottuLInkInitialise(String mobileSdkIntegrationKey) async {
  await ChottuLink.init(apiKey: mobileSdkIntegrationKey);
}
