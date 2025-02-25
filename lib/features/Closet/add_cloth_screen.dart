import 'package:flutter/material.dart';

class AddClothScreen extends StatelessWidget {
  const AddClothScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱바에 제목을 추가
      appBar: AppBar(
        title: const Text('옷 아이템 추가'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('여기에 옷 아이템 추가 폼을 작성하세요.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 추가 로직 후 이전 페이지로 돌아가기
                Navigator.pop(context);
              },
              child: const Text('저장 후 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
