import 'package:flutter/material.dart';
import './pages/main_page.dart';
import 'package:map_view/map_view.dart';

void main() async {
  
  MapView.setApiKey("AIzaSyD0zb7Xdwk0FH-TOVbYkCTjSQargAwjb84");
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