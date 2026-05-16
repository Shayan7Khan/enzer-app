class RequestResponse {
  late bool success;
  String? error;
  late Map<String, dynamic> data;

  RequestResponse(this.success, {this.error});

  // ignore: strict_top_level_inference
  RequestResponse.fromJson(json) {
    data = json;
    success = json['success'];
    error = json['error'];
  }

  Map<String, Object?> toJson() {
    return {'success': success, 'error': error, 'body': data};
  }
}
