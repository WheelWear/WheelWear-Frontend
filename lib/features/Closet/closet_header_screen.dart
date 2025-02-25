import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'closet_item_screen.dart';
import 'widgets/headers/segmented_control_content.dart';
import 'widgets/headers/category_tabs.dart';
import 'package:provider/provider.dart';
import 'providers/selection_provider.dart';


class ClosetHeaderScreen extends StatelessWidget {
  const ClosetHeaderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
        middle: Text(
          "내 옷장",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: CupertinoColors.white,
        border: Border(
          bottom: BorderSide(color: CupertinoColors.systemGrey4, width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            children: [
              SizedBox(height: 10),
              SegmentedControlContent(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 왼쪽: CategoryTabs
                  CategoryTabs(),
                  // 오른쪽: 버튼
                  Container(
                    height: 22,
                    margin: const EdgeInsets.only(right: 20),
                    child: _buildSelectButton(context),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade300,
                thickness: 1,
              ),
              SizedBox(height: 10),
              // ClosetItemScreen은 Expanded로 감싸서 부모의 남은 공간을 채우도록 함
              Expanded(child: ClosetItemScreen()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectButton(BuildContext context) {
    // Provider에서 선택 모드 상태를 읽어옴
    final isSelectionMode = context.watch<SelectionProvider>().isSelectionMode;
    return Align(
      alignment: Alignment.centerRight,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        // isSelectionMode 값에 따라 버튼 색상 변경
        color: isSelectionMode ? CupertinoColors.activeGreen : CupertinoColors.systemGrey4,
        child: Text(
          // isSelectionMode 값에 따라 버튼 텍스트 변경
          isSelectionMode ? "취소" : "선택",
          style: const TextStyle(
            fontSize: 12,
            color: CupertinoColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          // 선택 모드 토글
          context.read<SelectionProvider>().toggleSelectionMode();
          debugPrint('선택 모드: ${context.read<SelectionProvider>().isSelectionMode}');
        },
      ),
    );
  }
}