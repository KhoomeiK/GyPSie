import 'package:flutter/material.dart';
import 'algorithm.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:map_view/map_view.dart';
import 'main_page2.dart';
import 'settings_page.dart';


class HapticPage extends StatefulWidget {
  State createState() => new HapticPageState();
}


class HapticPageState extends State<HapticPage>{ 
double _value = 0.0;
int index = 0;

    @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Padding (child:new Text("Haptic Patterns", style: new TextStyle(fontWeight: FontWeight.normal, fontFamily: "Rajdhani", fontStyle: FontStyle.normal, fontSize: 20.0)),

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
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          new Text("Under Construction!", style: new TextStyle(fontWeight: FontWeight.normal, fontFamily: "Rajdhani", fontStyle: FontStyle.normal, fontSize: 20.0)),
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