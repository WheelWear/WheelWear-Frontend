import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyClosetView extends StatelessWidget {
  const EmptyClosetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // 배경: 중앙에 empty 이미지와 텍스트 배치
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/closet/emptyCloset.png",
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  "옷장이 아직 비어있어요! \n옷을 추가해주세요!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: CupertinoColors.systemGrey),
                ),
              ],
            ),
          ),
          // 전경: 좌측 상단에 add cloth 버튼 배치 (margin은 왼쪽만 적용)
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 16),
              padding: const EdgeInsets.all(1),
              child: GestureDetector(
                onTap: () {
                  // 옷 추가 동작(예: 페이지 이동) 구현
                  debugPrint('add cloth 버튼이 탭되었습니다.');
                },
                child: SvgPicture.asset(
                  'assets/closet/add_cloth_btn.svg',
                  width: 111,
                  height: 111,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
