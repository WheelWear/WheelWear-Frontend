import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../utils/token_storage.dart';

class BodyInfoService {
  final String backendUrl;

  BodyInfoService() : backendUrl = dotenv.env['BACKEND_URL'] ?? 'default_url';

  Future<bool> submitBodyInfo({
    required double shoulderWidth,
    required double chestCircumference,
    required double armLength,
    required double waistCircumference,
  }) async {
    final url = Uri.parse('$backendUrl/api/body-images/');
    final token = await TokenStorage.getAccessToken();

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "id": 1,
        "chest_circumference": chestCircumference,
        "shoulder_width": shoulderWidth,
        "arm_length": armLength,
        "waist_circumference": waistCircumference,
        "body_image": null,
      }),
    );

    print("🟢 체형 정보 API 응답: ${response.body}");

    if (response.statusCode == 201) {
      print("🟢 체형 정보 저장 성공!");
      return true;
    } else {
      print("🔴 체형 정보 저장 실패: ${response.statusCode}");
      return false;
    }
  }
}
