import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:wheelwear_frontend/utils/token_storage.dart';
import '../features/MyPage/mypage_service.dart';
import 'package:wheelwear_frontend/utils/image_picker_util.dart';

class BodyImageProvider extends ChangeNotifier {
  final MyPageService _myPageService;

  BodyImageProvider(this._myPageService);

  String? _bodyImageUrl;
  int? _bodyImageID;
  bool _isFetching = false;
  bool _isUploading = false;

  String? get bodyImageUrl => _bodyImageUrl;
  int? get bodyImageID => _bodyImageID;
  bool get isFetching => _isFetching;
  bool get isUploading => _isUploading;

  /// 🟢 로그인 후 바디 이미지 가져오기
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
          final newImageID = bodyImages[0]['id'];

          if (_bodyImageUrl != newImageUrl || _bodyImageID != newImageID) {
            _bodyImageUrl = newImageUrl;
            _bodyImageID = newImageID;
            notifyListeners();
          }
        } else {
          _bodyImageUrl = null;
          _bodyImageID = null;
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
  Future<void> pickAndUploadBodyImage() async {
    try {
      File? pickedFile = await ImagePickerUtil.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        print("🔴 이미지 선택 취소됨");
        return;
      }

      _isUploading = true;
      notifyListeners();

      final result = await _myPageService.uploadMyPageBodyImage(pickedFile);
      if (result != null) {
        _bodyImageUrl = result['body_image'];
        _bodyImageID = result['id'];
        print("🟢 바디 이미지 업로드 성공: ID=$_bodyImageID, URL=$_bodyImageUrl");
        notifyListeners();
      }
    } catch (e) {
      print("🔴 pickAndUploadBodyImage 에러: $e");
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
