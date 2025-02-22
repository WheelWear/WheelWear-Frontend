import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../utils/token_storage.dart';

class MyPageService {
  final Dio dio;
  final String? baseUrl = dotenv.env['BACKEND_URL'];

  MyPageService({required this.dio});

  /// 🟢 마이페이지 바디 이미지 업로드 (multipart/form-data)
  Future<String?> uploadMyPageBodyImage(File file) async {
    try {
      final fileName = file.path.split('/').last;

      // ✅ 토큰 가져오기
      final String? token = await TokenStorage.getAccessToken();
      if (token == null) {
        print("🔴 토큰이 없습니다. 로그인이 필요합니다.");
        return null;
      }

      // ✅ FormData 생성
      final formData = FormData.fromMap({
        'title': 'MyBodyImage',
        'body_image': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      // ✅ API 요청 URL
      final String url = '$baseUrl/api/body-images/';

      print("🟡 [DEBUG] 업로드 요청 URL: $url");
      print("🟡 [DEBUG] 업로드 요청 헤더: Authorization: Bearer $token");
      print("🟡 [DEBUG] 업로드 파일 이름: $fileName");

      // ✅ POST 요청
      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) {
            return status! < 500; // 500 이상이면 예외를 던짐
          },
        ),
      );

      // ✅ 응답 디버깅
      print("🟡 [DEBUG] 응답 상태 코드: ${response.statusCode}");
      print("🟡 [DEBUG] 응답 데이터: ${response.data}");

      // ✅ 성공 처리
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final imageUrl = data['body_image'] as String?; // ✅ 서버 응답의 `body_image` 사용

        if (imageUrl != null) {
          print("🟢 이미지 업로드 성공: $imageUrl");
          return imageUrl;
        } else {
          print("🔴 업로드 성공했지만 이미지 URL을 찾을 수 없음.");
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