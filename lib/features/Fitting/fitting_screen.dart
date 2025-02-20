import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FittingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("피팅룸", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 📌 중앙 이미지
              Center(
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.6,
                  color: Color(0xC7EEEEEE),
                  child: Center(
                    child: Image.asset(
                      "assets/closet/emptyCloset.png",
                      width: 300,
                      height: 350,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // 📌 하단 섹션
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 📌 "옷 고르기" + "사진 변경" 버튼 한 줄 정렬
                    Row(
                      children: [
                        Text(
                          "옷 고르기",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Spacer(), // ✅ 자동으로 여백 추가하여 오른쪽 정렬
                        GestureDetector(
                          onTap: () {
                            // 사진 변경 기능 추가
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
                    SizedBox(height: 10),

                    Row(
                      children: [
                        _buildAddClothesButton(isDashed: false),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 옷 추가 버튼 위젯
  Widget _buildAddClothesButton({required bool isDashed}) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: CupertinoColors.systemGrey,
          width: 2,
          style: isDashed ? BorderStyle.solid : BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          CupertinoIcons.add,
          size: 30,
          color: CupertinoColors.systemGrey,
        ),
      ),
    );
  }
}

