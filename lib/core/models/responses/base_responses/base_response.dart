class BaseResponse {
  late bool success;
  String? error;

  BaseResponse(this.success, {this.error});

  // ignore: strict_top_level_inference
  BaseResponse.fromJson(json) {
    success = json['success'];
    error = json['error'];
  }

  Map<String, Object?> toJson() {
    return {'success': success, 'error': error};
  }
}
