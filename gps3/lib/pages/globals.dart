library my_prj.globals;
import 'main_page.dart';
import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';

bool isLoggedIn = false;
List<BlueInfo> devices = [];
bool isConnected = false;

List<Marker> markers = <Marker>[];