import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:wheelwear_frontend/utils/token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FittingService {
  final String? baseUrl = dotenv.env['BACKEND_URL'];

  /// 🟢 가상 피팅 이미지 생성 요청 (한 번에 하나씩 요청)
  Future<String?> generateFittingImage(BuildContext context, Map<String, dynamic> requestData) async {
    if (baseUrl == null) {
      print("🔴 BASE_URL이 설정되지 않았습니다.");
      return null;
    }

    final String? accessToken = await TokenStorage.getAccessToken();
    if (accessToken == null) {
      print("🔴 Access Token 없음");
      return null;
    }

    final url = Uri.parse('$baseUrl/api/virtual-tryon-images/');

    // ✅ 최소한 하나의 옷이 선택되지 않으면 요청 차단
    if (!requestData.containsKey('top_cloth') &&
        !requestData.containsKey('bottom_cloth') &&
        !requestData.containsKey('dress_cloth')) {
      print("🔴 최소한 하나의 옷을 선택해야 합니다.");
      return null;
    }

    try {
      final jsonData = jsonEncode(requestData);
      print("🟡 요청 데이터: $jsonData");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: jsonData,
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("🟢 피팅 이미지 생성 성공: ${data["generated_image"]}");
        return data["generated_image"]; // ✅ 성공하면 URL 반환
      } else {
        print("🔴 피팅 이미지 생성 실패: ${response.statusCode}");
        print("🔴 응답 본문: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🔴 요청 중 오류 발생: $e");
      return null;
    }
  }
}
