import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService{
final FirebaseMessaging _fcm = FirebaseMessaging();

StreamSubscription iosSubscription;

bool isInit = false;

Future<void> init() async{
  if(isInit) return;
  if(kIsWeb) return;
  print("Init notification service");
  User userFB = FirebaseAuth.instance.currentUser;
  print("Current user: ${userFB.email}");
  print("PLATFORM IS IOS: ${Platform.isIOS}");

  _fcm.requestNotificationPermissions(const IosNotificationSettings(
    sound: true, badge: true, alert: true, provisional: true
  ));
  if(Platform.isIOS){
    print("IOS");
    _fcm.requestNotificationPermissions(IosNotificationSettings());
    iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
      print("Data: $data");
      saveDeviceToken(userFB.uid);
    });
  }else{
    print("NOT IOS");
    saveDeviceToken(userFB.uid);
  }

  _fcm.configure(
    onMessage: (Map<String, dynamic> message) async{
      print("ON MESSAGE: $message");
    },
    onLaunch: (Map<String, dynamic> message) async{
      print("ON LAUNCH: $message");
    },
    onResume: (Map<String, dynamic> message) async{
      print("ON RESUME: $message");
    }
  );

  isInit = true;

}

  void saveDeviceToken(String userId) async{
  if(iosSubscription != null) iosSubscription.cancel();
  String fcmToken = await _fcm.getToken();
  String deviceModel = "default";
  if(fcmToken != null){
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isAndroid){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceModel = androidInfo.model;
      print("Running on $deviceModel");
    }
    if(Platform.isIOS){
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceModel = iosInfo.utsname.machine;
      print("Running on $deviceModel");
    }
    try{
      var tokenRef = FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .collection("Tokens")
          .doc(fcmToken);

      await tokenRef.set({
        "Token": fcmToken,
        "CreatedAt": DateTime.now(),
        "Device": deviceModel,
        "Platform": Platform.operatingSystem
      });
    }catch (e){
      print("ERROR SAVE TOKEN ${e.toString()}");
    }

  }
  }

  Future<void> logOut(String userId) async{
  if(kIsWeb) return;
  String fcmToken = await _fcm.getToken();
  try{
    var tokenRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("Tokens")
        .doc(fcmToken);

    await tokenRef.delete();
  }catch (e){
    print("ERROR DELETE TOKEN: ${e.toString()}");
  }
  }
}