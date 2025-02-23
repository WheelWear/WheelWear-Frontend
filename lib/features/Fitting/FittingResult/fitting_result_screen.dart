import 'package:flutter/material.dart';
import 'widgets/fitting_result_images.dart';
import 'widgets/fitting_result_buttons.dart';
import 'widgets/fitting_ai_size_recommend.dart';

class FittingResultScreen extends StatelessWidget {
  final List<String> fittingImages; // ✅ 피팅된 이미지 리스트

  FittingResultScreen({required this.fittingImages});

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
                FittingResultImages(fittingImages: fittingImages), // ✅ 이미지 슬라이더
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
