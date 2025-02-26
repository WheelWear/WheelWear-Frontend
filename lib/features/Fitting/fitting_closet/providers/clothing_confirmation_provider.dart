import 'package:flutter/foundation.dart';

class ClothingConfirmationProvider extends ChangeNotifier {
  // 확정된 옷 아이템들의 id를 저장하는 리스트
  final List<int> confirmedClothes = [];

  // 선택된 옷들을 확정하여 저장하는 메서드
  void confirmSelection(List<int> selectedClothes) {
    confirmedClothes
      ..clear()
      ..addAll(selectedClothes);
    notifyListeners();
  }

  // 확정된 옷 목록 초기화
  void clearConfirmation() {
    confirmedClothes.clear();
    notifyListeners();
  }

  /// 현재 상태를 JSON 형식의 Map으로 변환합니다.
  Map<String, dynamic> toJson() {
    return {
      'confirmedClothes': confirmedClothes,
    };
  }
}
