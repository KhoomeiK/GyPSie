library my_prj.globals;
import 'main_page.dart';
import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';

bool isLoggedIn = false;
List<BlueInfo> devices = [new BlueInfo("yeet", "onemboio")];
bool isConnected = false;
bool canceled = false;

List<Marker> markers = <Marker>[];
String dest;
String next;