import 'package:enzer_app/core/services/localization_service.dart';
import 'package:flutter/material.dart';

class Onboarding {
  late String? imgUrl;
  late String? title;

  Onboarding(this.imgUrl, this.title);

  Onboarding.fromJson(Map<String, dynamic> json) {
    debugPrint('$json');
    title = json[LocalizationService.getLocalizedKey('title')];
    imgUrl = json['image_url'];
  }
}
