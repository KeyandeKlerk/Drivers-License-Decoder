class LoginResponseModelLogin {
  final String token;
  final String error;
  final String id;
  final String email;
  final String companyID;
  final String site;

  LoginResponseModelLogin(
      {this.token, this.error, this.email, this.id, this.companyID, this.site});

  factory LoginResponseModelLogin.fromJson(Map<String, dynamic> json) {
    return LoginResponseModelLogin(
      token: json["token"] != null ? json["token"] : "",
      error: json["error"] != null ? json["error"] : "",
      id: json["id"] != null ? json["id"] : "",
      email: json["email"] != null ? json["email"] : "",
      companyID: json["companyID"] != null ? json["companyID"] : "",
      site: json["site"] != null ? json["site"] : "",
    );
  }
}

class LoginRequestModelLogin {
  String email;
  String password;

  LoginRequestModelLogin({
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "email": email.trim(),
      "password": password.trim(),
    };

    return map;
  }
}
