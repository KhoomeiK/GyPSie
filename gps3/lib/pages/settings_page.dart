import 'package:flutter/material.dart';
import 'algorithm.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:map_view/map_view.dart';


class SettingsPage extends StatefulWidget {
  State createState() => new SettingsPageState();
}

class SettingsPageState extends State<SettingsPage>{ 


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Padding (child: new Text ("Settings"),
        padding:const EdgeInsets.only(left: 0.0) ),
      ),
      body:
      Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[


            
          ],
        ),
      ),  
    );  
}

}