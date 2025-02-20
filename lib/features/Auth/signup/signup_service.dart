import 'dart:convert';
import 'package:http/http.dart' as http;
import 'signup_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SignupService {
  final String backendUrl;
  SignupService() : backendUrl = dotenv.env['BACKEND_URL'] ?? 'default_url';

  Future<bool> signUp(User user) async {
    final url = Uri.parse(backendUrl);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    return response.statusCode == 201;
  }
}
