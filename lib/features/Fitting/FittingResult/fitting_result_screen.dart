import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'fitting_result_provider.dart';
import 'widgets/fitting_result_images.dart';
import 'widgets/fitting_result_buttons.dart';
import 'widgets/fitting_ai_size_recommend.dart';

class FittingResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("완성된 코디", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                FittingResultImages(), // ✅ Provider에서 가져오므로 fittingImages 필요 없음
                SizedBox(height: 10),
                FittingAISizeRecommend(), // ✅ AI 사이즈 추천 버튼
              ],
            ),
          ),
          FittingResultButtons(), // ✅ 하단 버튼 (처음으로 / 저장 / 매칭하기)
        ],
      ),
    );
  }
}
