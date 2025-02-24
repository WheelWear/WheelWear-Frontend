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

  Future<bool> submitBodyInfo({
    required double? shoulderWidth,
    required double? chestCircumference,
    required double? armLength,
    required double? waistCircumference,
    required String gender,
  }) async {
    final url = Uri.parse('$backendUrl/api/body-images/');
    final token = await TokenStorage.getAccessToken();

    // ✅ 기본 이미지 파일을 `assets`에서 불러와 임시 저장 후 사용
    File? defaultImageFile = await _getDefaultImageFile();
    if (defaultImageFile == null) {
      print("🔴 기본 이미지 파일 로드 실패");
      return false;
    }

    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = "Bearer $token"
      ..fields['title'] = "MyImg"
      ..fields['gender'] = gender
      ..fields['chest_circumference'] = chestCircumference?.toString() ?? ""
      ..fields['shoulder_width'] = shoulderWidth?.toString() ?? ""
      ..fields['arm_length'] = armLength?.toString() ?? ""
      ..fields['waist_circumference'] = waistCircumference?.toString() ?? "";

    // ✅ 기본 이미지 파일을 `body_image`로 추가
    request.files.add(await http.MultipartFile.fromPath('body_image', defaultImageFile.path));

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      print("🟢 체형 정보 저장 성공! 응답: $responseBody");
      return true;
    } else {
      print("🔴 체형 정보 저장 실패: ${response.statusCode}, 응답: $responseBody");
      return false;
    }
  }

  // ✅ 기본 이미지 파일을 assets에서 불러와 임시 디렉토리에 저장하는 함수
  Future<File?> _getDefaultImageFile() async {
    try {
      final byteData = await rootBundle.load('assets/auth/default_body_image.png');
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/default_body_image.png');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());
      return tempFile;
    } catch (e) {
      print("🔴 기본 이미지 파일 로드 실패: $e");
      return null;
    }
  }
}
