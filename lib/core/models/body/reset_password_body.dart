class ResetPasswordBody {
  String? email;

  ResetPasswordBody({this.email});

  Map<String, String?> toJson() => {'email': email};
}
