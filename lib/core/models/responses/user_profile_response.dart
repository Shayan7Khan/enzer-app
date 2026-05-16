import 'package:enzer_app/core/models/other_models/user_profile.dart';
import 'package:enzer_app/core/models/responses/base_responses/base_response.dart';

class UserProfileResponse extends BaseResponse {
  UserProfile? profile;

  // ignore: strict_top_level_inference, use_super_parameters
  UserProfileResponse(success, {error}) : super(success, error: error);

  // ignore: strict_top_level_inference
  UserProfileResponse.fromJson(json) : super.fromJson(json) {
    if (json['body'] != null) {
      profile = UserProfile.fromJson(json['body']['user']);
    }
  }
}
