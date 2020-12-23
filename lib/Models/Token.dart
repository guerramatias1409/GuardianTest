import 'package:cloud_firestore/cloud_firestore.dart';

class Token{
  String id;
  String device;
  String platform;
  String token;

  Token();

  Token.fromDocument(DocumentSnapshot document){
    this.id = document["Token"];
    this.token = document["Token"];
    this.device = document["Device"];
    this.platform = document["Platform"];
  }

}