import 'package:enzer_app/core/models/other_models/onboarding.dart';

import 'base_responses/base_response.dart';

class OnboardingResponse extends BaseResponse {
  late List<Onboarding> onboardingsList = [];

  /// Default constructor
  // ignore: strict_top_level_inference, use_super_parameters
  OnboardingResponse(success, {error}) : super(success, error: error);

  /// Named Constructor
  // ignore: strict_top_level_inference
  OnboardingResponse.fromJson(json) : super.fromJson(json) {
    if (json['body'] != null) {
      json['body']?['boarding']?.forEach((onboardingJson) {
        onboardingsList.add(Onboarding.fromJson(onboardingJson));
      });
    }
  }
}
