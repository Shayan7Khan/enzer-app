import 'package:enzer_app/core/models/responses/base_responses/base_response.dart';

class AuthResponse extends BaseResponse {
  String? accessToken;

  /// Default constructor
  // ignore: strict_top_level_inference, use_super_parameters
  AuthResponse(success, {error, this.accessToken})
    : super(success, error: error);

  /// Named Constructor
  // ignore: strict_top_level_inference
  AuthResponse.fromJson(json) : super.fromJson(json) {
    if (json['body'] != null) accessToken = json['body']['token'];
  }
}
