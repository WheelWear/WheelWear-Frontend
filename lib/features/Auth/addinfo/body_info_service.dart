import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../../utils/token_storage.dart';

class BodyInfoService {
  final String backendUrl;

  BodyInfoService() : backendUrl = dotenv.env['BACKEND_URL'] ?? 'default_url';

  // 체형 정보를 가져오는 함수
  Future<Map<String, dynamic>?> fetchBodyInfo() async {
    final url = Uri.parse('$backendUrl/api/body-images/');
    final token = await TokenStorage.getAccessToken();
    final response = await http.get(url, headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      return json.decode(response.body)[0];
    } else {
      print("체형 정보 불러오기 실패: ${response.statusCode}, 응답: ${response.body}");
      return null;
    }
  }

  Future<bool> submitBodyInfo({
    required double? shoulderWidth,
    required double? chestCircumference,
    required double? armLength,
    required double? waistCircumference,
    required String gender,
  }) async {
    final url = Uri.parse('$backendUrl/api/body-images/');
    final token = await TokenStorage.getAccessToken();

    var request = http.MultipartRequest('PATCH', url)
      ..headers['Authorization'] = "Bearer $token"
      ..fields['gender'] = gender;

    if (chestCircumference != null) {
      request.fields['chest_circumference'] = chestCircumference.toString();
    }
    if (shoulderWidth != null) {
      request.fields['shoulder_width'] = shoulderWidth.toString();
    }
    if (armLength != null) {
      request.fields['arm_length'] = armLength.toString();
    }
    if (waistCircumference != null) {
      request.fields['waist_circumference'] = waistCircumference.toString();
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print("체형 정보 저장 성공! 응답: $responseBody");
      return true;
    } else {
      print("체형 정보 저장 실패: ${response.statusCode}, 응답: $responseBody");
      return false;
    }
  }

  Future<File?> _getDefaultImageFile() async {
    try {
      final byteData = await rootBundle.load('assets/auth/default_body_image.png');
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/default_body_image.png');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());
      return tempFile;
    } catch (e) {
      print("기본 이미지 파일 로드 실패: $e");
      return null;
    }
  }
}
