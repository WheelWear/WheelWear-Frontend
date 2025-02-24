import 'package:flutter/material.dart';
import 'package:wheelwear_frontend/features/Fitting/FittingResult/widgets/fitting_result_images.dart';
import 'widgets/fitting_result_buttons.dart';
import 'widgets/fitting_ai_size_recommend.dart';

class FittingResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("완성된 코디", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Container(
            height: screenHeight * 0.6,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: FittingResultImages(),
            ),
          ),
          SizedBox(height: 10),

          // ✅ AI 추천 영역
          FittingAISizeRecommend(),

          SizedBox(height: 10),

          // ✅ 하단 버튼 영역
          FittingResultButtons(),
        ],
      ),
    );
  }
}
