import 'dart:io';
import 'package:dio/dio.dart';

class FittingService {
  final Dio dio;

  FittingService({required this.dio});

  /// body_image 업로드
  /// 서버가 업로드 성공 시 반환하는 이미지 URL(또는 다른 필드)을 반환
  Future<String?> uploadBodyImage(File file) async {
    try {
      final fileName = file.path.split('/').last;

      final formData = FormData.fromMap({
        'body_image': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await dio.post(
        '/api/body-images/',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        // 예: 서버에서 {"body_image":"https://..."} 형태로 반환한다고 가정
        return data['body_image'] as String?;
      } else {
        print("업로드 실패: ${response.statusCode} / ${response.data}");
        return null;
      }
    } catch (e) {
      print("uploadBodyImage 에러: $e");
      return null;
    }
  }
}
