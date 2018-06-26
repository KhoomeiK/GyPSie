import 'dart:math' as Math;
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vibrate/vibrate.dart';
import 'package:location/location.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';

import 'main_page.dart';

class Algorithm {
  String link; // api link
  var resp, legs, steps; // navigation directions
  FlutterBlue blue;
  List<BlueInfo> devices = [BlueInfo("Bluetooth Devices", "iD")];
  StreamSubscription<ScanResult> scanSubscription; 
  StreamSubscription<BluetoothDeviceState> deviceConnection;
  BluetoothDevice band;

  Algorithm(){ // constructor
    link = "";
    resp = null;
    legs = null;
    steps = null;
    blue = FlutterBlue.instance;
  }

  scan() async { // connect to bluetooth devicer
    scanSubscription = blue.scan().listen((scanResult){
    BlueInfo d = new BlueInfo(scanResult.device.name, scanResult.device.id.toString());
    if (d != null && devices.indexOf(d) == -1) // issue is either with indexOf()
      devices.add(d);
    });
  }

  connect(BluetoothDevice band) async {
    print("connect trying");
    deviceConnection = blue.connect(band).listen((s) { // stream connection to device
      print(s);
      if(s == BluetoothDeviceState.connected) { // if connected
        scanSubscription.cancel(); // end scan once found device 
        this.band = band;
        findServ();
      }
    });
  }

  findServ() async {
    List<BluetoothService> services = await band.discoverServices();
    for(var i = 0; i < services.length-1; i++) {
      print(services[i]);
      transmit(services[i], i);
    }
  }

  transmit(BluetoothService s, int x) async {
    var characteristics = s.characteristics;
    for(BluetoothCharacteristic c in characteristics) {
      List<int> value = await band.readCharacteristic(c);
      print(value);
      await band.writeCharacteristic(c, [x]);
    }
    // Writes to a characteristic
  }

  disconnect() async {
    deviceConnection.cancel();
  }

  setPoints(origin, dest) async { // receives origin and destination from textbox and 
    if (origin == "Current Location") { // uses current location as origin
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
    print(legs); // prints legs element to screen
    Vibrate.vibrate(); // vibrates as soon as Go button clicked

    // scan();
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
      var dis = await dist(steps[i]["end_location"]["lat"], steps[i]["end_location"]["lng"]); // distance between cur and next waypoint
      print(dis);
      if (dis <= 200 && dis >= 10) { // if within 200m of waypoint
        vib(dis);
        Vibrate.vibrate();
      }
      else if (dis < 10) { // once past the waypoint
        while (await dist(steps[i]["end_location"]["lat"], steps[i]["end_location"]["lng"]) < 10) {
          Vibrate.vibrate();
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
    return await Location().getLocation;
  }

  vib(d) {
    d = 100/d; // number of times to vibrate per second
    // deviceConnection write d to bluetooth stream
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