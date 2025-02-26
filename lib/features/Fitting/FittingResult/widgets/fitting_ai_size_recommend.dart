import 'package:flutter/material.dart';
import 'ai_size_recommend_modal.dart'; // 모달창이 정의된 파일
import 'package:provider/provider.dart';
import '../fitting_result_provider.dart';
import '../fitting_result_model.dart';
import '../../fitting_service.dart';

class FittingAISizeRecommend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(right: 20),
        child: ElevatedButton.icon(
          onPressed: () async {
            final fittingResultProvider = Provider.of<FittingResultProvider>(context, listen: false);

            // dressCloth, topCloth, bottomCloth 중 존재하는 clothID 선택
            int? clothID;
            if (fittingResultProvider.selectedImage?.dressCloth != null) {
              clothID = fittingResultProvider.selectedImage?.dressCloth?.id;
            } else if (fittingResultProvider.selectedImage?.topCloth != null) {
              clothID = fittingResultProvider.selectedImage?.topCloth?.id;
            } else if (fittingResultProvider.selectedImage?.bottomCloth != null) {
              clothID = fittingResultProvider.selectedImage?.bottomCloth?.id;
            }

            if (clothID == null) {
              debugPrint("Selected image is null");
              return;
            }

            debugPrint("Selected image clothID: $clothID");

            // 로딩 모달 표시 (취소 불가능)
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const AISizeRecommendModal(
                recommendedSize: "",
                recommendedSizeDescription: "분석 진행 중...",
                errorFlag: false,
                isLoading: true,
              ),
            );

            // API 호출 (clothID를 기반으로 추천 사이즈 조회)
            final responseData = await FittingService().fetchRecommendedSize(clothID);

            // 로딩 모달 닫기
            Navigator.of(context).pop();

            if (responseData != null) {
              // JSON 데이터를 모델로 파싱 (SizeRecommendation 모델 필요)
              final sizeRecommendation = SizeRecommendation.fromJson(responseData);

              // 추천 결과 모달 표시
              showDialog(
                context: context,
                builder: (context) => AISizeRecommendModal(
                  recommendedSize: sizeRecommendation.recommendSize ?? "",
                  recommendedSizeDescription: sizeRecommendation.additionalExplanation ?? "",
                  references: sizeRecommendation.references?.cast<String>(),
                  referenceNum: sizeRecommendation.referenceNum,
                  errorFlag: false,
                  isLoading: false,
                ),
              );
            } else {
              // API 호출 실패 시 에러 모달 표시
              showDialog(
                context: context,
                builder: (context) => const AISizeRecommendModal(
                  recommendedSize: "",
                  recommendedSizeDescription: "추천 사이즈를 불러오는데 실패했습니다.",
                  errorFlag: true,
                  isLoading: false,
                ),
              );
            }
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