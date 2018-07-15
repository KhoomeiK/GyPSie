import 'package:flutter/material.dart';
import 'algorithm.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:map_view/map_view.dart';
import 'main_page2.dart';
import 'settings_page.dart';
import 'bluetooth_page.dart';
import 'globals.dart' as globals;


class TutorialPage extends StatefulWidget {
  State createState() => new TutorialPageState();
}


class TutorialPageState extends State<TutorialPage>{ 
double _value = 0.0;
int index = 0;
dynamic _borderRadius = new BorderRadius.circular(10.0);
Algorithm a = new Algorithm();

    @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Padding (child:new Text("Tutorial", style: new TextStyle(fontWeight: FontWeight.normal, fontFamily: "Rajdhani", fontStyle: FontStyle.normal, fontSize: 20.0)),

        padding:const EdgeInsets.only(left: 0.0) ),
        actions: <Widget>[

          Container(
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(Icons.battery_full),
            )
          ),          
          SizedBox(width: 9.0),
          new Icon(Icons.bluetooth),
          SizedBox(width: 17.0),
          
        ],
      ),
      body:
      Container(
        padding: EdgeInsets.all(20.0),
          child: new Column(
            children: <Widget>[
            SizedBox(height: 170.0),
            new Row(
           crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              new Image.asset('assets/left_turn.png', fit: BoxFit.cover, scale: 8.0),
              SizedBox(width: 120.0),
              new Image.asset('assets/right_turn.png', fit: BoxFit.cover, scale: 8.0),
              ],
            ),
            SizedBox(height: 40.0),
            new Row( 
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              new RaisedButton(
                padding: EdgeInsets.all(20.0),
                elevation: 8.0,
                 child: Text("Left", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Rajdhani", color: Colors.white, fontSize: 20.0)),
                  shape: RoundedRectangleBorder(borderRadius: _borderRadius),
                   onPressed: (){ 
                    globals.globalDevice.transmit(2);
                     },
                   color: Colors.lightBlue,
                    splashColor: Colors.blue,
              ),
              SizedBox(width: 80.0),
              new RaisedButton(
                padding: EdgeInsets.all(20.0),
                elevation: 8.0,
                 child: Text("Right", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Rajdhani", color: Colors.white, fontSize: 20.0)),
                  shape: RoundedRectangleBorder(borderRadius: _borderRadius),
                   onPressed: (){ 
                    //rohan put ur shit here
                     },
                   color: Colors.lightBlue,
                    splashColor: Colors.blue,
              )
              ],
            ),
              ]
            ),
          ),
      

      bottomNavigationBar:
      _buildBottomNav(),
            
    );  
}
 void _onChanged(double value){
   setState(() {
        _value = value;
      });
 }

 Widget _buildBottomNav(){
    return new BottomNavigationBar(
      currentIndex: 1,
      onTap: (index) {
        this.index = index;
            if (index ==1)
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage2()));
            }
      },
      items: <BottomNavigationBarItem>[
        new BottomNavigationBarItem(
          icon: new Icon(Icons.access_time),
          title: new Text("Recents"),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.accessibility),
          title: new Text("Device", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.account_box),
          title: new Text("Profile"),
        )
      ],
       
    );
    
  }

}