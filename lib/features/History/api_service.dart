import 'dart:convert';
import 'package:http/http.dart' as http;
import './models/virtual_tryon_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../utils/token_storage.dart';

class ApiService {
  final String? baseUrl = dotenv.env['BACKEND_URL'];

  // 가상 착용 이미지 목록 가져오기 (토큰 포함)
  Future<List<VirtualTryOnImage>> fetchVirtualTryOnImages() async {
    final String? accessToken = await TokenStorage.getAccessToken();
    final String url = '$baseUrl/api/virtual-tryon-images/?saved=True';

    print('🔄 [GET] 요청: $url');
    print('🛠 헤더: {Content-Type: application/json, Authorization: Bearer $accessToken}');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    print('📡 [GET] 응답 상태 코드: ${response.statusCode}');
    print('📄 응답 본문: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => VirtualTryOnImage.fromJson(item)).toList();
    } else {
      throw Exception('이미지를 불러오는데 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  // 가상 착용 이미지 삭제 (토큰 포함)
  Future<void> deleteVirtualTryOnImage(int id) async {
    final String? accessToken = await TokenStorage.getAccessToken();
    final String url = '$baseUrl/api/virtual-tryon-images/$id/';

    print('🗑️ [DELETE] 요청: $url');
    print('🛠 헤더: {Content-Type: application/json, Authorization: Bearer $accessToken}');

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    print('📡 [DELETE] 응답 상태 코드: ${response.statusCode}');
    print('📄 응답 본문: ${response.body}');

    if (response.statusCode != 204) {
      throw Exception('삭제에 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }
}
