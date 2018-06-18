import 'package:http/http.dart' as http;
import 'package:vibrate/vibrate.dart' as vib;
import 'package:location/location.dart';
import 'dart:convert' as parse;

// input origin (prefill current location)
// input destination
// Go button
var origin = "";
var dest = "";
var link = "https://maps.googleapis.com/maps/api/directions/json?origin=" + origin 
  + "&destination=" + dest 
  + "&key=AIzaSyD0zb7Xdwk0FH-TOVbYkCTjSQargAwjb84";
// Directions API request > save JSON
var json = http.get(link);
var e = parse.jsonDecode(json);
var steps = e.routes.legs[0].steps;
var lat = steps[0].end_location.lat;
var lng = steps[0].end_location.lng;

var cur = (new Location()).getLocation;
var oof = vib.Vibrate.vibrate();

// loop:
// get current location 
// determine direction to waypoint from JSON
// calculate distance to next waypoint
// if distance < 1000ft send vibration
while (/* cur != destination */) {
  if (cur > dest - 200)
}