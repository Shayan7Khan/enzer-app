class LoginBody {
  String? phone;
  String? cnic;
  String? password;

  LoginBody({this.phone, this.cnic, this.password});

  Map<String, String?> toJson() => {
    'phone': phone,
    'cnic': cnic,
    'password': password,
  };
}
