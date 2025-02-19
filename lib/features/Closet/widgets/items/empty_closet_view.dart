import 'package:flutter/cupertino.dart';

class EmptyClosetView extends StatelessWidget {
  const EmptyClosetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
