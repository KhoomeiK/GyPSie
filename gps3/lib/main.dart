import 'package:flutter/material.dart';
import './pages/main_page.dart';

void main() async {
  runApp(new Pulse());
}
class Pulse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'pulse',
      home: MainPage(),
    );
  }
}