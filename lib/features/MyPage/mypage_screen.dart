import 'package:flutter/cupertino.dart';

class MyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("마이 페이지", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      child: Center(
        child: Text("마이페이지", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
