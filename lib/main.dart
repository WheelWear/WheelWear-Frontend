import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'features/Auth/login_screen.dart';

void main() {
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
