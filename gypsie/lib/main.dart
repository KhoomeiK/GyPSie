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
   var _isLoading = false;

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
                  _isLoading = false;
               })
             ]
           ),
           body: new Center(
             child: _isLoading ?  new CircularProgressIndicator() : 
              new ListView.builder(
                itemCount: 2,
                itemBuilder: (context, i) {
                  return new TextField(
                   decoration: new InputDecoration(
                    border: InputBorder.none,
                     hintText: 'Please enter a search term'
                      )
                  ); 
                }
              )
           )
         )
       );
     }
 }