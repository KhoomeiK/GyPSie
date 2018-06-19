import 'package:http/http.dart' as http;
import 'package:vibrate/vibrate.dart' as vib;
import 'package:location/location.dart';
import 'dart:convert' as parse;
import 'dart:math' as Math;
import 'dart:io';

class Algorithm {
  String origin, dest;
  String side;

  setPoints(o, d) {
    origin = o;
    dest = d;
  }

  setSide(b) {
    if (b) side = "turn-right";
    else side = "turn-left";
  }

  var link = "https://maps.googleapis.com/maps/api/directions/json?origin=" + origin 
    + "&destination=" + dest 
    + "&key=AIzaSyD0zb7Xdwk0FH-TOVbYkCTjSQargAwjb84";

  var json = parse.jsonDecode(http.get(link));
  var steps = json.routes[0].legs[0].steps;

  loop() {
    int i = 0;
    while(dist(json.routes[0].legs[0].end_location.lat, json.routes[0].legs[0].end_location.lon) > 15) {
      var dis = dist(steps[i].end_location.lat, steps[i].end_location.lng);
      if (dis <= 200 && dis > 10) {
        if (steps[i+1].maneuver.equals(side)) vib.Vibrate.vibrate();
      }
      else if (dis >= 10) {
        i++;
      }
      sleep(const Duration(seconds:1));
    }

    return "You have arrived at your destination";
  }

  toRadians(deg) {
    return deg * Math.PI / 180;
  }

  dist(lat2, lon2) {
    var cur = (new Location()).getLocation;
    var lat1 = cur.latitude;
    var lon1 = cur.longitude;

    var R = 6371e3; // metres
    var la1 = toRadians(lat1);
    var la2 = toRadians(lat2);
    var ladif = toRadians(lat2-lat1);
    var lodif = toRadians(lon2-lon1);

    var a = Math.sin(ladif/2) * Math.sin(ladif/2) +
            Math.cos(la1) * Math.cos(la2) *
            Math.sin(lodif/2) * Math.sin(lodif/2);

    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

    var d = R * c;

    return d;
  }
}