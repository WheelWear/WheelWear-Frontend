import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/closet_item.dart';
import 'package:wheelwear_frontend/utils/token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class ApiService {
  final String backendUrl;

  ApiService() : backendUrl = dotenv.env['BACKEND_URL'] ?? 'default_url';

  Future<List<ClosetItem>> fetchClosetItems() async {
    // 매 호출 시 토큰을 가져옵니다.
    final String? accessToken = await TokenStorage.getAccessToken();
    final Uri url = Uri.parse('$backendUrl/api/clothes/');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      debugPrint("데이터 받기 성공: ${jsonList.length}");
      return jsonList.map((json) => ClosetItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load closet items');
    }
  }

  Future<ClosetItem> uploadClothItems(File selectedImage,
      String ClosetType, String Size, String Brand,
      String ClosetCategory) async {
    final String? accessToken = await TokenStorage.getAccessToken();
    final Uri url = Uri.parse('$backendUrl/api/clothes/');

    if (accessToken == null) {
      throw Exception('Access token is null! Login required.');
    }

    // 📌 디버깅: 값 출력
    debugPrint("ClosetType: $ClosetType");
    debugPrint("Size: $Size");
    debugPrint("Brand: $Brand");
    debugPrint("ClosetCategory: $ClosetCategory");

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $accessToken';

    // 📌 Null 체크 및 기본값 설정
    request.fields['cloth_type'] =
    ClosetType.isNotEmpty ? ClosetType : 'Unknown';
    request.fields['size'] = Size.isNotEmpty ? Size : 'Unknown';
    request.fields['brand'] = Brand.isNotEmpty ? Brand : 'Unknown';
    request.fields['cloth_subtypes_names'] = 'Jeans,SportswearBottom';
    request.fields['closet_category'] =
    ClosetCategory.isNotEmpty ? ClosetCategory : 'Unknown';

    // 📌 지원되는 이미지 형식 확인
    List<String> allowedExtensions = ['jpg', 'jpeg', 'png', 'gif'];
    String fileExtension = selectedImage.path
        .split('.')
        .last
        .toLowerCase();

    if (!allowedExtensions.contains(fileExtension)) {
      throw Exception('Unsupported file format: $fileExtension');
    }

    // 📌 이미지 파일 추가 (필드명 확인)
    request.files.add(await http.MultipartFile.fromPath(
      'clothImage', // 🔥 서버에서 요구하는 필드명 확인 필수!
      selectedImage.path,
      filename: selectedImage.path
          .split('/')
          .last,
    ));

    var response = await request.send();
    final responseBody = await response.stream.bytesToString();

    debugPrint("🚨 서버 응답 코드: ${response.statusCode}");
    debugPrint("📩 서버 응답 내용: $responseBody");

    if (response.statusCode == 201) {  // ✅ 201 Created 확인
      final Map<String, dynamic> jsonResponse = json.decode(responseBody);
      debugPrint("✅ 데이터 받기 성공: ${jsonResponse['id']}");

      return ClosetItem.fromJson(jsonResponse);  // ✅ 객체 하나만 반환
    } else {
      throw Exception('Failed to upload closet item: ${response.statusCode} - $responseBody');
    }
  }
}