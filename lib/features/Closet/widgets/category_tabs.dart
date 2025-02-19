import 'package:flutter/cupertino.dart';
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
