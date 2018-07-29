import 'dart:math' as Math;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'main_page.dart';
import 'package:http/http.dart' as http;
import 'package:vibrate/vibrate.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';

import 'globals.dart' as globals;

class Algorithm {
  String link; // api link
  var resp, legs, steps; // navigation directions
  FlutterBlue blue = FlutterBlue.instance;
  StreamSubscription<ScanResult> scanSubscription;
  StreamSubscription<BluetoothDeviceState> deviceConnection;
  BluetoothDevice mainBand;
  int i = 0;
  bool repeating = false;
  bool stillThere = false;
  List<BlueInfo> locald = [];

  Algorithm() {
    // constructor
    link = "";
    resp = null;
    legs = null;
    steps = null;
  }

  scan() {
    {
      // connect to bluetooth device
      print("scanning to start");
      // remove();
      scanSubscription = blue.scan().listen((scanResult) {
        // do something with scan result
        BlueInfo d = new BlueInfo(
            scanResult.device.name, scanResult.device.id.toString());
        locald.add(d);
        for (int i = 0; i < globals.devices.length; i++) {
          if (d.iD == globals.devices[i].iD) repeating = true;
        }
        if (repeating == false) {
          globals.devices.add(d);
        } else if (repeating = true) repeating = false;

        print(globals.devices);
        print(locald);
      });
    }
  }

  remove() {
    for (int k = globals.devices.length; k > 0; k--) {
      for (int j = 0; j < locald.length; j++) {
        if (globals.devices[k - 1].iD == locald[j].iD) stillThere = true;
      }
      if (stillThere == false) {
        globals.devices.remove(globals.devices[k - 1]);
        print('k');
      }
      stillThere = false;
    }
    for (int i = locald.length - 1; i >= 0; i--) {
      locald.remove(locald[i]);
    }
  }

  connect(BluetoothDevice band) async {
    print("connect to start");
    deviceConnection = blue.connect(band).listen((s) {
      // stream connection to device
      if (s == BluetoothDeviceState.connected) {
        // if connected// end scan once found device

        scanSubscription.cancel();
        globals.isConnected = true;
        mainBand = band;
        globals.devices.clear();
        listServ(); // list device's services
      }
    });
  }

  listServ() async {
    // for testing to view services
    print("listServ");
    List<BluetoothService> services =
        await mainBand.discoverServices(); // writes available services
    print("service/characteristic info");
    for (var i = 0; i < services.length - 1; i++) {
      print(services[i]);
      print(services[i].characteristics);
      print(services[i].characteristics[0]);
    }
  }

  transmitTestLeft() async {
    List<BluetoothService> services =
        await mainBand.discoverServices(); // available services
    List<BluetoothCharacteristic> characteristics =
        services[1].characteristics; // chars for service 1

    List<int> value = await mainBand
        .readCharacteristic(characteristics[0]); // read serv1 char0
    print(value);

    await mainBand
        .writeCharacteristic(characteristics[0], [0]); // write to serv1 char0
  }

  transmitTestRight() async {
    List<BluetoothService> services =
        await mainBand.discoverServices(); // available services
    List<BluetoothCharacteristic> characteristics =
        services[1].characteristics; // chars for service 1

    List<int> value = await mainBand
        .readCharacteristic(characteristics[0]); // read serv1 char0
    print(value);

    await mainBand
        .writeCharacteristic(characteristics[0], [100]); // write to serv1 char0
  }

  transmit(num dis, int i) async {
    print("transmit to ${mainBand.name}");

    print("BLUETOOTH READ-----------------------------------------");

    List<BluetoothService> services =
        await mainBand.discoverServices(); // available services
    List<BluetoothCharacteristic> characteristics =
        services[1].characteristics; // chars for service 1

    List<int> value = await mainBand
        .readCharacteristic(characteristics[0]); // read serv1 char0
    print(value);

    print("WHICH SIDE-----------------------------------------");
    int val = 0;
    String side = "";
    side = determineSide(i);
    print(side);
    if (side == "right") {
      if (dis > 200) val = 51;
      if (dis <= 200 && dis >= 160)
        val = 104;
      else if (dis <= 159 && dis >= 120)
        val = 103;
      else if (dis <= 119 && dis >= 80)
        val = 102;
      else if (dis <= 79 && dis >= 40)
        val = 101;
      else if (dis <= 39 && dis >= 10)
        val = 100;
      else if (dis < 10) val = 18;
    } // write to serv1 char0
    else if (side == "left") {
      if (dis > 200) val = 15;
      if (dis <= 200 && dis >= 160)
        val = 4;
      else if (dis <= 159 && dis >= 120)
        val = 3;
      else if (dis <= 119 && dis >= 80)
        val = 2;
      else if (dis <= 79 && dis >= 40)
        val = 1;
      else if (dis <= 39 && dis >= 10)
        val = 0;
      else if (dis < 10) val = 17;
    } else {
      val = 15;
    }

    print("value: $val");

    print("BLUETOOTH WRITE-----------------------------------------");
    await mainBand
        .writeCharacteristic(characteristics[0], [val]); // write to serv1 char0
    print("wrote characteristic val");
    value = await mainBand
        .readCharacteristic(characteristics[0]); // read new serv1 char0
    print(value);
  }

  disconnect() async {
    deviceConnection.cancel(); // end device BT connection
    globals.isConnected = false;
  }

  getData() async {
    resp = await http.get(link); // gets from api
    resp = json.decode(resp.body); // parses json
  }

  getLoc() async {
    // gets current location
    return await loc.Location().getLocation;
  }

  toRadians(deg) {
    // convert degree to radians for dist function
    return deg * Math.pi / 180;
  }

  // convert below to stream
  dist(lat2, lon2) async {
    // calculates distance between current location and given point as crow flies
    var cur = await getLoc(); // gets current location

    var lat1 = cur["latitude"]; // lat
    var lon1 = cur["longitude"]; // lon

    var R = 6371e3; // radius of earth
    var la1 = toRadians(lat1); // some math shit
    var la2 = toRadians(lat2);
    var ladif = toRadians(lat2 - lat1);
    var lodif = toRadians(lon2 - lon1);

    var a = Math.sin(ladif / 2) * Math.sin(ladif / 2) +
        Math.cos(la1) *
            Math.cos(la2) *
            Math.sin(lodif / 2) *
            Math.sin(lodif / 2); // more math shit

    var c =
        2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a)); // even more math shit

    var d = R * c; // what we want

    return d; // distance between (lat1, lon1) (current location) and (lat2, lon2) (given point)
  }

  determineSide(int i) {
    print("determining side");
    String side = "";
    if (steps[i]["maneuver"].toString().indexOf("left") != -1)
      side = "left";
    else if (steps[i]["maneuver"].toString().indexOf("right") != -1)
      side = "right";
    else {
      if (steps[i]["html_instructions"].toString().indexOf("left") != -1)
        side = "left";
      else if (steps[i]["html_instructions"].toString().indexOf("right") != -1)
        side = "right";
      else {
        print(
            "Could not determine whether to turn right or left"); // change eventually
        Vibrate.vibrate();
      }
    }
    return side;
  }

  setPoints(String origin, String dest) async {
    // receives origin and destination from textbox and
    globals.canceled = false;
    globals.dest = dest;

    if (origin.trim().toUpperCase() == "CURRENT LOCATION") {
      // uses current location as origin
      var loc = await getLoc();
      origin = loc["latitude"].toString() + "," + loc["longitude"].toString();
    }

    link = "https://maps.googleapis.com/maps/api/directions/json?origin=" +
        origin +
        "&destination=" +
        dest +
        "&travelMode=" +
        globals.travelMode +
        "&key=AIzaSyD0zb7Xdwk0FH-TOVbYkCTjSQargAwjb84"; // travelMode = BICYCLING for bikers, = DRIVING for motorbikers
    link = Uri.encodeFull(link.replaceAll(" ", "_")); // creates link

    await getData(); // sets json from api request
    legs = resp["routes"][0]["legs"][0]; // legs element of json
    steps = legs["steps"]; // steps element of legs
    Vibrate.vibrate(); // vibrates as soon as Go button clicked

    for (int i = 0; i < steps.length; i++) {
      // add markers for each waypoint up to destination
      if (i == 0)
        globals.markers.add(new Marker(i.toString(), dest,
            steps[i]["end_location"]["lat"], steps[i]["end_location"]["lng"],
            color: Colors.green));
      else if (i == steps.length - 1)
        globals.markers.add(new Marker(i.toString(), dest,
            steps[i]["end_location"]["lat"], steps[i]["end_location"]["lng"],
            color: Colors.red));
      else
        globals.markers.add(new Marker(i.toString(), "Waypoint",
            steps[i]["start_location"]["lat"], steps[i]["start_location"]["lng"],
            color: Colors.cyan));
    }
    loop();
  }

  loop() async {
    print(steps);
    for (var step in steps) {
      // prints maneuver for each step
      print(step["maneuver"]);
      print(step["html_instructions"]);
    }

    print(await getLoc());
    print(await dist(legs["end_location"]["lat"], legs["end_location"]["lng"]));

    int i = 1; // current step that user is on

    // convert below to event listener
    print("starting while");
    while (
        await dist(legs["end_location"]["lat"], legs["end_location"]["lng"]) >
            30) {
      // while not arrived at final destination
      print(await dist(legs["end_location"]["lat"],
          legs["end_location"]["lng"])); // distance to final destination

      globals.next = steps[i]["html_instructions"]; // next step
      print(globals.next);
      num dis = await dist(
          steps[i]["start_location"]["lat"],
          steps[i]["start_location"]
              ["lng"]); // distance between cur and next waypoint
      print(dis);

      if (globals.canceled) {
        globals.markers.clear();
        print("canceled");
        return "You have canceled your trip";
      }

      if (dis < 200) {
        print("transmit func start");
        await transmit(dis, i);
        print("transmit func fin");
        if (dis < 30) {
          i++; // go to next step
          if (i == steps.length) print('${steps[--i]["html_instructions"]}');
          transmit(205, i);
        }
      }
      print("step $i");
      sleep(const Duration(seconds: 1)); // sleeps for 3 seconds between loop
    }
    print("loop ended");
    return "You have arrived at your destination"; // once dist < 15, arrived at destination
  }
}
