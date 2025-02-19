import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'closet_item_screen.dart';
import 'widgets/headers/segmented_control_content.dart';
import 'widgets/headers/category_tabs.dart';


class ClosetHeaderScreen extends StatelessWidget {
  const ClosetHeaderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "내 옷장",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: Icon(CupertinoIcons.bag, color: CupertinoColors.black),
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
                    child: _buildSelectButton(),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade300,
                thickness: 1, // 두께
                // indent: 16,  // 왼쪽 여백
                // endIndent: 16,  // 오른쪽 여백
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

  Widget _buildSelectButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(horizontal: 18),
        color: CupertinoColors.systemGrey4,
        child: Text("선택",
            style: TextStyle(
                fontSize: 12,
                color: CupertinoColors.white,
                fontWeight: FontWeight.bold,
            ),
        ),
        onPressed: () {},
      ),
    );
  }
}