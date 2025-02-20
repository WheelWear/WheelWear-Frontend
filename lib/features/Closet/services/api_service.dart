import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/closet_item.dart';
import 'package:wheelwear_frontend/utils/token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  // 주어진 여러 clothId를 이용하여 cloth를 삭제하는 함수
  Future<void> deleteClothes(List<int> clothIds) async {
    final String? accessToken = await TokenStorage.getAccessToken();
    // 각 cloth ID마다 삭제 요청을 보냅니다.
    final List<Future<http.Response>> deleteFutures = clothIds.map((id) {
      final Uri url = Uri.parse('$backendUrl/api/clothes/$id/');
      return http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
    }).toList();

    // 모든 삭제 요청을 병렬로 실행합니다.
    final responses = await Future.wait(deleteFutures);

    // 모든 응답을 확인하여 하나라도 실패하면 예외 발생
    for (final response in responses) {
      if (response.statusCode != 204) {
        debugPrint("삭제 실패: ${response.statusCode} - ${response.body}");
        throw Exception('Failed to delete one or more clothes');
      }
    }

    debugPrint("삭제 성공: cloth IDs = $clothIds");
  }

  // 주어진 여러 clothId를 이용하여 closet_category를 "donation"으로 수정하는 함수
  Future<void> updateClothesToDonation(List<int> clothIds) async {
    final String? accessToken = await TokenStorage.getAccessToken();
    // 각 cloth ID마다 PATCH 요청을 보냅니다.
    final List<Future<http.Response>> patchFutures = clothIds.map((id) {
      final Uri url = Uri.parse('$backendUrl/api/clothes/$id/');
      return http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({"closet_category": "donation"}),
      );
    }).toList();

    // 모든 PATCH 요청을 병렬로 실행합니다.
    final responses = await Future.wait(patchFutures);

    // 모든 응답을 확인하여 하나라도 실패하면 예외 발생
    for (final response in responses) {
      if (response.statusCode != 200 && response.statusCode != 204) {
        debugPrint("수정 실패: ${response.statusCode} - ${response.body}");
        throw Exception('Failed to update one or more clothes to donation');
      }
    }

    debugPrint("수정 성공: cloth IDs updated to donation = $clothIds");
  }
}
