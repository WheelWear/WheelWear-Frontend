import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:wheelwear_frontend/utils/token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FittingService {
  final String? baseUrl = dotenv.env['BACKEND_URL'];

  /// 🟢 가상 피팅 이미지 생성 요청 (한 번에 하나씩 요청)
  /// 성공 시 전체 JSON 데이터를 반환합니다.
  Future<Map<String, dynamic>?> generateFittingImage(BuildContext context, Map<String, dynamic> requestData) async {
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

    int count = 0;
    if (requestData.containsKey('top_cloth')) count++;
    if (requestData.containsKey('bottom_cloth')) count++;
    if (requestData.containsKey('dress_cloth')) count++;

    if (count != 1) {
      print("🔴 옷은 무조건 하나만 선택해야 합니다.");
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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        print("🟢 피팅 이미지 생성 성공");
        return data; // 전체 JSON 객체 반환
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
