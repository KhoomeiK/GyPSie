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

  Algorithm() {
    // constructor
    link = "";
    resp = null;
    legs = null;
    steps = null;
  }

  scan() {
    // connect to bluetooth device
    print("scanning to start");
    scanSubscription = blue.scan().listen((scanResult) {
      BlueInfo d =
          new BlueInfo(scanResult.device.name, scanResult.device.id.toString());
      // new blueinfo object for device
      if (globals.devices.indexOf(d) == -1)
        globals.devices.add(d); // only add new devices to list
    });
  }

  connect(BluetoothDevice band) async {
    print("connect to start");
    deviceConnection = blue.connect(band).listen((s) {
      // stream connection to device
      if (s == BluetoothDeviceState.connected) {
        // if connected
        scanSubscription.cancel(); // end scan once found device
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

  transmit(num x, int i) async {
    print("transmit");
    print(mainBand.name);

    print(steps[i]["maneuver"]);
    print(steps[i]["html_instructions"]);

    String side = "";
    var time = (5 * x) ~/ 100;

    if (steps[i]["maneuver"].toString().indexOf("left") != -1)
      side = "left";
    else if (steps[i]["maneuver"].toString().indexOf("right") != -1)
      side = "right";
    else {
      if (steps[i]["html_instructions"].toString().indexOf("left") != -1)
        side = "left";
      else if (steps[i]["html_instructions"].toString().indexOf("right") != -1)
        side = "right";
      else
        throw (new Exception([
          "Could not determine whether to turn right or left"
        ])); // change eventually
    }

    List<BluetoothService> services =
        await mainBand.discoverServices(); // available services
    List<BluetoothCharacteristic> characteristics =
        services[1].characteristics; // chars for service 1

    List<int> value = await mainBand
        .readCharacteristic(characteristics[0]); // read serv1 char0
    print(value);

    if (side == "right")
      await mainBand
          .writeCharacteristic(characteristics[0], [time]); // write to serv1 char0
    else if (side == "left")
      await mainBand.writeCharacteristic(
          characteristics[0], [time + 100]); // write to serv1 char0

    value = await mainBand
        .readCharacteristic(characteristics[0]); // read new serv1 char0
    print(value);
  }

  disconnect() async {
    deviceConnection.cancel(); // end device BT connection
    globals.isConnected = false;
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
        "&key=AIzaSyD0zb7Xdwk0FH-TOVbYkCTjSQargAwjb84";
    link = Uri.encodeFull(link.replaceAll(" ", "_")); // creates link

    await getData(); // sets json from api request
    legs = resp["routes"][0]["legs"][0]; // legs element of json
    steps = legs["steps"]; // steps element of legs
    Vibrate.vibrate(); // vibrates as soon as Go button clicked

    for (int i = 0; i < steps.length; i++) {
      // add markers for each waypoint up to destination
      globals.markers.add(new Marker(i.toString(), "Waypoint",
          steps[i]["start_location"]["lat"], steps[i]["start_location"]["lng"],
          color: Colors.cyan));

      if (i == steps.length - 1)
        globals.markers.add(new Marker(i.toString(), dest,
            steps[i]["end_location"]["lat"], steps[i]["end_location"]["lng"],
            color: Colors.red));
    }

    loop();
  }

  loop() async {
    // for (var step in steps) {
    //   // prints maneuver for each step
    //   print(step["maneuver"]);
    //   print(step["html_instructions"]);
    // }

    print(await getLoc());
    print(await dist(legs["end_location"]["lat"], legs["end_location"]["lng"]));

    int i = 0; // current step that user is on

    // var x = dist(legs["end_location"]["lat"], legs["end_location"]["lng"]);
    // convert below to event listener
    while (
        await dist(legs["end_location"]["lat"], legs["end_location"]["lng"]) >
            15) {
      // while not arrived at final destination
      globals.next = steps[i]["html_instructions"]; // next step
      num dis = await dist(
          steps[i]["end_location"]["lat"],
          steps[i]["end_location"]
              ["lng"]); // distance between cur and next waypoint
      print(dis);

      if (globals.canceled) {
        globals.markers.clear();
        return "You have canceled your trip";
      }

      if (dis <= 200 && dis >= 10) {
        // if within 200m of waypoint
        globals.globalDevice.transmit(dis, i);
      } else if (dis < 10) {
        // once past the waypoint
        while (await dist(steps[i]["end_location"]["lat"],
                steps[i]["end_location"]["lng"]) <
            10) {
          globals.globalDevice.transmit(0, i);
        }
        i++; // go to next step
      }

      sleep(const Duration(seconds: 3)); // sleeps for 3 seconds between loop
    }

    return "You have arrived at your destination"; // once dist < 15, arrived at destination
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
}
