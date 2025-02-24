import 'dart:convert';
import 'package:http/http.dart' as http;
import 'signup_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SignupService {
  final String backendUrl;
  SignupService() : backendUrl = dotenv.env['BACKEND_URL'] ?? 'default_url';

  Future<bool> signUp(User user) async {
    final url = Uri.parse('$backendUrl/api/accounts/register/');

    // 요청 보내기 전 로그
    print("[SignupService] 회원가입 요청: $backendUrl, body: ${jsonEncode(user.toJson())}");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      // 응답 수신 후 로그
      print("[SignupService] 응답 수신: statusCode=${response.statusCode}, body=${response.body}");

      // 상태 코드 확인
      return response.statusCode == 201;
    } catch (e) {
      // 에러 발생 시 로그
      print("[SignupService] 회원가입 요청 에러: $e");
      rethrow;
    }
  }
}
