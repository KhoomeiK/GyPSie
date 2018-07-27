import 'package:flutter/material.dart';
import 'algorithm.dart';
import 'package:map_view/map_view.dart';
import 'main_page.dart';
import 'settings_page.dart';
import 'bluetooth_page.dart';
import 'globals.dart' as globals;
import 'vibLevel_page.dart';
import 'haptic_page.dart';
import 'tutorial.dart';

class MainPage2 extends StatefulWidget {
  State createState() => new MainPage2State();
}

// class BlueInfo {
//   String title;
//   String iD;

//   BlueInfo(String titlee, String id) {
//     iD = id;
//     title = titlee;
//     if (title == "" || title == null)
//       title = iD;
//   }

//   @override
//   String toString() {
//     return title + ":" + iD.toString();
//   }

//   BluetoothDevice toDevice() {
//     return BluetoothDevice(name: this.title, id: DeviceIdentifier(this.iD), type: BluetoothDeviceType.unknown);
//   }
// }

class MainPage2State extends State<MainPage2> {
  int index = 0;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  dynamic _borderRadius = new BorderRadius.circular(10.0);
  String origin1;
  String destination;
  int upToDate = 0;
  List<BlueInfo> devices = [];
  var _mapView = new MapView();
  BluetoothPageState lolaz = new BluetoothPageState();

  _connect(BlueInfo device) {
    globals.globalDevice.connect(device.toDevice());
  }

  _disconnect() {
    globals.globalDevice.disconnect();
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      globals.globalDevice.setPoints(origin1, destination);
    }
  }

   Widget _buildBottomNav() {
    return new BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        this.index = index;
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

  void showMap() {
    _mapView.show(new MapOptions(showUserLocation: true));
  }

  // Widget createListView(
  //   BuildContext context,
  //   AsyncSnapshot snapshot,
  // ) {
  //   if (globals.isConnected == true) {
  //     return new PopupMenuButton<BlueInfo>(
  //         icon: Icon(Icons.bluetooth_connected),
  //         elevation: 3.2,
  //         initialValue: devices[0],
  //         onSelected: _connect,
  //         itemBuilder: (BuildContext context) {
  //           return devices.map((BlueInfo b) {
  //             return new PopupMenuItem<BlueInfo>(
  //                 value: b, child: new Text(b.title));
  //           }).toList();
  //         });
  //   }
  //   if (globals.isConnected == false) {
  //     return new PopupMenuButton<BlueInfo>(
  //         icon: Icon(Icons.bluetooth),
  //         elevation: 3.2,
  //         initialValue: devices[0],
  //         onSelected: _connect,
  //         itemBuilder: (BuildContext context) {
  //           return devices.map((BlueInfo b) {
  //             return new PopupMenuItem<BlueInfo>(
  //                 value: b, child: new Text(b.title));
  //           }).toList();
  //         });
  //   } else {
  //     return new PopupMenuButton<BlueInfo>(
  //         icon: Icon(Icons.bluetooth_searching),
  //         elevation: 3.2,
  //         initialValue: devices[0],
  //         onSelected: _connect,
  //         itemBuilder: (BuildContext context) {
  //           return devices.map((BlueInfo b) {
  //             return new PopupMenuItem<BlueInfo>(
  //                 value: b, child: new Text(b.title));
  //           }).toList();
  //         });
  //   }
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
            title: Text("Vibrational Levels"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => VibPage()));
            }),
        ListTile(
            title: Text("Haptic Patterns"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HapticPage()));
            }),
        ListTile(
            title: Text("Rerun Tutorial"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TutorialPage()));
            }),
        ListTile(
            title: Text("Settings"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            }),
        ListTile(title: Text("Help")),
        ListTile(title: Text("About Us")),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    //showMap();
    return new Scaffold(
      appBar: AppBar(
        title: new Padding(
            child: new Text("Device",
                style: TextStyle(
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
                child: Icon(Icons.account_box),
              )),

          SizedBox(width: 17.0),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0),
            Row(children: <Widget>[
              SizedBox(height: 25.0),
              new Expanded(
                child: _image(),
              ),
              new Expanded(
                child: _image2(),
              ),
              SizedBox(height: 25.0),
            ]),
            SizedBox(height: 30.0),
            new Text("Welcome, Ryan",
                style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Rajdhani",
                    fontStyle: FontStyle.normal,
                    fontSize: 25.0)),
            //  _bandName(),
            // SizedBox(height: 20.0),
            // new Text("Status: ON",
            //     style: new TextStyle(
            //         fontWeight: FontWeight.normal,
            //         fontFamily: "Rajdhani",
            //         fontStyle: FontStyle.normal,
            //         fontSize: 20.0)),
            SizedBox(height: 20.0),
            new Text(_connectionState(),
                style: new TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: "Rajdhani",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0)),

            _batterylevel(),
          ],
        ),

        // _buildButton2(),
      ),
      drawer: _buildDrawer(),
      bottomNavigationBar: _buildBottomNav(),
      // floatingActionButton: new FloatingActionButton(
      //     elevation: 0.0,
      //     child: new Icon(Icons.bluetooth),
      //     onPressed: () {
      //       Navigator.push(context,
      //           MaterialPageRoute(builder: (context) => BluetoothPage()));
      //     }),
    );
  }

  _connectionState() {
    if (globals.isConnected == true)
      return "Bluetooth: Connected";
    else
      return "Bluetooth: Disconnected";
  }

  _image() {
    return Image.asset('assets/download.png', fit: BoxFit.cover);
  }

  _image2() {
    return Image.asset('assets/download copy.png', fit: BoxFit.cover);
  }

  _batterylevel() {
    return Image.asset('assets/battery.png', fit: BoxFit.cover);
  }

}
