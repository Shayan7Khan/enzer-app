import 'package:enzer_app/core/models/responses/base_responses/base_response.dart';

class ResetPasswordResponse extends BaseResponse {
  String? message;

  /// Default constructor
  // ignore: strict_top_level_inference, use_super_parameters
  ResetPasswordResponse(success, {error, this.message})
    : super(success, error: error);

  /// Named Constructor
  // ignore: strict_top_level_inference
  ResetPasswordResponse.fromJson(json) : super.fromJson(json) {
    if (json['body'] != null) message = json['body']['message'];
  }
}
