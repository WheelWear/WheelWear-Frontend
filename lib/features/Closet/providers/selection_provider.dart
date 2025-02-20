import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SelectionProvider extends ChangeNotifier {
  bool isSelectionMode = false;
  // 선택된 아이템들의 id나 인덱스를 저장하는 리스트
  final List<int> selectedItems = [];

  void toggleSelectionMode() {
    isSelectionMode = !isSelectionMode;
    // 선택 모드가 해제되면 선택된 아이템 초기화
    if (!isSelectionMode) {
      debugPrint(selectedItems.toString());
      selectedItems.clear();
    }
    notifyListeners();
  }

  // 아이템 선택/해제를 토글하는 예시 메서드
  void toggleItemSelection(int itemId) {
    if (selectedItems.contains(itemId)) {
      selectedItems.remove(itemId);
    } else {
      selectedItems.add(itemId);
    }
    notifyListeners();
  }
}
