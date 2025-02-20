import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/selection_provider.dart';
import '../../providers/closet_items_provider.dart';
import '../../providers/closet_filter_provider.dart'; // closet 카테고리 관리 Provider
import '../../services/api_service.dart';
import '../../models/closet_item.dart';

class SelectModeButton extends StatelessWidget {
  const SelectModeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provider에서 SelectionProvider, ClosetItemsProvider, ClosetFilterProvider를 가져옴
    final selectionProvider = Provider.of<SelectionProvider>(context, listen: false);
    final closetItemsProvider = Provider.of<ClosetItemsProvider>(context, listen: false);
    final closetFilterProvider = Provider.of<ClosetFilterProvider>(context, listen: false);

    // 기부 버튼을 숨길 조건 설정: 현재 카테고리가 donation이나 wishlist일 경우
    final bool hideDonationButton = closetFilterProvider.selectedClosetCategory == ClosetCategory.donation ||
        closetFilterProvider.selectedClosetCategory == ClosetCategory.wishlist;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 조건에 따라 기부 버튼 렌더링
        if (!hideDonationButton)
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: const Color(0xFF4C93FF),
            borderRadius: BorderRadius.circular(8),
            child: const Text(
              "기부",
              style: TextStyle(color: CupertinoColors.white),
            ),
            onPressed: () async {
              debugPrint("기부 버튼이 탭되었습니다.");
              try {
                final List<int> selectedItems = selectionProvider.selectedItems;
                debugPrint("선택된 아이템 리스트: $selectedItems");

                // 선택된 cloth의 closet_category를 "donation"으로 업데이트하는 PATCH 요청
                await ApiService().updateClothesToDonation(selectedItems);

                // 업데이트 후 Provider를 통해 최신 데이터 받아오기
                await closetItemsProvider.fetchClosetItems();
                debugPrint("Provider 최신 데이터 받아옴: ${closetItemsProvider.items.length}개");

                // 선택 상태 초기화
                selectionProvider.clearSelection();
                debugPrint("기부 및 데이터 새로고침 완료");
              } catch (e) {
                debugPrint("기부 실패: $e");
              }
            },
          ),
        if (!hideDonationButton) const SizedBox(width: 16), // 기부 버튼이 보일 때만 간격 추가
        // 삭제 버튼은 항상 보임
        CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          color: const Color(0xFFFF6C6C),
          borderRadius: BorderRadius.circular(8),
          child: const Text(
            "삭제",
            style: TextStyle(color: CupertinoColors.white),
          ),
          onPressed: () async {
            debugPrint("삭제 버튼이 탭되었습니다.");
            try {
              final List<int> selectedItems = selectionProvider.selectedItems;
              debugPrint("선택된 아이템 리스트: $selectedItems");

              await ApiService().deleteClothes(selectedItems);
              await closetItemsProvider.fetchClosetItems();
              debugPrint("Provider 최신 데이터 받아옴: ${closetItemsProvider.items.length}개");

              selectionProvider.clearSelection();
              debugPrint("삭제 및 데이터 새로고침 완료");
            } catch (e) {
              debugPrint("삭제 실패: $e");
            }
          },
        ),
      ],
    );
  }
}
