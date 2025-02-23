import 'package:flutter/material.dart';
import 'package:wheelwear_frontend/features/Fitting/FittingResult/widgets/fitting_result_images.dart';
import 'widgets/fitting_result_buttons.dart';
import 'widgets/fitting_ai_size_recommend.dart';

class FittingResultScreen extends StatelessWidget {
  final bool safeMode;

  FittingResultScreen({this.safeMode = false});

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
            child: safeMode
                ? PageView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[300],
                  ),
                  child: Center(child: Text("슬라이드 ${index + 1}", style: TextStyle(fontSize: 18, color: Colors.black54))),
                );
              },
            )
                : FittingResultImages(),
          ),

          SizedBox(height: 10),

          // ✅ AI 추천 영역 (Safe Mode 적용)
          safeMode
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("💡 Safe Mode: AI 사이즈 추천", style: TextStyle(fontSize: 16, color: Colors.grey)),
          )
              : FittingAISizeRecommend(),

          SizedBox(height: 10),

          // ✅ 하단 버튼 영역
          FittingResultButtons(),
        ],
      ),
    );
  }
}
