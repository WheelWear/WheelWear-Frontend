// ai_size_recommend_modal.dart
import 'package:flutter/material.dart';

class AISizeRecommendModal extends StatelessWidget {
  final String recommendedSize;
  final String recommendedSizeDescription;
  final bool errorFlag;
  final bool isLoading;
  final List<String>? references;
  final int? referenceNum;

  const AISizeRecommendModal({
    Key? key,
    required this.recommendedSize,
    required this.recommendedSizeDescription,
    this.references,
    this.referenceNum,
    required this.errorFlag,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading) ...[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  const Text("분석 진행 중...", style: TextStyle(fontSize: 16)),
                ] else ...[
                  Text(
                    recommendedSize.isNotEmpty
                        ? "추천 사이즈: $recommendedSize"
                        : "추천 사이즈 결과",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    recommendedSizeDescription,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  if (references != null && references!.isNotEmpty)
                    ...[
                      const SizedBox(height: 10),
                      Text(
                        "참조 번호: ${referenceNum ?? ''}",
                        style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                    ],
                  const SizedBox(height: 20),
                  // 분석 완료 후 닫기 버튼
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("닫기"),
                  ),
                ]
              ],
            ),
          ),
          // 분석 중이 아닐 때만 우측 상단에 X 아이콘 표시 (모달 닫기)
          if (!isLoading)
            Positioned(
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
        ],
      ),
    );
  }
}
