import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wheelwear_frontend/utils/token_storage.dart';

class FittingService {
  final String baseUrl;
  late final Dio dio;

  FittingService() : baseUrl = dotenv.env['BACKEND_URL'] ?? 'default_url' {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10), // 10초로 변경
      receiveTimeout: const Duration(seconds: 700), // 700초로 변경
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // 인터셉터: 각 요청 시 accessToken을 추가합니다.
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final String? accessToken = await TokenStorage.getAccessToken();
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onError: (DioError error, handler) {
        debugPrint("FittingService Dio Error: ${error.message}");
        return handler.next(error);
      },
    ));
  }

  /// 🟢 가상 피팅 이미지 생성 요청 (한 번에 하나씩 요청)
  /// 성공 시 전체 JSON 데이터를 반환합니다.
  Future<Map<String, dynamic>?> generateFittingImage(
      BuildContext context, Map<String, dynamic> requestData) async {
    // 옷 관련 키가 1개만 존재하는지 체크합니다.
    int count = 0;
    if (requestData.containsKey('top_cloth')) count++;
    if (requestData.containsKey('bottom_cloth')) count++;
    if (requestData.containsKey('dress_cloth')) count++;

    if (count != 1) {
      debugPrint("🔴 옷은 무조건 하나만 선택해야 합니다.");
      return null;
    }

    try {
      debugPrint("🟡 요청 데이터: ${requestData.toString()}");

      final response = await dio.post(
        '/api/virtual-tryon-images/',
        data: requestData,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        debugPrint("🟢 피팅 이미지 생성 성공");
        return response.data as Map<String, dynamic>;
      } else {
        debugPrint("🔴 피팅 이미지 생성 실패: ${response.statusCode}");
        debugPrint("🔴 응답 본문: ${response.data}");
        return null;
      }
    } catch (e) {
      debugPrint("🔴 요청 중 오류 발생: $e");
      return null;
    }
  }

  /// 특정 id를 가진 vton 튜플의 'saved' 값을 true로 업데이트합니다.
  Future<void> markFittingAsSaved(int id) async {
    try {
      final response = await dio.patch(
        '/api/virtual-tryon-images/$id/',
        data: {"saved": true},
      );

      if (response.statusCode != null &&
          (response.statusCode == 200 || response.statusCode == 204)) {
        debugPrint("✅ vton 튜플 업데이트 성공: saved = true (id: $id)");
      } else {
        debugPrint("❌ vton 튜플 업데이트 실패: ${response.statusCode}");
        debugPrint("❌ 응답 데이터: ${response.data}");
        throw Exception("Failed to update saved status for vton with id $id");
      }
    } catch (e) {
      debugPrint("❌ vton 튜플 업데이트 중 오류 발생: $e");
      throw Exception("Error updating saved status for vton with id $id: $e");
    }
  }

  Future<Map<String, dynamic>?> fetchRecommendedSize(int clothID) async {
    try {
      debugPrint("🟡 추천 사이즈 조회 요청 (clothID: $clothID)");
      final response = await dio.post('/api/clothes/$clothID/size/');

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        debugPrint("🟢 추천 사이즈 조회 성공");
        debugPrint("🟢 응답 본문: ${response.data}");
        return response.data as Map<String, dynamic>;
      } else {
        debugPrint("🔴 추천 사이즈 조회 실패: ${response.statusCode}");
        debugPrint("🔴 응답 본문: ${response.data}");
        return null;
      }
    } catch (e) {
      debugPrint("🔴 추천 사이즈 요청 중 오류 발생: $e");
      return null;
    }
  }

}
