import 'package:flutter/material.dart';
import 'package:guardiantest/Services/FirebaseAuthService.dart';
import 'package:guardiantest/locator.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Profile"),centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Name: "),
                    Text("Matias Guerra")
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Email: "),
                    Text("guerramatias1409@gmail.com")
                  ],
                ),
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
                  backgroundColor: Colors.red,
                  elevation: 4.0,
                  foregroundColor: Colors.white,
                  icon: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Logout',
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    logOut();
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void logOut() {
    try{
     final FirebaseAuthService auth = locator<FirebaseAuthService>();
     auth.signOut(context);
    }catch(e){
      print("signOut error: $e");
    }
  }
}
