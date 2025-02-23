import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/body_image_provider.dart';
import 'fitting_selected_clothes.dart';

class FittingMainContent extends StatefulWidget {
  final VoidCallback onToggleCloset;

  FittingMainContent({required this.onToggleCloset});

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
    final bodyImageProvider = Provider.of<BodyImageProvider>(context, listen: false);
    await bodyImageProvider.fetchBodyImage();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Consumer<BodyImageProvider>(
            builder: (context, bodyImageProvider, child) {
              final imageUrl = bodyImageProvider.bodyImageUrl;

              return Center(
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.55,
                  color: Color(0xC7EEEEEE),
                  child: ClipRRect(
                    child: imageUrl != null
                        ? Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CupertinoActivityIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Text("🔴 이미지 로딩 실패");
                      },
                    )
                        : Image.asset(
                      "assets/closet/emptyCloset.png",
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "옷 고르기",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        await Provider.of<BodyImageProvider>(context, listen: false)
                            .pickAndUploadBodyImage();
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
                            style: TextStyle(fontSize: 14, color: CupertinoColors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  "피팅하고 싶은 옷을 모두 골라주세요!",
                  style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
                ),
                SizedBox(height: 7),
                FittingSelectedClothes(onToggleCloset: widget.onToggleCloset),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
