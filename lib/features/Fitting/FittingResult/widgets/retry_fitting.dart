import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../fitting_result_provider.dart';
import 'package:path_provider/path_provider.dart';
import '../../fitting_service.dart';
import 'package:http/http.dart' as http;
import 'dart:io'; // File 사용을 위해 추가
import 'package:dio/dio.dart';
import 'package:wheelwear_frontend/utils/bodyImageManager/body_service.dart';

/// 선택된 이미지가 없거나, 저장 실패 시 false, 정상적으로 저장되면 true를 반환합니다.
Future<bool> vton_image_saved(BuildContext context) async {
  final provider = Provider.of<FittingResultProvider>(context, listen: false);
  debugPrint(provider.toJson().toString());
  final selectedImageID = provider.selectedImage?.id;
  print(selectedImageID);
  // 선택된 이미지가 없으면 false 반환
  if (selectedImageID == null) {
    return false;
  }

  try {
    // markFittingAsSaved 함수 호출 (vton 튜플의 'saved'를 true로 업데이트)
    await FittingService().markFittingAsSaved(selectedImageID);
    return true;
  } catch (error) {
    print("저장 실패: $error");
    return false;
  }
}

/// 선택된 이미지가 없거나, 저장 실패 시 false, 정상적으로 저장되면 true를 반환합니다.
Future<bool> patch_body_image(BuildContext context) async {
  final provider = Provider.of<FittingResultProvider>(context, listen: false);

  final selectedImagePath = provider.selectedImage?.image;
  if (selectedImagePath == null) {
    return false;
  }

  try {
    File file;
    // 만약 selectedImagePath가 http로 시작하면 네트워크 이미지이므로 임시 파일로 다운로드
    if (selectedImagePath.startsWith('http')) {
      final response = await http.get(Uri.parse(selectedImagePath));
      if (response.statusCode != 200) {
        print("이미지 다운로드 실패: ${response.statusCode}");
        return false;
      }
      final tempDir = await getTemporaryDirectory();
      // 고유한 파일명을 생성: 현재 시간을 밀리초 단위로 추가
      final uniqueFileName = 'temp_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final tempPath = '${tempDir.path}/$uniqueFileName';
      file = File(tempPath);
      await file.writeAsBytes(response.bodyBytes);
    } else {
      file = File(selectedImagePath);
    }

    final dio = Dio();
    final myPageService = MyPageService(dio: dio);
    final result = await myPageService.uploadMyPageBodyImage(file);
    return result != null;
  } catch (error) {
    print("저장 실패: $error");
    return false;
  }
}