import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheelwear_frontend/features/Fitting/FittingResult/widgets/fitting_result_images.dart';
import 'package:wheelwear_frontend/utils/retryable_cached_network_image.dart';
import 'widgets/fitting_result_buttons.dart';
import 'widgets/fitting_ai_size_recommend.dart';
import 'fitting_result_provider.dart'; // Provider 경로에 맞게 수정하세요.

class FittingResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로가기 아이콘 자동 생성 방지
        title: Text(
          "완성된 코디",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              height: screenHeight * 0.6, // 화면 높이의 60% 적용
              child: FittingResultImages(),
            ),
            SizedBox(height: 10),
            // ✅ AI 추천 영역
            FittingAISizeRecommend(),
            SizedBox(height: 30),
            // ✅ 하단 버튼 영역
            FittingResultButtons(),
          ],
        ),
      ),
    );
  }
}
