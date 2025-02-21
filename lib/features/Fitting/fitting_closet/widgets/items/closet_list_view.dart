import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/closet_item.dart';
import '../../providers/closet_filter_provider.dart';
import '../../providers/selection_provider.dart';
import 'closet_item_tile.dart';
import 'select_mode_button.dart';

class ClosetListView extends StatelessWidget {
  final List<ClosetItem> items;
  // FittingScreen에서 전달한 콜백을 저장하는 변수
  final VoidCallback onExitClosetScreen;
  const ClosetListView({Key? key, required this.items, required this.onExitClosetScreen}) : super(key: key);

  // Provider에서 선택된 closetCategory와 clothType을 만족하는 아이템만 반환
  List<ClosetItem> _filterItems(BuildContext context, List<ClosetItem> items) {
    final filterProvider = Provider.of<ClosetFilterProvider>(context, listen: true);
    return items.where((item) {
      return item.closetCategory == filterProvider.selectedClosetCategory && item.closetCategory != "donation" &&
          item.clothType == filterProvider.selectedClothType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    final filteredItems = _filterItems(context, items);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          // 아이템이 하나도 없을 때, emptyCloset 이미지를 중앙에 표시
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
            itemCount: filteredItems.length, // 첫번째 항목은 AddClothButton 위젯
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final item = filteredItems[index];
              return ClosetItemTile(item: item);
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: SelectModeButton(onExitClosetScreen:onExitClosetScreen),
          ),
        ],
      ),
    );
  }
}
