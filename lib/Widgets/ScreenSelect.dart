import 'package:flutter/material.dart';

class ScreenSelect extends StatefulWidget {
  String title;

  ScreenSelect({this.title});
  
  @override
  _ScreenSelectState createState() => new _ScreenSelectState();
}

class _ScreenSelectState extends State<ScreenSelect> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: new Container(
        height: 35.0,
        color: Color(0xFFFF6500),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}