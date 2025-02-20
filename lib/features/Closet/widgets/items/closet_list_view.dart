import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/closet_item.dart';
import '../../providers/closet_filter_provider.dart';
import '../../providers/selection_provider.dart';
import 'add_cloth_button.dart';
import 'closet_item_tile.dart';
import 'select_mode_button.dart';

class ClosetListView extends StatelessWidget {
  final List<ClosetItem> items;
  const ClosetListView({Key? key, required this.items}) : super(key: key);

  // Provider에서 선택된 closetCategory와 clothType을 모두 만족하는 아이템만 반환하도록 필터링
  List<ClosetItem> _filterItems(BuildContext context, List<ClosetItem> items) {
    final filterProvider = Provider.of<ClosetFilterProvider>(context, listen: true);
    return items.where((item) {
      return item.closetCategory == filterProvider.selectedClosetCategory &&
          item.clothType == filterProvider.selectedClothType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // SelectionProvider에서 선택모드 여부 가져오기
    final selectionProvider = Provider.of<SelectionProvider>(context, listen: true);
    final isSelectionMode = selectionProvider.isSelectionMode;

    final filteredItems = _filterItems(context, items);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          // 아이템이 하나도 없을 때, 배경에 emptyCloset 이미지 표시 (크기 조정 및 패딩 적용)
          if (filteredItems.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Image.asset(
                  'assets/closet/emptyCloset.png',
                  width: MediaQuery.of(context).size.width * 0.6,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          GridView.builder(
            itemCount: filteredItems.length + 1, // 첫번째 항목은 AddClothButton 위젯
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              if (index == 0) {
                return const AddClothButton();
              } else {
                final item = filteredItems[index - 1];
                return ClosetItemTile(item: item);
              }
            },
          ),
          if (isSelectionMode)
            Positioned(
              bottom: 16,
              right: 16,
              child: SelectModeButton(),
            ),
        ],
      ),
    );
  }
}
