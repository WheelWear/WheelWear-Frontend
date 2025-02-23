import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../utils/token_storage.dart';

class MyPageService {
  final Dio dio;
  final String? baseUrl = dotenv.env['BACKEND_URL'];

  MyPageService({required this.dio});

  /// 🟢 바디 이미지 업로드 (multipart/form-data)
  Future<Map<String, dynamic>?> uploadMyPageBodyImage(File file) async {
    try {
      final fileName = file.path.split('/').last;
      final String? token = await TokenStorage.getAccessToken();
      if (token == null) {
        print("🔴 토큰이 없습니다. 로그인이 필요합니다.");
        return null;
      }

      final formData = FormData.fromMap({
        'title': 'MyBodyImage',
        'body_image': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final String url = '$baseUrl/api/body-images/';

      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final imageUrl = data['body_image'] as String?;
        final imageId = data['id'] as int?;

        if (imageUrl != null && imageId != null) {
          print("🟢 이미지 업로드 성공! ID: $imageId, URL: $imageUrl");
          return {"id": imageId, "body_image": imageUrl}; // ✅ ID와 URL 반환
        } else {
          print("🔴 업로드 성공했지만 필요한 데이터 없음.");
          return null;
        }
      } else {
        print("🔴 업로드 실패: ${response.statusCode} / ${response.data}");
        return null;
      }
    } catch (e) {
      print("🔴 업로드 중 오류 발생: $e");
      return null;
    }
  }
}

