import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/bodyImageManager/body_image_provider.dart';
import 'fitting_selected_clothes.dart';
import 'package:wheelwear_frontend/utils/retryable_cached_network_image.dart'; // 경로는 실제 파일 위치에 맞게 수정하세요

class FittingMainContent extends StatefulWidget {
  final VoidCallback onToggleCloset;
  final Function(bool) setLoading;

  FittingMainContent({
    required this.onToggleCloset,
    required this.setLoading,
  });

  @override
  _FittingMainContentState createState() => _FittingMainContentState();
}

class _FittingMainContentState extends State<FittingMainContent> {
  @override
  void initState() {
    super.initState();
    _fetchBodyImage();
  }

  void _fetchBodyImage() async {
    final bodyImageProvider =
    Provider.of<BodyImageProvider>(context, listen: false);
    await bodyImageProvider.fetchBodyImage();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 상단 이미지 영역
          Consumer<BodyImageProvider>(
            builder: (context, bodyImageProvider, child) {
              final imageUrl = bodyImageProvider.bodyImageUrl;
              return Center(
                child: Container(
                  color: Color(0xC7EEEEEE),
                  child: ClipRRect(
                    child: imageUrl != null
                        ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 420,
                      child: RetryableCachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                        borderRadius: 0,
                      ),
                    )
                        : Image.asset(
                      "assets/closet/emptyCloset.png",
                      width: MediaQuery.of(context).size.width,
                      height: 420,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
          // 하단 컨텐츠 영역
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "옷 고르기"와 "사진 변경" 버튼 Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "옷 고르기",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        final bodyImageProvider = Provider.of<BodyImageProvider>(
                            context,
                            listen: false);
                        await bodyImageProvider.pickAndUploadBodyImage(context);
                      },
                      child: Container(
                        width: 90,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Color(0xFFC3C3C3),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "사진 변경",
                            style: TextStyle(
                                fontSize: 14, color: CupertinoColors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  "피팅하고 싶은 옷을 모두 골라주세요!",
                  style: TextStyle(
                      fontSize: 14, color: CupertinoColors.systemGrey),
                ),
                SizedBox(height: 25),
                FittingSelectedClothes(
                  onToggleCloset: widget.onToggleCloset,
                  setLoading: widget.setLoading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
