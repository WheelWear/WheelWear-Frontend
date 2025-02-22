import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wheelwear_frontend/utils/image_picker_util.dart';
import '../features/MyPage/mypage_service.dart';

class BodyImageProvider extends ChangeNotifier {
  final MyPageService _myPageService;

  BodyImageProvider(this._myPageService);

  String? _bodyImageUrl;
  String? get bodyImageUrl => _bodyImageUrl;

  // 업로드 중인지 여부를 나타내는 필드 및 getter
  bool _isUploading = false;
  bool get isUploading => _isUploading;

  Future<void> pickAndUploadMyPageBodyImage() async {
    try {
      File? pickedFile = await ImagePickerUtil.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        print("🔴 이미지 선택 취소됨");
        return;
      }

      _isUploading = true;
      notifyListeners();

      final url = await _myPageService.uploadMyPageBodyImage(pickedFile);
      if (url != null) {
        _bodyImageUrl = url;
        print("🟢 바디 이미지 업로드 성공: $_bodyImageUrl");
        notifyListeners();
      }
    } catch (e) {
      print("🔴 pickAndUploadMyPageBodyImage 에러: $e");
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

}
