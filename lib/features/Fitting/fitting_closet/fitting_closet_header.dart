import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/selection_provider.dart';
import 'widgets/headers/segmented_control_content.dart';
import 'widgets/headers/category_tabs.dart';

class FittingClosetHeader extends StatelessWidget {

  const FittingClosetHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectionProvider>(
      builder: (context, selectionProvider, child) {
        // 선택 상태에 따라 버튼 텍스트와 색상을 변경
        final String buttonText =
        selectionProvider.hasSelection ? "초기화" : "선택중";
        final Color buttonColor = selectionProvider.hasSelection
            ? CupertinoColors.systemTeal
            : CupertinoColors.systemGrey2;
        // hasSelection에 따라 pressedOpacity 결정 (효과 없는게 1)
        final double pressedOpacity = selectionProvider.hasSelection ? 0.4 : 1.0;

        return Column(
          children: [
            const SizedBox(height: 10),
            // SegmentedControlContent 위젯 (구현된 내용)
            const SegmentedControlContent(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // CategoryTabs 위젯 (구현된 내용)
                const CategoryTabs(),
                Container(
                  height: 22,
                  margin: const EdgeInsets.only(right: 20),
                  child: _buildSelectButton(context, buttonText, buttonColor, pressedOpacity),
                ),
              ],
            ),
            Divider(
              color: Colors.grey.shade300,
              thickness: 1,
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Widget _buildSelectButton(
      BuildContext context, String buttonText, Color buttonColor, double pressedOpacity) {
    return Align(
      alignment: Alignment.centerRight,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        color: buttonColor,
        // 클릭 효과(불투명도 변화)를 제거
        pressedOpacity: pressedOpacity,
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 12,
            color: CupertinoColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          if (buttonText == "초기화") {
            // 선택 상태가 있으면 초기화 수행
            context.read<SelectionProvider>().clearSelection();
            debugPrint('초기화 완료');
          } else {
            // 선택 상태가 없으면 필요한 로직 수행 (예: 선택 모드 활성화)
            debugPrint('선택 버튼이 탭되었습니다.');
          }
        },
      ),
    );
  }
}
