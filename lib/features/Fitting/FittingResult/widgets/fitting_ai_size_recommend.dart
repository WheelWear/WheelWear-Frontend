import 'package:flutter/material.dart';
import 'ai_size_recommend_modal.dart'; // 모달창이 정의된 파일

class FittingAISizeRecommend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(right: 20),
        child: ElevatedButton.icon(
          onPressed: () {
            // 버튼 누르면 모달창을 띄웁니다.
            showDialog(
              context: context,
              builder: (context) => const AISizeRecommendModal(),
            );
          },
          icon: Icon(Icons.auto_awesome, color: Colors.orange),
          label: Text("AI 사이즈 추천 보기", style: TextStyle(color: Colors.grey)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
