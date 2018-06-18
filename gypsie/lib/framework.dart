import 'package:flutter/material.dart';

void main() => runApp(new RealWorldApp());

class RealWorldApp extends StatefulWidget {
@override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RealWorldState();
  }
 }

 class RealWorldState extends State<RealWorldApp> {
   var _isLoading = true;


   @override
     Widget build(BuildContext context) {
       return new MaterialApp(
         home: new Scaffold(
           appBar: new AppBar(
             title: new Text("GyPSie Navigation"),
             actions: <Widget>[
               new IconButton(icon: new Icon(Icons.search),
               onPressed: () {
                  print("Destination");
               },)
             ],
           ),
           body: new Center(
             child: _isLoading ?  new CircularProgressIndicator() : 
              new Text("The Future of Navigation"),
           ),
         ),
       );
     }
 }