import 'package:flutter/foundation.dart';
import 'fitting_result_model.dart'; // VirtualTryOnImage 모델 파일의 경로에 맞게 수정하세요.

class FittingResultProvider extends ChangeNotifier {
  List<VirtualTryOnImage> _fittingImages = [];

  List<VirtualTryOnImage> get fittingImages => _fittingImages;

  void clearFittingImages() {
    _fittingImages.clear();
    notifyListeners();
  }

  void setFittingImages(List<VirtualTryOnImage> images) {
    _fittingImages = images;
    notifyListeners();
  }

  // 새로운 피팅 이미지를 추가하는 메서드
  void addFittingImage(VirtualTryOnImage image) {
    _fittingImages.add(image);
    notifyListeners();
  }

  // 특정 피팅 이미지를 제거하는 메서드
  void removeFittingImage(VirtualTryOnImage image) {
    _fittingImages.remove(image);
    notifyListeners();
  }
}