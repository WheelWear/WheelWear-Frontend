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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("완성된 코디", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Provider를 이용해 생성된 이미지 개수를 확인하여 텍스트로 표시
            Consumer<FittingResultProvider>(
              builder: (context, provider, child) {
                return Text(
                  "생성된 이미지: ${provider.fittingImages.length}개",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                );
              },
            ),
            SizedBox(height: 10),
            Container(
              height: screenHeight * 0.6, // 화면 높이의 60% 적용
              child: FittingResultImages(),
            ),
            SizedBox(height: 10),
            // ✅ AI 추천 영역
            FittingAISizeRecommend(),
            SizedBox(height: 10),
            // ✅ 하단 버튼 영역
            FittingResultButtons(),
          ],
        ),
      ),
    );
  }
}
