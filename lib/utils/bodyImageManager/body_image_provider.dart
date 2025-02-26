import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:wheelwear_frontend/utils/token_storage.dart';
import 'body_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wheelwear_frontend/utils/CameraScreenWithOverlay.dart'; // CameraScreenWithOverlay가 있는 모듈 import

class BodyImageProvider extends ChangeNotifier {
  final MyPageService _myPageService;

  BodyImageProvider(this._myPageService);

  String? _bodyImageUrl;
  bool _isFetching = false;
  bool _isUploading = false;

  String? get bodyImageUrl => _bodyImageUrl;
  bool get isFetching => _isFetching;
  bool get isUploading => _isUploading;

  Future<void> fetchBodyImage() async {
    if (_isFetching) return;

    final String? baseUrl = dotenv.env['BACKEND_URL'];
    if (baseUrl == null) return;

    final String? accessToken = await TokenStorage.getAccessToken();
    if (accessToken == null) return;

    final url = Uri.parse('$baseUrl/api/body-images/');

    try {
      _isFetching = true;
      notifyListeners();

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> bodyImages = jsonDecode(response.body);

        if (bodyImages.isNotEmpty) {
          final newImageUrl = bodyImages[0]['body_image'];

          if (_bodyImageUrl != newImageUrl) {
            _bodyImageUrl = newImageUrl;
            notifyListeners();
          }
        } else {
          _bodyImageUrl = null;
          notifyListeners();
        }
      }
    } catch (e) {
      print("🔴 fetchBodyImage 에러: $e");
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  /// 🟢 바디 이미지 업로드 및 ID 저장
  /// 카메라와 앨범 선택 옵션을 제공하여 이미지를 가져온 후 업로드합니다.
  Future<void> pickAndUploadBodyImage(BuildContext context) async {
    try {
      // 바텀시트를 통해 카메라/앨범 선택
      final choice = await showModalBottomSheet<String>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text("카메라"),
                  onTap: () => Navigator.pop(context, "camera"),
                ),
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text("앨범"),
                  onTap: () => Navigator.pop(context, "gallery"),
                ),
                ListTile(
                  leading: Icon(Icons.cancel),
                  title: Text("취소"),
                  onTap: () => Navigator.pop(context, null),
                ),
              ],
            ),
          );
        },
      );

      if (choice == null) {
        print("🔴 이미지 선택 취소됨");
        return;
      }

      String? imagePath;
      if (choice == "camera") {
        // 커스텀 카메라 위젯 호출 (오버레이 포함)
        imagePath = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraScreenWithOverlay(
              guidelineAsset: 'assets/fitting/body_guideline.png',
            ),
          ),
        );
      } else if (choice == "gallery") {
        // image_picker를 사용한 앨범 선택
        final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
        imagePath = image?.path;
      }

      if (imagePath == null) {
        print("🔴 이미지 선택 취소됨");
        return;
      }

      _isUploading = true;
      notifyListeners();

      final File pickedFile = File(imagePath);
      final result = await _myPageService.uploadMyPageBodyImage(pickedFile);
      if (result != null) {
        _bodyImageUrl = result['body_image'];
        print("🟢 바디 이미지 업로드 성공: URL=$_bodyImageUrl");
        notifyListeners();
      }
    } catch (e) {
      print("🔴 pickAndUploadBodyImage 에러: $e");
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  /// 현재 상태를 JSON 형식의 Map으로 변환합니다.
  Map<String, dynamic> toJson() {
    return {
      'body_image_url': _bodyImageUrl,
      'is_fetching': _isFetching,
      'is_uploading': _isUploading,
    };
  }
}

