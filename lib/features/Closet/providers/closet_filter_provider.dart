import 'package:flutter/foundation.dart';
import '../models/closet_item.dart';

/// ClosetFilterProvider: 메인 분류와 하위 분류를 함께 관리하는 상태 관리 클래스
class ClosetFilterProvider extends ChangeNotifier {
  // 초기 기본값 설정: 내옷(MyClothes) 에서 상의(Top) 선택
  ClosetCategory _selectedClosetCategory = ClosetCategory.myClothes;
  ClothType _selectedClothType = ClothType.Top;

  ClosetCategory get selectedClosetCategory => _selectedClosetCategory;
  ClothType get selectedClothType => _selectedClothType;

  /// setter: 하위 분류(ClothType) 직접 업데이트
  set selectedClothType(ClothType newType) {
    if (_selectedClothType != newType) {
      _selectedClothType = newType;
      notifyListeners();
    }
  }

  /// 메인 분류(ClosetCategory) 업데이트
  /// 메인 분류가 변경될 경우, 하위 분류(ClothType)를 초기값으로 리셋할 수도 있음
  void updateClosetCategory(ClosetCategory newCategory, {bool resetClothType = true}) {
    _selectedClosetCategory = newCategory;
    if (resetClothType) {
      // 메인 분류 변경 시 하위 분류를 기본값(여기서는 TOP)으로 리셋할 수 있음
      _selectedClothType = ClothType.Top;
    }
    notifyListeners();
  }

  /// 하위 분류(ClothType) 업데이트
  void updateClothType(ClothType newType) {
    _selectedClothType = newType;
    notifyListeners();
  }
}
