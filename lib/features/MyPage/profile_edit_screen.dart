import 'package:flutter/cupertino.dart';

class ProfileEditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("프로필 편집"),
      ),
      child: Center(
        child: Text("프로필 편집", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
