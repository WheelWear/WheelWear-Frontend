import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_section.dart';
import 'alarm_screen.dart';
import '../../utils/bodyImageManager/body_image_provider.dart';
import 'package:wheelwear_frontend/utils/retryable_cached_network_image.dart';
import 'profile_provider.dart';

class MyPageScreen extends StatefulWidget {
  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  @override
  void initState() {
    super.initState();
    // 프로필 데이터를 불러옵니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).loadProfile(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("마이페이지"),
        automaticallyImplyLeading: false,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 0,
          child: Icon(
            CupertinoIcons.bell,
            size: 30,
            color: CupertinoColors.systemGrey,
          ),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => AlarmScreen()),
            );
          },
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              // 프로필 영역
              ProfileSection(),
              SizedBox(height: 10),
              _buildPhotoSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Consumer<BodyImageProvider>(
      builder: (context, bodyImageProvider, child) {
        final imageUrl = bodyImageProvider.bodyImageUrl;
        final isUploading = bodyImageProvider.isUploading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 1, color: CupertinoColors.systemGrey4),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  if (imageUrl == null) ...[
                    Text(
                      "내 사진 없음",
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    SizedBox(height: 10),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Container(
                        width: 80,
                        height: 80,
                        child: Icon(
                          CupertinoIcons.add,
                          size: 120,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      onPressed: isUploading
                          ? null
                          : () async {
                        await bodyImageProvider.pickAndUploadBodyImage(context);
                      },
                    ),
                  ] else ...[
                    SizedBox(
                      width: 310,
                      height: 410,
                      child: RetryableCachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        borderRadius: 10,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: 310,
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: isUploading
                            ? null
                            : () async {
                          await bodyImageProvider.pickAndUploadBodyImage(context);
                        },
                        child: Container(
                          width: 90,
                          height: 28,
                          decoration: ShapeDecoration(
                            color: isUploading
                                ? Color(0xFFA0A0A0)
                                : Color(0xFFC3C3C3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          child: Center(
                            child: isUploading
                                ? CupertinoActivityIndicator()
                                : Text(
                              "사진 변경",
                              style: TextStyle(
                                fontSize: 14,
                                color: CupertinoColors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
