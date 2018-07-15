import 'dart:math' as Math;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:vibrate/vibrate.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'main_page.dart';
import 'globals.dart' as globals;

class Algorithm {
  String link; // api link
  var resp, legs, steps; // navigation directions
  FlutterBlue  blue = FlutterBlue.instance;
  List<BlueInfo> devices = [];
  StreamSubscription<ScanResult> scanSubscription; 
  StreamSubscription<BluetoothDeviceState> deviceConnection;
  BluetoothDevice mainBand;
  BluetoothCharacteristic char;
  String _bTState = 'disconnected';

  Algorithm() { // constructor
    link = "";
    resp = null;
    legs = null;
    steps = null;
  }

  scan() { // connect to bluetooth device
    print("scanning to start");
    scanSubscription = blue.scan().listen((scanResult){
      BlueInfo d = new BlueInfo(scanResult.device.name, scanResult.device.id.toString());

      if (globals.devices.indexOf(d)==-1)
        globals.devices.add(d);
    });
  }

  connect(BluetoothDevice band) async {
    print("connect to start");
    deviceConnection = blue.connect(band).listen((s) { // stream connection to device
      if(s == BluetoothDeviceState.connected) { // if connected
        scanSubscription.cancel(); // end scan once found device 
        globals.isConnected = true;
        mainBand = band;
        listServ();
      }
    });
  }

  listServ() async {
    print("listServ");
    List<BluetoothService> services = await mainBand.discoverServices();
    char = services[0].characteristics[0];
    print("service/characteristic info");
    for(var i = 0; i < services.length-1; i++) { // ble has 1 service with 2 characteristics
      print(services[i]);
      print(services[i].characteristics);
      print(services[i].characteristics[0]);
    }
    // transmit(5);
  }

  transmit(num x) async {
    print("transmit");

    // print(char.descriptors);
    // for (BluetoothDescriptor d in char.descriptors)
    //   print(await band.readDescriptor(d));
    // await band.writeDescriptor(char.descriptors[0], [1,1,1,1]);
    // print(await band.readDescriptor(char.descriptors[0]));

    print(mainBand.name);
    List<BluetoothService> services = await mainBand.discoverServices();
    List<BluetoothCharacteristic> characteristics = services[0].characteristics;
      List<int> value = await mainBand.readCharacteristic(characteristics[3]);
      print(value);
      await mainBand.writeCharacteristic(characteristics[3], [0x12]);
    
    

    // List<int> value = await band.readCharacteristic(char);
    // print("value og");
    // print(value);

    // await band.writeCharacteristic(char, [5 * x]); // error 

    // value = await band.readCharacteristic(char);
    // print("value new");
    // print(value);
  }

  disconnect() async {
    deviceConnection.cancel();
    globals.isConnected==false;
  }

  setPoints(String origin, String dest) async { // receives origin and destination from textbox and 
    globals.canceled = false;
    globals.dest = dest;

    if (origin.trim().toUpperCase() == "CURRENT LOCATION") { // uses current location as origin
      var loc = await getLoc();
      origin = loc["latitude"].toString() + "," + loc["longitude"].toString();
    }

    link = "https://maps.googleapis.com/maps/api/directions/json?origin=" + origin 
      + "&destination=" + dest
      + "&key=AIzaSyD0zb7Xdwk0FH-TOVbYkCTjSQargAwjb84";
    link = Uri.encodeFull(link.replaceAll(" ", "_")); // creates link
    
    await getData(); // sets json from api request
    legs = resp["routes"][0]["legs"][0]; // legs element of json
    steps = legs["steps"]; // steps element of legs
    // print(legs); // prints legs element to screen
    Vibrate.vibrate(); // vibrates as soon as Go button clicked

    for(int i = 0; i < steps.length; i++) {
      globals.markers.add(new Marker(
        i.toString(), "Waypoint", steps[i]["start_location"]["lat"], steps[i]["start_location"]["lng"], color: Colors.cyan
      ));

      if (i == steps.length - 1)
        globals.markers.add(new Marker(
          i.toString(), dest, steps[i]["end_location"]["lat"], steps[i]["end_location"]["lng"], color: Colors.red
        ));
    }

    loop();
  }

  loop() async {
    for (var step in steps) { // prints maneuver for each step
      print(step["maneuver"]);
      print(step["html_instructions"]);
    }
    
    print(await getLoc());
    print(await dist(legs["end_location"]["lat"], legs["end_location"]["lng"]));

    // convert below to event listener
    int i = 0; // current step that user is on
    // var x = dist(legs["end_location"]["lat"], legs["end_location"]["lng"]);

    while(await dist(legs["end_location"]["lat"], legs["end_location"]["lng"]) > 15) { // while not arrived at final destination
      globals.next = steps[i]["html_instructions"];
      num dis = await dist(steps[i]["end_location"]["lat"], steps[i]["end_location"]["lng"]); // distance between cur and next waypoint
      print(dis);
      if (globals.canceled){
        globals.markers.clear();
        return "You have canceled your trip";}

      if (dis <= 200 && dis >= 10) { // if within 200m of waypoint
        transmit(dis);
      }
      else if (dis < 10) { // once past the waypoint
        while (await dist(steps[i]["end_location"]["lat"], steps[i]["end_location"]["lng"]) < 10) {
          transmit(0);
        }
        i++; // go to next step 
      }
      sleep(const Duration(seconds:3)); // sleeps for 3 seconds between loop
    }

    return "You have arrived at your destination"; // once dist < 15, arrived at destination
  }

  getData() async {
    resp = await http.get(link); // gets from api
    resp = json.decode(resp.body); // parses json
  }

  getLoc() async { // gets current location
    return await loc.Location().getLocation;
  }

  toRadians(deg) { // convert degree to radians for dist function
    return deg * Math.pi / 180;
  }

  dist(lat2, lon2) async { // calculates distance between current location and given point as crow flies
    var cur = await getLoc(); // gets current location

    var lat1 = cur["latitude"]; // lat
    var lon1 = cur["longitude"]; // lon

    var R = 6371e3; // radius of earth
    var la1 = toRadians(lat1); // some math shit
    var la2 = toRadians(lat2);
    var ladif = toRadians(lat2-lat1);
    var lodif = toRadians(lon2-lon1);

    var a = Math.sin(ladif/2) * Math.sin(ladif/2) +
            Math.cos(la1) * Math.cos(la2) *
            Math.sin(lodif/2) * Math.sin(lodif/2); // more math shit

    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); // even more math shit

    var d = R * c; // what we want

    return d; // distance between (lat1, lon1) (current location) and (lat2, lon2) (given point)
  }
}