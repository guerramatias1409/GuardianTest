import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:guardiantest/Models/Token.dart';
import 'package:guardiantest/Models/User.dart';
import 'package:guardiantest/Models/State.dart' as UserState;
import 'package:guardiantest/Screens/MyProfileScreen.dart';
import 'package:guardiantest/Services/FirebaseAuthService.dart';
import 'package:guardiantest/locator.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user;
  String userId;
  final formKey = GlobalKey<FormState>();
  UserState.State userState = new UserState.State();

  List<DropdownMenuItem<User>> usersList;
  User selectedUser;

  List<Token> tokensList;
  List<User> guardiansList = List<User>();

  final String serverToken = 'AAAARJPxwqY:APA91bFSoETo7nWT_n0rhuprXlQ0DARZvfZIYMmZCQ6rGKF518cY75ZoTYumg6S76p6tp9qqlwf3IEi_eqkSVK_sK3vVZYPHd_RHHDQyjIcsC7Qtrh7z6xs2QAcpg_hKlr-tw-VzJwCt';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  
  @override
  void initState(){
    user = locator<FirebaseAuthService>().currentUser();
    print("USER $user");
    getUsersList();
    getGuardiansList();
    getTokensList();
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
        body: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Material(
                        borderRadius: new BorderRadius.circular(5.0),
                        color: Color(0xFF210372).withOpacity(.5),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: TextFormField(
                            onChanged: (value){
                              setState(() {
                                userId = value;
                              });
                            },
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                            onSaved: (value) => userId = value,
                            initialValue: "VrqFTDrCAIaTMHR9vwo8wWfazx02",
                            decoration: InputDecoration.collapsed(
                                hintText: "Id",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Guardian: "),
                        SizedBox(height: 5),
                        usersList == null
                            ? Container()
                            : Center(
                              child: DropdownButton<User>(
                              hint: Text("Users"),
                              value: selectedUser == null
                                  ? null
                                  : selectedUser,
                              onChanged: onChangeDropdownItem,
                              items: usersList),
                            )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(12),
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 46,
                        width: double.infinity,
                        decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                        child: FloatingActionButton.extended(
                          heroTag: 'SaveGuardian',
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
                            'Save Guardian',
                            maxLines: 1,
                            style:
                            TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            saveGuardian();
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("My Guardians: "),
                        SizedBox(height: 5),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: guardiansList.length==0? [
                            Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("You have no guardians"),
                          )
                          ] :
                          guardiansList.map((guardian) {
                            return Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(guardian.name),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      deleteGuardian(guardian);
                                    },
                                    child: Icon(Icons.delete))
                              ],
                            );
                          }).toList(),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Text("State 1:"),
                    SizedBox(height: 5),
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
                              value: userState.state1.toDouble(),
                              min: 0,
                              max: 100,
                              divisions: 20,
                              onChanged: (value) {
                                setState(() {
                                  userState.state1 = value.toInt();
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
                    SizedBox(height: 5),
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
                              value: userState.state2.toDouble(),
                              min: 0,
                              max: 100,
                              divisions: 20,
                              onChanged: (value) {
                                setState(() {
                                  userState.state2 = value.toInt();
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
                    SizedBox(height: 5),
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
                              value: userState.state3.toDouble(),
                              min: 0,
                              max: 100,
                              divisions: 20,
                              onChanged: (value) {
                                setState(() {
                                  userState.state3 = value.toInt();
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
                      heroTag: "SendState",
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
          ),
        ));
  }

  void openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyProfileScreen()),
    );
  }

  void sendState() async {
    if(validateAndSave()){
      var userRef = FirebaseFirestore.instance
          .collection("Users")
          .doc(userId);

      await userRef.update({"State": userState.toJson()});
      
      tokensList.forEach((token) {
        sendMessage(token);
      });

      clearStates();
    }

  }

  bool validateAndSave() {
    final form = formKey.currentState;
    form.save();
    return true;
  }

  void getUsersList() {
    FirebaseFirestore.instance.collection("Users").get().then((snapshot) {
      var users = new List<User>();
      snapshot.docs.forEach((DocumentSnapshot document) {
        users.add(new User.fromDocument(document));
      });

      usersList = users.map((User value) {
        return new DropdownMenuItem<User>(
            value: value,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              constraints: BoxConstraints(maxWidth: 200),
              child: new Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                    Colors.grey,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Flexible(
                    child: Text(value.name,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ));
      }).toList();
      setState(() {
        print("seteo");
      });
    });
  }

  void onChangeDropdownItem(User _selectedUser) {
    setState(() {
      selectedUser = _selectedUser;
    });
  }

  void saveGuardian() async{
    print("SAVE GUARDIAN");
    var guardianRef = FirebaseFirestore.instance
        .collection("Users")
        .doc("VrqFTDrCAIaTMHR9vwo8wWfazx02") //TODO usar current user
        .collection("Guardians")
        .doc(selectedUser.id);

    await guardianRef.set(selectedUser.toJson());
    getGuardiansList();
    setState(() {
      guardiansList = guardiansList;
    });
  }

  Future<void> getTokensList() async{
    FirebaseFirestore.instance
        .collection("Users")
        .doc("VrqFTDrCAIaTMHR9vwo8wWfazx02") //TODO usar current user
        .collection("Guardians")
        .get()
        .then((snapshot) {
          var tokens = List<Token>();
      snapshot.docs.forEach((DocumentSnapshot document) {
        var user = new User.fromDocument(document);
        FirebaseFirestore.instance
            .collection("Users")
            .doc(user.id)
            .collection("Tokens")
            .get()
            .then((tokenSnapshot){
              tokenSnapshot.docs.forEach((token) {
                tokens.add(new Token.fromDocument(token));
              });
        });
      });

      tokens.sort((a,b){
        if(a.platform != b.platform){
          return a.platform == "ios" ? -1 : 1;
        }else{
          return a.device.compareTo(b.device);
        }
      });

      setState(() {
        tokensList = tokens;
      });
      print("TOKENSLIST LENGHT: ${tokensList.length}");
    });
  }

  void sendMessage(Token token) async{
    print("SEND MESSAGE");
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Go and help him',
            'title': 'Your protected has changed state',
            'sound': 'default'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          },
          'to': token.token,
        },
      ),
    );
    print("PASO POST");
  }

  void clearStates() {
    setState(() {
      userState.state1 = 50;
      userState.state2 = 50;
      userState.state3 = 50;
    });
  }

  void getGuardiansList() {
    guardiansList.clear();
    print("GET GUARDIAN LIST");
    FirebaseFirestore.instance
        .collection("Users")
        .doc("VrqFTDrCAIaTMHR9vwo8wWfazx02") //TODO usar current user
        .collection("Guardians")
        .get()
        .then((snapshot) {
          print("LENGHT: ${snapshot.docs.length}");
          snapshot.docs.forEach((document) {
            print("USER: ${User.fromDocument(document).toJson()}");
            guardiansList.add(new User.fromDocument(document));
            setState(() {
              guardiansList = guardiansList;
            });
          });
    });
  }

  void deleteGuardian(User guardian) async{
    var guardianRef = FirebaseFirestore.instance
        .collection("Users")
        .doc("VrqFTDrCAIaTMHR9vwo8wWfazx02") //TODO usar current user
        .collection("Guardians")
        .doc(guardian.id);

    await guardianRef.delete();
    getGuardiansList();
    setState(() {
      guardiansList = guardiansList;
    });
  }
}