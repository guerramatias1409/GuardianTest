import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guardiantest/Models/User.dart';
import 'package:guardiantest/Models/State.dart' as UserState;
import 'package:guardiantest/Screens/MyProfileScreen.dart';
import 'package:guardiantest/Services/FirebaseAuthService.dart';
import 'package:guardiantest/locator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user;
  UserState.State userState = new UserState.State();
  String string;

  @override
  void initState() {
    user = locator<FirebaseAuthService>().currentUser();
    print("USER ${user}");
    string = locator<FirebaseAuthService>().getString();
    print("STRING: $string");
    if (user == null) {
      userState.state1 = 50;
      userState.state2 = 50;
      userState.state3 = 50;
    } else {
      userState = user.state;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              openProfile();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 34,
                height: 34,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("State 1:"),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SliderTheme(
                        data: SliderThemeData(
                          activeTickMarkColor: Colors.blue,
                          inactiveTickMarkColor: Colors.grey.withOpacity(0),
                          activeTrackColor: Colors.blue,
                          inactiveTrackColor: Colors.grey.withOpacity(0.3),
                        ),
                        child: Expanded(
                          child: Slider(
                            value: userState.state1,
                            min: 0,
                            max: 100,
                            divisions: 20,
                            onChanged: (double value) {
                              setState(() {
                                userState.state1 = value;
                                print("State 1 = ${userState.state1}");
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        width: 30,
                        child: Text(
                          userState.state1.toStringAsFixed(0),
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("State 2: "),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SliderTheme(
                        data: SliderThemeData(
                          activeTickMarkColor: Colors.blue,
                          inactiveTickMarkColor: Colors.grey.withOpacity(0),
                          activeTrackColor: Colors.blue,
                          disabledActiveTrackColor:
                              Colors.grey.withOpacity(0.3),
                          inactiveTrackColor: Colors.grey.withOpacity(0.3),
                        ),
                        child: Expanded(
                          child: Slider(
                            value: userState.state2,
                            min: 0,
                            max: 100,
                            divisions: 20,
                            onChanged: (double value) {
                              setState(() {
                                userState.state2 = value;
                                print("State 2 = ${userState.state2}");
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: 30,
                        child: Text(
                          userState.state2.toStringAsFixed(0),
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("State 3: "),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SliderTheme(
                        data: SliderThemeData(
                          activeTickMarkColor: Colors.blue,
                          inactiveTickMarkColor: Colors.grey.withOpacity(0),
                          activeTrackColor: Colors.blue,
                          disabledActiveTrackColor:
                              Colors.grey.withOpacity(0.3),
                          inactiveTrackColor: Colors.grey.withOpacity(0.3),
                        ),
                        child: Expanded(
                          child: Slider(
                            value: userState.state3,
                            min: 0,
                            max: 100,
                            divisions: 20,
                            onChanged: (double value) {
                              setState(() {
                                userState.state3 = value;
                                print("State 3 = ${userState.state3}");
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: 30,
                        child: Text(
                          userState.state3.toStringAsFixed(0),
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Spacer(),
            SafeArea(
              child: Container(
                padding: EdgeInsets.all(12),
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 46,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: FloatingActionButton.extended(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    backgroundColor: Colors.green,
                    elevation: 4.0,
                    foregroundColor: Colors.white,
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Send State',
                      maxLines: 1,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      sendState();
                    },
                  ),
                ),
              ),
            )
          ],
        ));
  }

  void openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyProfileScreen()),
    );
  }

  void sendState() async {
    var userRef = FirebaseFirestore.instance
        .collection("Users")
        .doc("VrqFTDrCAIaTMHR9vwo8wWfazx02");

    await userRef.update({"State": userState.toJson()});
  }
}
