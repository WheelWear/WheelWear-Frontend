import 'package:flutter/material.dart';

class EmptyClosetView extends StatelessWidget {
  const EmptyClosetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '옷장이 비어있습니다.',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}