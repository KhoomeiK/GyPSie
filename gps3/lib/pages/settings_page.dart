import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  State createState() => new SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  var assetsImage = new AssetImage('assets/download.png');

  @override
  Widget build(BuildContext context) {
    var image = new Image(image: assetsImage, width: 48.0, height: 48.0);
    return new Scaffold(
      appBar: AppBar(
        title: new Padding(
            child: new Text("Settings"),
            padding: const EdgeInsets.only(left: 0.0)),
      ),
      body: Container(
          child: new ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, i) {
                new Column(
                  children: <Widget>[
                    new ListTile(
                      title: new Text("lol"),
                    ),
                    new ListTile(
                      title: new Text("lol"),
                    ),
                    new ListTile(
                      title: new Text("lol"),
                    ),
                    new ListTile(
                      title: new Text("lol"),
                    ),
                    new ListTile(
                      title: new Text("lol"),
                    ),
                    new ListTile(
                      title: new Text("lol"),
                    ),
                    new ListTile(
                      title: new Text("lol"),
                    ),
                  ],
                );
              })),
    );
  }
}
