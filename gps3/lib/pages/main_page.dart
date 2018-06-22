import 'package:flutter/material.dart';
import 'algorithm.dart';

class MainPage extends StatefulWidget {
  State createState() => new MainPageState();
}

class MainPageState extends State<MainPage>{

  Algorithm backEnd = new Algorithm();
  int index = 0;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  dynamic _borderRadius = new BorderRadius.circular(20.0);
  String origin1;
  String destination;

  Widget _buildForm(){
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: new InputDecoration(labelText: "Origin", border: OutlineInputBorder(borderRadius: _borderRadius)),
            validator: (val) => (val == null) ? 'Empty' : null,
            onSaved: (val) => origin1 = val,
          ),
          SizedBox(height: 12.0),
          TextFormField(
            decoration: new InputDecoration(labelText: "Destination", border: OutlineInputBorder(borderRadius: _borderRadius)),
            validator: (val) => (val == null) ? 'Empty' : null,
            onSaved: (val) => destination = val,
          ),
        ],
      ),
    );
  }

  void _submit() {
   final form = formKey.currentState;
    if(form.validate()){
        form.save();
        var x = backEnd.setPoints(origin1, destination);
        print(x);
      } 

  }

  Widget _buildButton() {
    return RaisedButton(
      padding: EdgeInsets.all(20.0),
      elevation: 8.0,
      child: Text("Go!", style: TextStyle(color: Colors.white, fontSize: 20.0)),
      shape: RoundedRectangleBorder(borderRadius: _borderRadius),
      onPressed: (){ 
        _submit();
        },
      color: Colors.lightBlue,
      splashColor: Colors.blue,
    );
  }



  Widget _buildBottomNav(){
    return new BottomNavigationBar(
      currentIndex: index,
      items: <BottomNavigationBarItem>[
        new BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          title: new Text("Left"),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.search),
          title: new Text("Right"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print("App being built");
    return new Scaffold(
      appBar: AppBar(
        title: Text('GyPSie'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            _buildForm(),
            SizedBox(height: 25.0),
            _buildButton(),
            SizedBox(height: 25.0),
            Flex(
              direction: Axis.vertical,
              children: <Widget>[
               
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }
}

