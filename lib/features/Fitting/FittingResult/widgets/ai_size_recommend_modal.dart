import 'package:flutter/material.dart';

class AISizeRecommendModal extends StatelessWidget {
  const AISizeRecommendModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "AI 사이즈 추천",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "여기에 AI 사이즈 추천 결과를 표시합니다.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달창 닫기
              },
              child: Text("닫기"),
            ),
          ],
        ),
      ),
    );
  }
}
