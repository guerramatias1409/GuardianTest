import 'package:cloud_firestore/cloud_firestore.dart';

class State {
  double state1;
  double state2;
  double state3;

  State();

  State.fromDocument(DocumentSnapshot document){
    this.state1 = document.data()["State1"] == null ? 50: document.data()["State1"];
    this.state2 = document.data()["State2"] == null ? 50: document.data()["State2"];
    this.state3 = document.data()["State3"] == null ? 50 : document.data()["State3"];
  }

  State.fromJson(Map<dynamic, dynamic> json){
    this.state1 = json["State1"];
    this.state2 = json["State2"];
    this.state3 = json["State3"];
  }

  Map<String, dynamic> toJson(){
    return {
      "State1": state1.toStringAsFixed(0),
      "State2": state2.toStringAsFixed(0),
      "State3": state3.toStringAsFixed(0),
    };
  }
}