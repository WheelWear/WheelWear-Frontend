import 'dart:convert';
import 'package:http/http.dart' as http;
import 'signup_model.dart';

class SignupService {
  final String baseUrl = "http://34.64.187.25:8000/api/accounts/register/";

  Future<bool> signUp(User user) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    return response.statusCode == 201;
  }
}
