import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AISizeRecommendModal extends StatelessWidget {
  final bool? isLoading;
  final bool? errorFlag;
  final String recommendedSize;
  final String recommendedSizeDescription;

  const AISizeRecommendModal({
    Key? key,
    this.isLoading,
    this.errorFlag,
    this.recommendedSize = "M",
    this.recommendedSizeDescription = "M Size를 추천드립니다.",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool loading = isLoading ?? false;
    final bool flag = errorFlag ?? false;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        // 높이 제한을 주어 스크롤 가능 영역이 생깁니다.
        constraints: BoxConstraints(
          maxHeight: 300,
        ),
        child: Stack(
          children: [
            // 오른쪽 상단 X 버튼 (쿠퍼티노 스타일)
            Positioned(
              right: 0,
              child: CupertinoButton(
                padding: EdgeInsets.all(10),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  CupertinoIcons.clear,
                  size: 24,
                ),
              ),
            ),
            // 가운데 내용 영역을 SingleChildScrollView로 감쌉니다.
            Positioned.fill(
              top: 50, // X 버튼 아래부터 시작하도록 위치 조정 (필요에 따라 수정)
              child: SingleChildScrollView(
                child: Center(
                  child: flag ? _buildErrorContent() : _buildContent(loading),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 로딩 중이면 로딩 이펙트를, 완료되었으면 추천 결과를 표시합니다.
  Widget _buildContent(bool loading) {
    if (loading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoActivityIndicator(radius: 15),
          SizedBox(height: 20),
          Text(
            "분석 진행 중...",
            style: TextStyle(fontSize: 16),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$recommendedSize 사이즈를 추천합니다!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: "다음은 AI가 분석한 추천 사이즈에 대한 설명입니다:\n\n",
                  style: TextStyle(fontSize: 11),
                ),
                TextSpan(
                  text: recommendedSizeDescription,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  // 에러 상태를 표시하는 위젯입니다.
  Widget _buildErrorContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          CupertinoIcons.exclamationmark_circle,
          size: 40,
          color: CupertinoColors.systemRed,
        ),
        SizedBox(height: 20),
        Text(
          "본인의 신체사이즈가 입력되지 않았거나 통신에 실패하였습니다.",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
