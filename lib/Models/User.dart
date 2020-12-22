
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guardiantest/Models/State.dart';

class User {
  String id;
  String name;
  String email;
  State state;
  User guardianId;

  User();

  User.createNew(this.id, this.name, this.email);

  User.fromDocument(DocumentSnapshot document){
    this.id = document.id;
    this.name = document.data()["Name"] == null ? "" : document.data()["Name"];
    this.email = document.data()["Email"] == null ? "" : document.data()["Email"];
    this.state = document.data()["State"] == null ? null : new State.fromJson(document.data()["State"]);
    this.guardianId = document.data()["Guardian"] == null ? null : new User.fromJson(document.data()["Guardian"]);
  }

  User.fromJson(Map<dynamic, dynamic> json){
    this.id = json["Id"];
    this.name = json["Name"] ?? "";
    this.email = json["Email"] ?? "";
    this.state = json["State"] == null ? null : new State.fromJson(json["State"]);
    this.guardianId = json["Guardian"] == null ? null : new User.fromJson(json["Guardian"]);
  }

  Map<String, dynamic> toJson(){
    return{
      "Id": id,
      "Name": name,
      "Email": email,
      "State": state,
      "Guardian": guardianId
    };
  }
}