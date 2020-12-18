import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guardiantest/Models/User.dart';
import 'package:guardiantest/Services/FirebaseAuthService.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String name, email, password;
  String userId;
  FirebaseAuthService _firebaseAuth = FirebaseAuthService();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register"),),
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
                        onSaved: (value) => name = value,
                        decoration: InputDecoration.collapsed(
                            hintText: "Name",
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
                      onTap: () async{
                        registerEmail();
                      },
                      child: Container(
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void registerEmail() async{
    if(validateAndSave()){
      try{
        userId = await _firebaseAuth.registerWithEmailAndPassword(email, password);
        if(userId!=null){
          createNewUser(userId);
        }
      } on PlatformException catch (e){
        print("Error $e}");
      }

    }
  }

  bool validateAndSave(){
    final form = formKey.currentState;
    form.save();
    return true;
  }

  void createNewUser(String id) async{
    print("create new user");
    var user = new User.createNew(id,name,email);

    var userRef = FirebaseFirestore.instance.collection("Users").doc(id);

    await userRef.set(user.toJson());
    Navigator.pop(context);
  }
}
