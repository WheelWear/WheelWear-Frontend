import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import '../models/closet_item.dart';
import 'package:wheelwear_frontend/utils/token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // debugPrint 사용
import 'package:http/http.dart' as http;

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
        await Future.delayed(const Duration(milliseconds: 1));
      }
    }
  }

  // 주어진 clothId들을 삭제하는 함수 (재시도 없이 기존 로직)
  Future<void> deleteClothes(List<int> clothIds) async {
    try {
      final deleteFutures = clothIds
          .map((id) => dio.delete('/api/clothes/$id/'))
          .toList();
      final responses = await Future.wait(deleteFutures);

      for (final response in responses) {
        if (response.statusCode != 204) {
          debugPrint("삭제 실패: ${response.statusCode} - ${response.data}");
          throw Exception('Failed to delete one or more clothes');
        }
      }
      debugPrint("삭제 성공: cloth IDs = $clothIds");
    } catch (error) {
      debugPrint("deleteClothes 에러: $error");
      throw Exception('Failed to delete one or more clothes');
    }
  }

  // 주어진 clothId들을 donation으로 업데이트하는 함수 (재시도 없이 기존 로직)
  Future<void> updateClothesToDonation(List<int> clothIds) async {
    try {
      final patchFutures = clothIds.map((id) {
        return dio.patch(
          '/api/clothes/$id/',
          data: {"closet_category": "donation"},
        );
      }).toList();

      final responses = await Future.wait(patchFutures);

      for (final response in responses) {
        if (response.statusCode != 200 && response.statusCode != 204) {
          debugPrint("수정 실패: ${response.statusCode} - ${response.data}");
          throw Exception('Failed to update one or more clothes to donation');
        }
      }
      debugPrint("수정 성공: cloth IDs updated to donation = $clothIds");
    } catch (error) {
      debugPrint("updateClothesToDonation 에러: $error");
      throw Exception('Failed to update one or more clothes to donation');
    }
  }

  // 옷 업로드 함수 추가 (uploadClothItems)
  Future<ClosetItem> uploadClothItems(
      File selectedImage,
      String ClosetType,
      String Size,
      String Brand,
      String ClosetCategory) async {
    final String? accessToken = await TokenStorage.getAccessToken();
    final Uri url = Uri.parse('$backendUrl/api/clothes/');

    if (accessToken == null) {
      throw Exception('Access token is null! Login required.');
    }

    // 디버깅: 값 출력
    debugPrint("ClosetType: $ClosetType");
    debugPrint("Size: $Size");
    debugPrint("Brand: $Brand");
    debugPrint("ClosetCategory: $ClosetCategory");

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $accessToken';

    // Null 체크 및 기본값 설정
    request.fields['cloth_type'] =
    ClosetType.isNotEmpty ? ClosetType : 'Unknown';
    request.fields['size'] = Size.isNotEmpty ? Size : 'Unknown';
    request.fields['brand'] = Brand.isNotEmpty ? Brand : 'Unknown';
    request.fields['cloth_subtypes_names'] = 'Jeans,SportswearBottom';
    request.fields['closet_category'] =
    ClosetCategory.isNotEmpty ? ClosetCategory : 'Unknown';

    // 지원되는 이미지 형식 확인
    List<String> allowedExtensions = ['jpg', 'jpeg', 'png', 'gif'];
    String fileExtension =
    selectedImage.path.split('.').last.toLowerCase();

    if (!allowedExtensions.contains(fileExtension)) {
      throw Exception('Unsupported file format: $fileExtension');
    }

    // 이미지 파일 추가 (필드명 확인)
    request.files.add(await http.MultipartFile.fromPath(
      'clothImage', // 서버에서 요구하는 필드명 확인 필수!
      selectedImage.path,
      filename: selectedImage.path.split('/').last,
    ));

    var response = await request.send();
    final responseBody = await response.stream.bytesToString();

    debugPrint("🚨 서버 응답 코드: ${response.statusCode}");
    debugPrint("📩 서버 응답 내용: $responseBody");

    if (response.statusCode == 201) {  // 201 Created 확인
      final Map<String, dynamic> jsonResponse = json.decode(responseBody);
      debugPrint("✅ 데이터 받기 성공: ${jsonResponse['id']}");

      return ClosetItem.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to upload closet item: ${response.statusCode} - $responseBody');
    }
  }
}
