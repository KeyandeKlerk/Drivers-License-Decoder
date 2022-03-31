import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/login_model.dart';

class APIServiceLogin {
  Future<LoginResponseModelLogin> login(
      LoginRequestModelLogin requestModel) async {
    String url = "https://www.zentylvms.co.za/API/1d-camera/camera_login.php";
    const headers = {'Content-Type': 'application/json'};
    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(requestModel.toJson()));
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return LoginResponseModelLogin.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to load data!');
    }
  }
}
