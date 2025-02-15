import 'package:flutter/cupertino.dart';

class ClosetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "나의 옷장",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: Icon(CupertinoIcons.bag, color: CupertinoColors.black),
        backgroundColor: CupertinoColors.white,
        border: Border(
          bottom: BorderSide(color: CupertinoColors.systemGrey4, width: 1),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            CategoryTabs(),
            SizedBox(height: 20),
            _buildSelectButton(),
            Spacer(),
            EmptyClosetView(),
            Spacer(),
          ],
        ),
      ),
    );
  }

  // "선택" 버튼
  Widget _buildSelectButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: CupertinoButton(
          padding: EdgeInsets.symmetric(horizontal: 16),
          color: CupertinoColors.systemGrey4,
          child: Text("선택", style: TextStyle(fontSize: 14, color: CupertinoColors.black)),
          onPressed: () {},
        ),
      ),
    );
  }

  // 카테고리 선택 탭
  Widget CategoryTabs() {
    return CupertinoSlidingSegmentedControl<int>(
      groupValue: 0,
      children: {
        0: Padding(padding: EdgeInsets.all(8), child: Text("전체")),
        1: Padding(padding: EdgeInsets.all(8), child: Text("상의")),
        2: Padding(padding: EdgeInsets.all(8), child: Text("하의")),
        3: Padding(padding: EdgeInsets.all(8), child: Text("원피스")),
      },
      onValueChanged: (value) {},
    );
  }

  // 비어있는 옷장 UI
  Widget EmptyClosetView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/closet/emptyCloset.png",
          width: 250,
          height: 250,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 20),
        Text(
          "옷장이 아직 비어있어요! \n옷을 추가해주세요!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: CupertinoColors.systemGrey),
        ),
      ],
    );
  }
}

