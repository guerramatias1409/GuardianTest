import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guardiantest/Services/FirebaseAuthService.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email, password;
  FirebaseAuthService _firebaseAuth = FirebaseAuthService();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
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
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                        initialValue: "guerramatias1409@gmail.com",
                        onSaved: (value) => email = value,
                        decoration: InputDecoration.collapsed(
                            hintText: "Email",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            )),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
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
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                        initialValue: "bringt1234",
                        onSaved: (value) => password = value,
                        decoration: InputDecoration.collapsed(
                            hintText: "Password",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            )),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(18),
                  child: Material(
                    borderRadius: new BorderRadius.circular(10.0),
                    color: Colors.blueAccent,
                    child: InkWell(
                      onTap: () {
                        logIn();
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: Text('Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void logIn() async {
    if (validateAndSave()) {
      try {
        String result = await _firebaseAuth.signInWithEmailAndPassword(
            email, password, context);
        if (result != "") {
          print("RESULT ERRROR $result");
        }
      } on PlatformException catch (e) {
        print("ERROR $e");
      }
    }
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    form.save();
    return true;
  }
}
