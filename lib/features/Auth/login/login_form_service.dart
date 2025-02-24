import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../../utils/token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginService {
  final String? baseUrl = dotenv.env['BACKEND_URL'];

  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/accounts/token/');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    print("🟢 로그인 API 응답: ${response.body}");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      String? accessToken = responseData['access'];
      String? refreshToken = responseData['refresh'];
      bool isFirstLogin = responseData['is_first_login'] ?? false;

      if (accessToken != null && refreshToken != null) {
        await TokenStorage.saveAccessToken(accessToken);
        await TokenStorage.saveRefreshToken(refreshToken);
        print("🟢 토큰 저장 완료!");

        return {"success": true, "is_first_login": isFirstLogin};
      } else {
        print("🔴 로그인 성공했지만 토큰 없음.");
        return {"success": false};
      }
    }

    print("🔴 로그인 실패: ${response.statusCode}");
    return {"success": false};
  }
}

