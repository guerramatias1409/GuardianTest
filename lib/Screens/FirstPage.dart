import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guardiantest/Screens/LoginScreen.dart';
import 'package:guardiantest/Screens/RegisterScreen.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("First Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Material(
              borderRadius: new BorderRadius.circular(10.0),
              color: Color(0xFF3985FF),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RegisterScreen()));
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 160,
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                      'REGISTER',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen()));
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 160 ,
                  height: 50 ,
                  decoration: new BoxDecoration(
                      borderRadius:
                      new BorderRadius.circular( 10.0 ) ,
                      border:
                      new Border.all( color: Colors.grey ) ) ,
                  alignment: Alignment.center ,
                  child: Text (
                      'LOGIN' ,
                      style: TextStyle (
                          fontSize: 17 ,
                          fontWeight: FontWeight.bold ) ) ,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
