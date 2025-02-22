import 'package:flutter/foundation.dart';

class FittingCreationProvider extends ChangeNotifier {
  // 예: {"top_cloth": 101, "bottom_cloth": 202} 식으로 저장
  final Map<String, int> _selectedClothIds = {};

  // 즐겨찾기 여부, 타이틀 같은 추가 필드가 있다면 따로 저장
  bool _isFavorite = false;
  final String _title = "생성된 옷";

  // Getter
  bool get isFavorite => _isFavorite;
  String get title => _title;

  // Setter
  void setIsFavorite(bool value) {
    _isFavorite = value;
    notifyListeners();
  }

  /// clothKey 예: "top_cloth", "bottom_cloth", "dress_cloth", "body_image"
  void setClothId(String clothKey, int clothId) {
    _selectedClothIds[clothKey] = clothId;
    notifyListeners();
  }

  /// 특정 키의 선택을 해제할 때
  void removeClothId(String clothKey) {
    if (_selectedClothIds.containsKey(clothKey)) {
      _selectedClothIds.remove(clothKey);
      notifyListeners();
    }
  }

  /// 최종적으로 서버에 보낼 JSON 생성
  Map<String, dynamic> toJson() {
    // 기본 데이터(타이틀, 즐겨찾기 여부 등)
    final data = <String, dynamic>{
      'title': _title,
      'is_favorite': _isFavorite,
    };

    // 선택된 옷들(상의/하의/원피스/바디이미지 등)을 Map에 동적으로 병합
    _selectedClothIds.forEach((key, value) {
      data[key] = value;
    });

    return data;
  }
}
