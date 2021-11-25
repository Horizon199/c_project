import 'package:flutter/material.dart';
import 'package:c_project/Pages/login.dart';
import 'Pages/checkin2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
