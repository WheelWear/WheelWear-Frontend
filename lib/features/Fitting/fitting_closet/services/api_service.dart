import 'package:flutter/cupertino.dart';
import '../models/closet_item.dart';
import 'package:wheelwear_frontend/utils/token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // debugPrint 사용

class ApiService {
  final String backendUrl;
  late final Dio dio;

  ApiService() : backendUrl = dotenv.env['BACKEND_URL'] ?? 'default_url' {
    dio = Dio(BaseOptions(
      baseUrl: backendUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
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
        debugPrint("Dio Error: ${error.message}");
        return handler.next(error);
      },
    ));
  }

  // 옷 목록을 가져오는 함수 (재시도 로직 포함)
  Future<List<ClosetItem>> fetchClosetItems({int maxRetries = 100}) async {
    int attempt = 0;
    while (true) {
      try {
        final response = await dio.get('/api/clothes/');
        if (response.statusCode == 200) {
          final List<dynamic> data = response.data;
          debugPrint("데이터 받기 성공: ${data.length}");
          // debugPrint(data.toString());
          return data.map((json) => ClosetItem.fromJson(json)).toList();
        } else {
          throw Exception(
            'Failed to load closet items. Status Code: ${response.statusCode}, Response: ${response.data}',
          );
        }
      } catch (error) {
        attempt++;
        debugPrint('fetchClosetItems 실패 (시도 $attempt): $error');
        if (attempt >= maxRetries) {
          throw Exception('최대 재시도 횟수 초과: $error');
        }
        // 재시도 전 잠시 대기 (예: 2초, 필요시 지수 백오프로 조정 가능)
        // await Future.delayed(const Duration(seconds: 2));
        await Future.delayed(const Duration(milliseconds: 1));
      }
    }
  }
}
