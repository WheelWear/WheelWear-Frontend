import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../retryable_cached_network_image.dart';
import '../../models/closet_item.dart';
import '../../providers/selection_provider.dart';

class ClosetItemTile extends StatelessWidget {
  final ClosetItem item;
  const ClosetItemTile({Key? key, required this.item}) : super(key: key);

  Widget _buildSelectionIndicator(bool isSelected) {
    // iOS 스타일: 선택되면 채워진 파란색 체크 아이콘, 미선택이면 빈 원형 아이콘
    return Icon(
      isSelected ? CupertinoIcons.check_mark_circled_solid : null,
      color: isSelected ? Colors.blue : Colors.white,
      size: 28,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectionProvider = Provider.of<SelectionProvider>(context);
    bool isSelected = selectionProvider.selectedItems.contains(item.id);

    return GestureDetector(
      onTap: () {
        if (selectionProvider.isSelectionMode) {
          selectionProvider.toggleItemSelection(item.id);
        } else {
          // 일반 탭 동작 처리 (필요시 추가)
        }
      },
      child: Stack(
        children: [
          // 다운로드 실패 시 재시도 로직이 포함된 이미지 위젯 사용
          Center(
            child: RetryableCachedNetworkImage(
              imageUrl: item.clothImage,
              fit: BoxFit.cover,
              borderRadius: 8,
            ),
          ),
          // 선택 모드일 때, 미선택 아이템은 어둡게 처리
          if (selectionProvider.isSelectionMode && !isSelected)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          // 선택 모드이면 우측 상단에 선택 인디케이터 표시
          if (selectionProvider.isSelectionMode)
            Positioned(
              top: 8,
              right: 8,
              child: _buildSelectionIndicator(isSelected),
            ),
        ],
      ),
    );
  }
}
