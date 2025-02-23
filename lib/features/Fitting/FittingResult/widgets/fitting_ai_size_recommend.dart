import 'package:flutter/material.dart';

class FittingAISizeRecommend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(right: 20),
        child: ElevatedButton.icon(
          onPressed: null, // ✅ 비활성화 상태
          icon: Icon(Icons.auto_awesome, color: Colors.orange),
          label: Text("AI 사이즈 추천 보기", style: TextStyle(color: Colors.grey)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
    );
  }
}
