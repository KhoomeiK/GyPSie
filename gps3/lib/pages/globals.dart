library my_prj.globals;

import 'package:flutter_blue/flutter_blue.dart';
import 'package:map_view/map_view.dart';
import 'algorithm.dart';
import 'main_page.dart';

bool isLoggedIn = false;
bool isConnected = false;
bool canceled = false;

List<BlueInfo> devices = [];
Algorithm globalDevice = new Algorithm();
Algorithm globalDevice2 = new Algorithm();

List<Marker> markers = <Marker>[];
String next;
String dest;

String travelMode = "BICYCLING";
