import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'main_page2.dart';
import 'settings_page.dart';
import 'globals.dart' as globals;
import 'vibLevel_page.dart';
import 'haptic_page.dart';
import 'tutorial.dart';

class BluetoothPage extends StatefulWidget {
  State createState() => new BluetoothPageState();
}

class BluetoothPageState extends State<BluetoothPage> {
  int index = 0;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  // dynamic _borderRadius = new BorderRadius.circular(10.0);
  String origin1;
  String destination;
  int upToDate = 0;
  List<globals.BlueInfo> devices = globals.devices;
  var _mapView = new MapView();
  MainPage2State lol;
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  update() async {
    await globals.globalDevice.scan();
    print(globals.devices);
    return globals.devices;
    // await new Future.delayed(new Duration(seconds: 3));
  }

  void _showSnackBar() {
    if (globals.isConnected == true) {
      _scaffoldstate.currentState.showSnackBar(new SnackBar(
        content: new Text("Connected!"),
      ));
    }
  }

  _connect(globals.BlueInfo device) {
    globals.globalDevice.connect(device.toDevice());
  }

  _disconnect() {
    globals.globalDevice.disconnect();
  }

  Widget _buildBottomNav() {
    return new BottomNavigationBar(
      currentIndex: 1,
      onTap: (index) {
        this.index = index;
        if (index == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainPage2()));
        }
      },
      items: <BottomNavigationBarItem>[
        new BottomNavigationBarItem(
          icon: new Icon(Icons.access_time),
          title: new Text("Recents"),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.accessibility),
          title:
              new Text("Device", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.account_box),
          title: new Text("Profile"),
        )
      ],
    );
  }

  void showMap() {
    _mapView.show(new MapOptions(showUserLocation: true));
  }

  @override
  initState() {
    super.initState();
    update();
  }

  // Widget createListView(BuildContext context, AsyncSnapshot snapshot, ) {
  //   if (_globals.globalDevice.getIconState()=='connected'){
  //   return new PopupMenuButton<BlueInfo>(
  //               icon: Icon(Icons.bluetooth_connected),
  //               elevation: 3.2,
  //               initialValue: devices[0],
  //               onSelected: _connect,
  //               itemBuilder: (BuildContext context) {
  //                 return devices.map((BlueInfo b) {
  //                   return new PopupMenuItem<BlueInfo>(
  //                     value: b,
  //                     child: new Text(b.title)
  //                   );
  //                 }).toList();
  //             });
  //   }if (_globals.globalDevice.getIconState()=='disconnected'){
  //   return new PopupMenuButton<BlueInfo>(
  //               icon: Icon(Icons.bluetooth),
  //               elevation: 3.2,
  //               initialValue: devices[0],
  //               onSelected: _connect,
  //               itemBuilder: (BuildContext context) {
  //                 return devices.map((BlueInfo b) {
  //                   return new PopupMenuItem<BlueInfo>(
  //                     value: b,
  //                     child: new Text(b.title)
  //                   );
  //                 }).toList();
  //             });
  //   }
  //   else{
  //   return new PopupMenuButton<BlueInfo>(
  //               icon: Icon(Icons.bluetooth_searching),
  //               elevation: 3.2,
  //               initialValue: devices[0],
  //               onSelected: _connect,
  //               itemBuilder: (BuildContext context) {
  //                 return devices.map((BlueInfo b) {
  //                   return new PopupMenuItem<BlueInfo>(
  //                     value: b,
  //                     child: new Text(b.title)
  //                   );
  //                 }).toList();
  //             });
  //   }
  // }

  // Widget _buildButton2() {
  //   return RaisedButton(
  //     padding: EdgeInsets.all(20.0),
  //     elevation: 8.0,
  //     child: Text("Disconnect", style: TextStyle(color: Colors.white, fontSize: 20.0)),
  //     shape: RoundedRectangleBorder(borderRadius: _borderRadius),
  //     onPressed: (){
  //       _disconnect();
  //     },
  //     color: Colors.lightBlue,
  //     splashColor: Colors.blue,
  //   );
  // }

  createListView(
    BuildContext context,
    AsyncSnapshot snapshot,
  ) {
    return new IconButton(
      icon: new Icon(Icons.refresh),
      onPressed: () {
        update();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BluetoothPage()));
      },
    );
  }

  _title(index) {
    if (globals.devices[index].title == "")
      return globals.devices[index].iD;
    else
      return globals.devices[index].title;
  }
// createView(BuildContext context, AsyncSnapshot snapshot ) {
//     devices = snapshot.data;
//   return new ListView.builder(
//         itemCount: devices.length,
//         itemBuilder: (BuildContext context, i){
//           return new Column(
//             children: <Widget>[
//           new ListTile(
//             title: new Text(_title(i)),
//             onTap: (){_connect(devices[i]);},
//           ),
//             ],
//           );
//         }

//       );
// }

  Widget _buildDrawer() {
    return Drawer(
        child: ListView(
      children: <Widget>[
        DrawerHeader(
          child: Row(
            children: <Widget>[
              Image.asset('assets/Logo.png', width: 70.0, height: 70.0),
              SizedBox(width: 25.0),
              Text("Hi, Ryan",
                  style: TextStyle(
                      fontFamily: "Rajdhani",
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
        ListTile(
            title: Text("Vibrational Levels",
                style: TextStyle(fontFamily: "Rajdhani")),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => VibPage()));
            }),
        ListTile(
            title: Text("Haptic Patterns",
                style: TextStyle(fontFamily: "Rajdhani")),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HapticPage()));
            }),
        ListTile(
            title: Text("Rerun Tutorial",
                style: TextStyle(fontFamily: "Rajdhani")),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TutorialPage()));
            }),
        ListTile(
            title: Text("Settings", style: TextStyle(fontFamily: "Rajdhani")),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            }),
        ListTile(title: Text("Help", style: TextStyle(fontFamily: "Rajdhani"))),
        ListTile(
            title: Text("About Us", style: TextStyle(fontFamily: "Rajdhani"))),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    //showMap();
    // SystemChrome.setPreferredOrientations([
    // DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown
    // ]);
    return new Scaffold(
      key: _scaffoldstate,
      appBar: AppBar(
        title: new Padding(
            child: new Text("Bluetooth",
                style: new TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: "Rajdhani",
                    fontStyle: FontStyle.normal,
                    fontSize: 25.0)),
            padding: const EdgeInsets.only(left: 0.0)),
        actions: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(Icons.battery_full),
              )),
          SizedBox(width: 9.0),
          new Icon(Icons.bluetooth),
          SizedBox(width: 17.0),
          new FutureBuilder(
              future: update(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return new Icon(Icons.bluetooth_searching);
                  default:
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    else
                      return createListView(context, snapshot);
                }
              }),
        ],
      ),
      body: new FutureBuilder(
          future: update(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return new Text("lol");
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else
                  return Container(
                    child: ListView.builder(
                      itemCount: globals.devices.length,
                      itemBuilder: (BuildContext context, i) {
                        return new Column(
                          children: <Widget>[
                            new ListTile(
                                title: new Text(_title(i)),
                                onTap: () {
                                  print(globals.devices[i]);
                                  _connect(globals.devices[i]);
                                  _showSnackBar();
                                }),
                          ],
                        );
                      },
                    ),
                  );
            }
          }),
      drawer: _buildDrawer(),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.bluetooth_disabled),
          onPressed: () {
            globals.globalDevice.disconnect();
            __showSnackBar(); //replace lol with connection state         }
          }),
    );
  }

  void __showSnackBar() {
    _scaffoldstate.currentState.showSnackBar(new SnackBar(
      content: new Text("Disconnected!"),
    ));
  }

  Widget _finalList() {}
}
