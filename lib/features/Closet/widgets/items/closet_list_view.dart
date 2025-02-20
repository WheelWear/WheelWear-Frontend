import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../models/closet_item.dart';
import '../../closet_filter_provider.dart';

class ClosetListView extends StatelessWidget {
  final List<ClosetItem> items;

  const ClosetListView({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provider에서 선택된 ClosetCategory와 ClothType 값을 가져옴
    final closetFilterProvider = context.watch<ClosetFilterProvider>();
    final selectedCategory = closetFilterProvider.selectedClosetCategory;
    final selectedClothType = closetFilterProvider.selectedClothType;

    // 두 조건에 해당하는 아이템 필터링
    final filteredItems = items.where((item) {
      return item.closetCategory == selectedCategory &&
          item.clothType == selectedClothType;
    }).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3열로 배치
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1, // 정사각형 셀
      ),
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(8), // 모서리 둥글게
          child: Image.network(
            item.clothImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: SvgPicture.asset(
                  'assets/closet/add_cloth_btn.svg',
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
