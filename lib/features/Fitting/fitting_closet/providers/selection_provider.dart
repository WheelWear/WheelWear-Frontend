import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SelectionProvider extends ChangeNotifier {
  // 선택된 아이템들의 id나 인덱스를 저장하는 리스트
  final List<int> selectedItems = [];

  // 선택된 항목이 있는지 여부를 확인하는 getter 변수
  bool get hasSelection => selectedItems.isNotEmpty;

  // 아이템 선택/해제를 토글하는 예시 메서드
  void toggleItemSelection(int itemId) {
    if (selectedItems.contains(itemId)) {
      selectedItems.remove(itemId);
    } else {
      selectedItems.add(itemId);
    }
    notifyListeners();
  }

  void clearSelection() {
    debugPrint(selectedItems.toString());
    selectedItems.clear();
    notifyListeners();
  }

}
