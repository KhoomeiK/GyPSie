import 'algorithm.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'main_page2.dart';
import 'settings_page.dart';
import 'package:flutter/services.dart';
import 'maps_page.dart';
import 'globals.dart' as globals;
import 'vibLevel_page.dart';
import 'haptic_page.dart';
import 'tutorial.dart';


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
  Algorithm _backEnd = new Algorithm();
  int index = 0;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  dynamic _borderRadius = new BorderRadius.circular(10.0);
  String origin1;
  String destination;
  int upToDate = 0;
  List<BlueInfo> devices = [];
  var _mapView = new MapView();
  bool _value = false;
  int pulse = 0;
  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();


void _showSnackBar(){
 if (globals.isConnected==true){
  _scaffoldstate.currentState.showSnackBar(new SnackBar(
    content:new Text("Please fill in required fields"),
  ));
   }
}

  _update() async {
    await _backEnd.scan();
    return globals.devices;
  }

  void _submit() {
   final form = formKey.currentState;
    if(form.validate()){
        form.save();
        if (pulse ==1)
        origin1 = "current location";
        _backEnd.setPoints(origin1, destination);
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
      child: Text("Go!", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Rajdhani", color: Colors.white, fontSize: 20.0)),
      shape: RoundedRectangleBorder(borderRadius: _borderRadius),
      onPressed: (){ 
        _submit();
        if ((pulse == 0 && origin1=='') || destination=="")
        _showSnackBar();
        else
        Navigator.push(context, MaterialPageRoute(builder: (context) => MapsPage()));
        },
      color: Colors.lightBlue,
      splashColor: Colors.blue,
    );
  }

  _onChanged(bool value){
    setState((){
    _value = value;
    });
  }

  Widget _buildSwitch(){
    return new SwitchListTile(
      value: _value,
      title: new Text("Use Current Location"),
      onChanged: (bool value){
        _onChanged(value); 
        if (value==true){
          pulse = 1;
        }
        else{
          pulse = 0;
        }
        },
    );
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

  void showMap() {
    _mapView.show(new MapOptions(showUserLocation: true));
}


  Widget _buildDrawer() {
    return Drawer(child:
      ListView(children: <Widget>[
        DrawerHeader(
          child: Row(
            children: <Widget>[
              Image.asset('assets/Logo.png', width: 70.0, height:70.0),
              SizedBox(width: 25.0),
              Text("Hi, Ryan", style: TextStyle(fontFamily: "Rajdhani", fontSize: 20.0, fontWeight: FontWeight.bold))
            ],
          ),
        ),
        ListTile(title: Text("Vibrational Levels", style: TextStyle(fontFamily: "Rajdhani")), onTap:() {Navigator.push(context, MaterialPageRoute(builder: (context) => VibPage()));}),
        ListTile(title: Text("Haptic Patterns", style: TextStyle(fontFamily: "Rajdhani")), onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => HapticPage()));}),
        ListTile(title: Text("Rerun Tutorial", style: TextStyle(fontFamily: "Rajdhani")), onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => TutorialPage()));}),
        ListTile(title: Text("Settings", style: TextStyle(fontFamily: "Rajdhani")), onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));}),
        ListTile(title: Text("Help", style: TextStyle(fontFamily: "Rajdhani"))),
        ListTile(title: Text("About Us", style: TextStyle(fontFamily: "Rajdhani"))),
      ],)
    );
  }


  @override
  Widget build(BuildContext context) {
    //showMap();
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  _update();
    return new Scaffold(
      key: _scaffoldstate,
      appBar: AppBar(
        title: new Padding (child:new Text("Navigation", style: new TextStyle(fontWeight: FontWeight.normal, fontFamily: "Rajdhani", fontStyle: FontStyle.normal, fontSize: 25.0)),

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
        child: Column(
          children: <Widget>[
            _buildForm(),
            SizedBox(height: 9.0),
            _buildSwitch(),
            SizedBox(height: 9.0),
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
      _buildBottomNav(),
            
    );  
}

}