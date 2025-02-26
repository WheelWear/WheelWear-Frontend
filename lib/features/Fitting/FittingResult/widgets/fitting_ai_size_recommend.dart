import 'package:flutter/material.dart';
import 'ai_size_recommend_modal.dart'; // 모달창이 정의된 파일
import 'package:provider/provider.dart';
import '../fitting_result_provider.dart';

class FittingAISizeRecommend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(right: 20),
        child: ElevatedButton.icon(
          onPressed: () {
            final fittingResultProvider = Provider.of<FittingResultProvider>(context, listen: false);

            // 객체 전체를 디버그 출력 (toString()이 오버라이드 되어 있다면 객체의 모든 내용이 출력됩니다)
            debugPrint("Selected image object details: ${fittingResultProvider.selectedImage?.image}");

            // 버튼 누르면 모달창을 띄웁니다.
            showDialog(
              context: context,
              builder: (context) => const AISizeRecommendModal(
                recommendedSize: "M",
                recommendedSizeDescription: "M 사이즈를 추천드립니다.",
                errorFlag: false,
                isLoading: false,
              ),
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
