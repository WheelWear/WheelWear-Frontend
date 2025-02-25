import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:wheelwear_frontend/utils/token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfileService {
  // dotenv를 통해 BACKEND_URL을 읽되, 주소 형식이 "http://{{Address}}"가 되어야 함
  final String? baseUrl = dotenv.env['BACKEND_URL'];

  Future<Map<String, dynamic>?> fetchProfile(BuildContext context) async {
    if (baseUrl == null) {
      print("🔴 BASE_URL이 설정되지 않았습니다.");
      return null;
    }

    final String? accessToken = await TokenStorage.getAccessToken();
    if (accessToken == null) {
      print("🔴 Access Token 없음");
      return null;
    }

    // 요청 URL: http://{{Address}}/api/accounts/profile/
    final url = Uri.parse('$baseUrl/api/accounts/profile/');

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        print("🟢 프로필 정보 가져오기 성공");
        debugPrint("데이터 : $data");
        return data;
      } else {
        print("🔴 프로필 정보 가져오기 실패: ${response.statusCode}");
        print("🔴 응답 본문: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🔴 요청 중 오류 발생: $e");
      return null;
    }
  }

  /// 프로필 정보를 백엔드에 업데이트합니다.
  /// profileImage가 제공되면 해당 이미지를 multipart로 업로드합니다.
  Future<bool> updateProfile(
      BuildContext context,
      Map<String, dynamic> profileData, {
        File? profileImage,
      }) async {
    if (baseUrl == null) {
      print("🔴 BASE_URL이 설정되지 않았습니다.");
      return false;
    }

    final String? accessToken = await TokenStorage.getAccessToken();
    if (accessToken == null) {
      print("🔴 Access Token 없음");
      return false;
    }

    // 요청 URL: http://{{Address}}/api/accounts/profile/
    final url = Uri.parse('$baseUrl/api/accounts/profile/');

    try {
      if (profileImage != null) {
        // MultipartRequest를 이용하여 이미지와 함께 데이터 전송
        var request = http.MultipartRequest('PATCH', url);
        request.headers['Authorization'] = "Bearer $accessToken";
        // MultipartRequest는 Content-Type을 자동으로 설정하므로 따로 지정하지 않습니다.
        // 필드 추가
        profileData.forEach((key, value) {
          request.fields[key] = value.toString();
        });
        // 파일 첨부 (서버에서 필드명은 'profile_picture'로 인식)
        request.files.add(await http.MultipartFile.fromPath('profile_picture', profileImage.path));

        var streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          print("🟢 프로필 업데이트(이미지 포함) 성공");
          return true;
        } else {
          print("🔴 프로필 업데이트(이미지 포함) 실패: ${response.statusCode}");
          print("🔴 응답 본문: ${response.body}");
          return false;
        }
      } else {
        // profileImage가 없으면 기존 방식대로 JSON으로 전송
        final response = await http.patch(
          url,
          headers: {
            "Authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          },
          body: jsonEncode(profileData),
        );

        if (response.statusCode >= 200 && response.statusCode < 300) {
          print("🟢 프로필 업데이트 성공");
          return true;
        } else {
          print("🔴 프로필 업데이트 실패: ${response.statusCode}");
          print("🔴 응답 본문: ${response.body}");
          return false;
        }
      }
    } catch (e) {
      print("🔴 요청 중 오류 발생: $e");
      return false;
    }
  }
}
