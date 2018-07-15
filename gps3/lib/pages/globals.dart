library my_prj.globals;

import 'package:flutter_blue/flutter_blue.dart';
import 'package:map_view/map_view.dart';
import 'algorithm.dart';

bool isLoggedIn = false;
bool isConnected = false;
bool canceled = false;

List<BlueInfo> devices = [new BlueInfo("Name", "ID")];
Algorithm globalDevice = new Algorithm();

List<Marker> markers = <Marker>[];
String next;
String dest;

class BlueInfo {
  String title;
  String iD;

  BlueInfo(String titlee, String id) {
    iD = id;
    title = titlee;
    if (title == "" || title == null) title = iD;
  }

  @override
  String toString() {
    return title + ":" + iD.toString();
  }

  BluetoothDevice toDevice() {
    return BluetoothDevice(
        name: this.title,
        id: DeviceIdentifier(this.iD),
        type: BluetoothDeviceType.unknown);
  }
}
