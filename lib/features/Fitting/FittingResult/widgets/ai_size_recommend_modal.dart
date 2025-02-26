import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AISizeRecommendModal extends StatelessWidget {
  final String recommendedSize;
  final String additionalExplanation;
  final List<String>? references;
  final int? referenceNum;
  final bool isLoading;
  final bool errorFlag;

  const AISizeRecommendModal({
    Key? key,
    required this.recommendedSize,
    required this.additionalExplanation,
    this.references,
    this.referenceNum,
    required this.isLoading,
    required this.errorFlag,
  }) : super(key: key);

  Future<void> _launchUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    // launchUrl의 mode를 외부 브라우저에서 열리도록 지정할 수 있습니다.
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("해당 URL을 열 수 없습니다.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: isLoading
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text("분석 진행 중...", style: TextStyle(fontSize: 16)),
              ],
            )
                : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 추천 사이즈 표시
                  Text(
                    recommendedSize.isNotEmpty
                        ? "추천 사이즈: $recommendedSize"
                        : "추천 사이즈 결과",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // 추가 설명 텍스트
                  Text(
                    additionalExplanation,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  // 참고자료 섹션 (참고자료가 있을 때만)
                  if (references != null && references!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "참고 자료:",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    // 참고자료 리스트
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: references!.length,
                      separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.search),
                          title: Text("참고 자료 ${index + 1}"),
                          onTap: () => _launchUrl(context, references![index]),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 20),
                  // 닫기 버튼
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("닫기"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
