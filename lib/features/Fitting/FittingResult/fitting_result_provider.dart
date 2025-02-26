import 'package:flutter/foundation.dart';
import 'fitting_result_model.dart'; // VirtualTryOnImage 모델 파일의 경로에 맞게 수정하세요.

class FittingResultProvider extends ChangeNotifier {
  List<VirtualTryOnImage> _fittingImages = [];
  List<SizeRecommendation> _sizeRecommendations = [];
  VirtualTryOnImage? _selectedImage;

  List<VirtualTryOnImage> get fittingImages => _fittingImages;
  VirtualTryOnImage? get selectedImage => _selectedImage;

  void setFittingImages(List<VirtualTryOnImage> images) {
    _fittingImages = images;
    // 처음에 첫번째 이미지를 선택
    if (images.isNotEmpty) {
      _selectedImage = images[0];
      print("첫번째 이미지 선택: ${_selectedImage?.id}");
    }
    notifyListeners();
  }

  void updateSelectedImage(VirtualTryOnImage image) {
    _selectedImage = image;
    notifyListeners();
  }

  void clearFittingImages() {
    _fittingImages.clear();
    notifyListeners();
  }

  // 새로운 피팅 이미지를 추가하는 메서드
  void addFittingImage(VirtualTryOnImage image) {
    _fittingImages.add(image);

    _selectedImage = _fittingImages[0];
    notifyListeners();
  }

  // 특정 피팅 이미지를 제거하는 메서드
  void removeFittingImage(VirtualTryOnImage image) {
    _fittingImages.remove(image);
    notifyListeners();
  }

  /// 현재 상태를 JSON 형식의 Map으로 변환합니다.
  Map<String, dynamic> toJson() {
    return {
      'fittingImages': _fittingImages.map((image) => image.toJson()).toList(),
      'selectedImage': _selectedImage?.toJson(),
    };
  }
}
