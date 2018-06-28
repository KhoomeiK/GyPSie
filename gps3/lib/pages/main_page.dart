import 'package:flutter/material.dart';
import 'algorithm.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:map_view/map_view.dart';

import 'settings_page.dart';


class MainPage extends StatefulWidget {
  State createState() => new MainPageState();
}

class BlueInfo {
  String title;
  String iD;
  
  BlueInfo(String titlee, String id) {
    iD = id;
    title = titlee;
    if (title == "" || title == null)
      title = iD;
  }

  @override
  String toString() {
    return title + ":" + iD.toString();
  }

  BluetoothDevice toDevice() {
    return BluetoothDevice(name: this.title, id: DeviceIdentifier(this.iD), type: BluetoothDeviceType.unknown);
  }
}

class MainPageState extends State<MainPage>{ 
  Algorithm backEnd = new Algorithm();
  int index = 0;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  dynamic _borderRadius = new BorderRadius.circular(10.0);
  String origin1;
  String destination;
  int upToDate = 0;
  List<BlueInfo> devices = [];
  var _mapView = new MapView();


  _update() async {
    await backEnd.scan();
    devices = backEnd.devices;
    print(backEnd.devices);
    return devices;
  }

  _connect(BlueInfo device){
    backEnd.connect(device.toDevice());
  }

  _disconnect() {
    backEnd.disconnect();
  }

  void _submit() {
   final form = formKey.currentState;
    if(form.validate()){
        form.save();
        backEnd.setPoints(origin1, destination);
      }
  }

  Widget _buildForm(){
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: new InputDecoration(labelText: "Origin", border: OutlineInputBorder(borderRadius: _borderRadius)),
            validator: (val) => (val == null) ? 'Empty' : null,
            onSaved: (val) => origin1 = val,
          ),
          SizedBox(height: 12.0),
          TextFormField(
            decoration: new InputDecoration(labelText: "Destination", border: OutlineInputBorder(borderRadius: _borderRadius)),
            validator: (val) => (val == null) ? 'Empty' : null,
            onSaved: (val) => destination = val,
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return RaisedButton(
      padding: EdgeInsets.all(20.0),
      elevation: 8.0,
      child: Text("Go!", style: TextStyle(color: Colors.white, fontSize: 20.0)),
      shape: RoundedRectangleBorder(borderRadius: _borderRadius),
      onPressed: (){ 
        _submit();
      },
      color: Colors.lightBlue,
      splashColor: Colors.blue,
    );
  }

  Widget _buildBottomNav(){
    return new BottomNavigationBar(
      currentIndex: index,
      onTap: (index) {
          setState(() {
            this.index = index;
          }
          );
      },
      items: <BottomNavigationBarItem>[
        new BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          title: new Text("Home"),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.bluetooth_disabled),
          title: new Text("Disconnect"),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.settings),
          title: new Text("Settings"),
        )
      ],
       
    );
    
  }

  void showMap() {
    _mapView.show(new MapOptions(showUserLocation: true));
}




  Widget createListView(BuildContext context, AsyncSnapshot snapshot, ) {
    if (backEnd.getIconState()=='connected'){
    return new PopupMenuButton<BlueInfo>(
                icon: Icon(Icons.bluetooth_connected),
                elevation: 3.2,
                initialValue: devices[0],
                onSelected: _connect,
                itemBuilder: (BuildContext context) {
                  return devices.map((BlueInfo b) {
                    return new PopupMenuItem<BlueInfo>(
                      value: b,
                      child: new Text(b.title)
                    ); 
                  }).toList();
              });
    }if (backEnd.getIconState()=='disconnected'){
    return new PopupMenuButton<BlueInfo>(
                icon: Icon(Icons.bluetooth),
                elevation: 3.2,
                initialValue: devices[0],
                onSelected: _connect,
                itemBuilder: (BuildContext context) {
                  return devices.map((BlueInfo b) {
                    return new PopupMenuItem<BlueInfo>(
                      value: b,
                      child: new Text(b.title)
                    ); 
                  }).toList();
              });
    }
    else{
    return new PopupMenuButton<BlueInfo>(
                icon: Icon(Icons.bluetooth_searching),
                elevation: 3.2,
                initialValue: devices[0],
                onSelected: _connect,
                itemBuilder: (BuildContext context) {
                  return devices.map((BlueInfo b) {
                    return new PopupMenuItem<BlueInfo>(
                      value: b,
                      child: new Text(b.title)
                    ); 
                  }).toList();
              });
    }
  }

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


  Widget _buildDrawer() {
    return Drawer(child:
      ListView(children: <Widget>[
        DrawerHeader(
          child: Row(
            children: <Widget>[
              Image.asset('/Users/ryanwang/Documents/GyPSie/gps3/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png'),
              SizedBox(width: 25.0),
              Text("Options", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400))
            ],
          ),
        ),
        ListTile(title: Text("Vibration Level"), onTap: () {}), 
        ListTile(title: Text("Haptic Patterns"), onTap: () {}),
        ListTile(title: Text("Rerun Tutorial"), onTap: () {}),
        ListTile(title: Text("Settings"), onTap: () {}),
        ListTile(title: Text("Help"), onTap: () {}),
        ListTile(title: Text("About Us"), onTap: (){
          //navigate to settings page
        }),
      ],)
    );
  }


  @override
  Widget build(BuildContext context) {
    print("App being built");
    //showMap();
    return new Scaffold(
      
      appBar: AppBar(
        title: new Padding (child: new Text ("Pulse"),
        padding:const EdgeInsets.only(left: 0.0) ),
        actions: <Widget>[

          Container(
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
            child: GestureDetector(
              onTap: () { },
              child: Icon(Icons.battery_full),
            )
          ),          

          new FutureBuilder(
          future: _update(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return new Text('loading...');
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else
                  return createListView(context, snapshot);
              }
            } 
          ),
        ],
      ),
      body:
      Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            _buildForm(),
            SizedBox(height: 25.0),
            _buildButton(),
            SizedBox(height: 25.0),
            
            // _buildButton2(),
            Flex(
              direction: Axis.vertical,
              children: <Widget>[
              ],
            )
          ],
        ),
      ),

      drawer: _buildDrawer(),
      bottomNavigationBar:
              FloatingActionButton(
                child: new Icon(Icons.account_circle),
               onPressed: () {},
             ),
      
    );  
}

}