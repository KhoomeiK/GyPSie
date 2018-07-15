library my_prj.globals;
import 'bluetooth_page.dart';
import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'algorithm.dart';

bool isLoggedIn = false;
List<BlueInfo> devices = [new BlueInfo("yeet", "onemboio")];
bool isConnected = false;
bool canceled = false;
Algorithm globalDevice = new Algorithm();

List<Marker> markers = <Marker>[];
String dest;
String next;