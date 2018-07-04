import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'globals.dart' as globals;

var api_key = "AIzaSyDrHKl8IxB4cGXIoELXQOzzZwiH1xtsRf4";
void main() {
  MapView.setApiKey(api_key);
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MapsPage(),
  ));
}

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => new _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  MapView mapView = new MapView();
  CameraPosition cameraPosition;
  var staticMapProvider = new StaticMapProvider(api_key);
  Uri staticMapUri;
  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();

  // List<Marker> markers = <Marker>[
  //   new Marker("1", "BSR Restuarant", 28.421364, 77.333804,
  //       color: Colors.amber),
  // ];

  // _getMarkers(){
  //   new Marker("2", "Flutter Institute", 28.418684, 77.340417,
  //       color: Colors.purple);
  // }

  showMap() {
    mapView.show(new MapOptions(
        mapViewType: MapViewType.normal,
        initialCameraPosition:
            new CameraPosition(new Location(37.7749, -122.4194), 15.0),
        showUserLocation: true,
        title: "to "+ globals.dest),
        toolbarActions: [ new ToolbarAction("End Route", 2)],
        );
    mapView.setMarkers(globals.markers);
    mapView.zoomToFit(padding: 100);

    mapView.onToolbarAction.listen((identifier) {
      switch (identifier) {
        case 2:
          globals.canceled=true;
          mapView.dismiss();
          _showSnackBar();
          break;
      }
    });

    mapView.onMapTapped.listen((_) {
      setState(() {
        mapView.setMarkers(globals.markers);
        mapView.zoomToFit(padding: 100);
      }

      
      );
    });
  }

  void _showSnackBar(){
 if (globals.isConnected==true){
  _scaffoldstate.currentState.showSnackBar(new SnackBar(
    content:new Text("Connected!"),
  ));
   }

}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cameraPosition =
        new CameraPosition(new Location(37.7749, -122.4194), 2.0);
    staticMapUri = staticMapProvider.getStaticUri(
        new Location(37.7749, -122.4194), 12,
        height: 1300, width: 900, mapType: StaticMapViewType.roadmap);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Pulse Directions"),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            height: 564.0,
            child: new Stack(
              children: <Widget>[
                new Center(
                  child: Container(
                    child: new Text(
                      "Map should show here",
                      textAlign: TextAlign.center,
                    ),
                    padding: const EdgeInsets.all(20.0),
                  ),
                ),
                new InkWell(
                  child: new Center(
                    child: new Image.network(staticMapUri.toString()),
                  ),
                  onTap: showMap,
                )
              ],
            ),
          ),
          new Container(
            padding: new EdgeInsets.only(top: 10.0),
            child: new Text(
              "TAP THE MAP TO VIEW WAYPOINTS",
              style: new TextStyle(fontFamily: "Rajdhani", fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}