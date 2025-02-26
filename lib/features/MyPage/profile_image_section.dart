import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheelwear_frontend/utils/retryable_cached_network_image.dart'; // RetryableCachedNetworkImage를 import합니다.

class ProfileImageSection extends StatelessWidget {
  final File? imageFile;       // 사용자가 선택한 이미지 파일
  final String? imageUrl;      // 백엔드에서 받아온 이미지 URL
  final VoidCallback? onImageTap; // 수정 가능 여부에 따라 null 허용

  ProfileImageSection({
    required this.imageFile,
    required this.imageUrl,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget displayedImage;
    if (imageFile != null) {
      displayedImage = Image.file(
        imageFile!,
        fit: BoxFit.cover,
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      displayedImage = RetryableCachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
      );
    } else {
      displayedImage = Icon(
        CupertinoIcons.person,
        size: 40,
        color: CupertinoColors.systemGrey,
      );
    }

    return GestureDetector(
      onTap: onImageTap,
      child: Container(
        width: 75,
        height: 75,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: ShapeDecoration(
                color: CupertinoColors.white,
                shape: OvalBorder(
                  side: BorderSide(width: 2, color: Color(0xFF97999B)),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipOval(child: displayedImage),
            ),
            // onImageTap이 있을 때만 연필 아이콘 표시
            if (onImageTap != null)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CupertinoColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.systemGrey.withOpacity(0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    CupertinoIcons.pencil,
                    size: 16,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
