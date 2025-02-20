import 'dart:convert';
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
      print(jsonList);
      return jsonList.map((json) => ClosetItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load closet items');
    }
  }
}
