import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './fitting_closet_header.dart';
import './fitting_closet_item.dart';

class FittingClosetScreen extends StatelessWidget {
  // FittingScreen에서 전달한 콜백을 저장하는 변수
  final VoidCallback onExitClosetScreen;

  // 생성자에서 콜백을 받아옵니다.
  const FittingClosetScreen({Key? key, required this.onExitClosetScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 20),
          child: Column(
            children: [
              FittingClosetHeader(),
              // 헤더 부분 이후 남은 공간에 아이템 리스트 배치
              Expanded(child: FittingClosetItem(onExitClosetScreen:onExitClosetScreen)),
            ],
          ),
        ),
      ),
    );
  }
}
