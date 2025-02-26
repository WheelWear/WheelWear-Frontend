import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      print("이미지 선택 오류: $e");
      return null;
    }
  }
}
