import 'package:flutter/cupertino.dart';
import 'closet_item_screen.dart';
import 'widgets/segmented_control_content.dart';
import 'widgets/category_tabs.dart';

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
              SizedBox(height: 20),
              CategoryTabs(),
              SizedBox(height: 20),
              Container(
                height: 22,
                margin: EdgeInsets.only(right: 20), // 오른쪽에 16 픽셀 여백
                child: _buildSelectButton(),
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
                color: CupertinoColors.darkBackgroundGray,
                fontWeight: FontWeight.bold,
            ),
        ),
        onPressed: () {},
      ),
    );
  }
}