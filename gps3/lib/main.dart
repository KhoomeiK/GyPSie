import 'package:flutter/material.dart';
import 'pages/main_page.dart';

void main() {
  runApp(new GyPSie());
}
class GyPSie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'gypsie',
      home: MainPage(),
    );
  }
}