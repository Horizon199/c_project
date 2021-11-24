import 'package:flutter/material.dart';
import 'package:c_project/Pages/login.dart';
import 'package:c_project/Pages/check_in.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}