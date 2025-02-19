import 'package:flutter/cupertino.dart';

class ClosetItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 10),
          // Spacer를 사용하려면 부모로부터 유한한 높이 제약을 받아야 합니다.
          // 이미 ClosetHeaderScreen에서 Expanded로 감쌌으므로 여기서 Spacer 사용 가능
          Spacer(),
          EmptyClosetView(),
          Spacer(),
        ],
      ),
    );
  }

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