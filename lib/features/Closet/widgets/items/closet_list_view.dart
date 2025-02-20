import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../models/closet_item.dart';
import '../../providers/closet_filter_provider.dart';
import '../../providers/selection_provider.dart';
import 'empty_closet_view.dart';

class ClosetListView extends StatelessWidget {
  final List<ClosetItem> items;

  const ClosetListView({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SelectionProvider의 상태를 읽어옴
    final selectionProvider = context.watch<SelectionProvider>();
    final isSelectionMode = selectionProvider.isSelectionMode;

    // Provider에서 선택된 ClosetCategory와 ClothType 값을 가져옴
    final closetFilterProvider = context.watch<ClosetFilterProvider>();
    final selectedCategory = closetFilterProvider.selectedClosetCategory;
    final selectedClothType = closetFilterProvider.selectedClothType;

    // 두 조건에 해당하는 아이템 필터링
    final filteredItems = items.where((item) {
      return item.closetCategory == selectedCategory &&
          item.clothType == selectedClothType;
    }).toList();

    // 필터링 결과가 비어있으면 EmptyClosetView를 보여줌
    if (filteredItems.isEmpty) {
      return EmptyClosetView();
    }

    // 아이템이 있을 경우 GridView로 표시
    return GridView.builder(
      padding: const EdgeInsets.only(left:16, right:16),
      itemCount: filteredItems.length + 1, // add_cloth_btn을 위한 공간 추가
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        // 첫번째 인덱스일 경우, SVG 버튼을 반환
        if (index == 0) {
          return GestureDetector(
            onTap: () {
              // add cloth 버튼 동작 구현 (예: 옷 추가 페이지 이동)
              debugPrint('add cloth 버튼이 탭되었습니다.');
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SvgPicture.asset(
                'assets/closet/add_cloth_btn.svg',
                fit: BoxFit.cover,
              ),
            ),
          );
        }
        // 나머지 인덱스는 필터링된 아이템 리스트에서 index - 1로 접근
        final item = filteredItems[index - 1];
        final isSelected = selectionProvider.selectedItems.contains(item.id);

        return GestureDetector(
          onTap: () {
            if (isSelectionMode) {
              // 선택 모드이면 해당 아이템의 선택 상태를 토글
              selectionProvider.toggleItemSelection(item.id);
            } else {
              // 일반 모드일 때는 기본 동작 (예: 상세 페이지 이동)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => /* 옷장 아이템 상세 페이지 위젯 */ Container()),
              );
            }
          },
          child: Stack(
            children: [
              // 아이템 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.clothImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              // 선택 모드일 때 오버레이로 선택 상태 표시
              if (isSelectionMode)
                Positioned(
                  top: 8,
                  right: 8,
                  child: _buildSelectionIndicator(isSelected),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectionIndicator(bool isSelected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected
            ? CupertinoColors.activeBlue
            : CupertinoColors.systemGrey5,
        border: Border.all(
          color: CupertinoColors.systemGrey,
        ),
      ),
      child: isSelected
          ? const Icon(
        Icons.check,
        size: 14,
        color: CupertinoColors.white,
      )
          : null,
    );
  }
}