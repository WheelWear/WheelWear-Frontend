import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'features/Auth/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // 애플리케이션 시작 전에 dotenv 초기화
  print("앱 진입됨"); // 이 메시지가 브라우저 콘솔에 출력됩니다.
  await dotenv.load(fileName: "assets/config/.env");
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
          bodyLarge: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
        ),
      ),
      builder: (context, child) {
        return DefaultTextStyle(
          style: TextStyle(color: Colors.black),
          child: child!,
        );
      },
      home: LoginScreen(),
    );
  }
}
