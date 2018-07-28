import 'package:flutter/material.dart';
import 'algorithm.dart';
import 'main_page2.dart';
import 'main_page.dart';
import 'globals.dart' as globals;
import 'bluetooth_page.dart';

class TutorialPage extends StatefulWidget {
  State createState() => new TutorialPageState();
}

class TutorialPageState extends State<TutorialPage> {
  double _value = 0.0;
  int index = 0;
  dynamic _borderRadius = new BorderRadius.circular(10.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Padding(
            child: new Text("Tutorial",
                style: new TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: "Rajdhani",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0)),
            padding: const EdgeInsets.only(left: 0.0)),
        actions: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(Icons.account_box),
              )),
              SizedBox(width: 17.0),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: new Column(children: <Widget>[
          SizedBox(height: 170.0),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset('assets/left_turn.png',
                  fit: BoxFit.cover, scale: 8.0),
              SizedBox(width: 120.0),
              new Image.asset('assets/right_turn.png',
                  fit: BoxFit.cover, scale: 8.0),
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
                child: Text("Left",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Rajdhani",
                        color: Colors.white,
                        fontSize: 20.0)),
                shape: RoundedRectangleBorder(borderRadius: _borderRadius),
                onPressed: () {
                  // globals.globalDevice.transmit(200, 0);
                  globals.globalDevice.transmitTestLeft();

                },
                color: Colors.lightBlue,
                splashColor: Colors.blue,
              ),
              SizedBox(width: 80.0),
              new RaisedButton(
                padding: EdgeInsets.all(20.0),
                elevation: 8.0,
                child: Text("Right",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Rajdhani",
                        color: Colors.white,
                        fontSize: 20.0)),
                shape: RoundedRectangleBorder(borderRadius: _borderRadius),
                onPressed: () {
                  // globals.globalDevice.transmit(200, 1);
                  globals.globalDevice.transmitTestRight();
                  },
                color: Colors.lightBlue,
                splashColor: Colors.blue,
              )
            ],
          ),
        ]),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // void _onChanged(double value) {
  //   setState(() {
  //     _value = value;
  //   });
  // }

    Widget _buildBottomNav() {
    return new BottomNavigationBar(
      onTap: (index) {
        this.index = index;
        if (index == 0) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainPage2()));
        }
        if (index == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        }
        if (index == 2) {
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => BluetoothPage())
          );
        }
      },
      items: <BottomNavigationBarItem>[
        new BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          title: new Text("Home"),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.navigation),
          title:
              new Text("Navigation"),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.bluetooth),
          title: new Text("Bluetooth"),
        ),
      ],
    );
  }
}
