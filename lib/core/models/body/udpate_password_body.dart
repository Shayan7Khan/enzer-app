class UpdatePasswordBody {
  String? oldPassword;
  String? newPassword;

  UpdatePasswordBody({this.oldPassword, this.newPassword});

  Map<String, String?> toJson() => {
    'oldPassword': oldPassword,
    'newPassword': newPassword,
  };
}
