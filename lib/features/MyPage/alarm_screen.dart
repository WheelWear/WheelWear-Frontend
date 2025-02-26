import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlarmScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Align(
          alignment: Alignment.center,
          child: Text(
            "알림",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 0,
          child: Icon(
            CupertinoIcons.clear,
            size: 30,
            color: CupertinoColors.systemGrey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      child: SafeArea(
        child: Container(
          color: CupertinoColors.systemGrey6,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "오늘 받은 알림",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              _buildNotificationCard(
                  "👕", "띠링~ 기부하실 시간!", "기부함이 다 찼어요. 방문수거 서비스를 신청해주세요.", "8h"),
              SizedBox(height: 20),
              Text(
                "이전 알림",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              _buildNotificationCard(
                  "🎉", "첫 기부 축하드립니다!", "방문수거 서비스는 어땠는지 평가해주세요.", "1yr"),
              _buildNotificationCard(
                  "🚀",
                  "입지 않는 옷을 기부해보는 건 어떠세요?",
                  "내 옷장에서 기부함에 넣으면, 저희 WheelWear가 수거해 가요!",
                  "1yr"),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildNotificationCard(
    String emoji, String title, String content, String time) {
  return Container(
    padding: EdgeInsets.all(12),
    margin: EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: CupertinoColors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: CupertinoColors.black.withOpacity(0.05),
          blurRadius: 10,
          spreadRadius: 2,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: TextStyle(fontSize: 24)),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                        fontSize: 12, color: CupertinoColors.systemGrey),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(content,
                  style: TextStyle(fontSize: 14, color: CupertinoColors.black)),
            ],
          ),
        ),
      ],
    ),
  );
}
