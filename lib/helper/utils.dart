import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_full_twitter/widget/loader_widget.dart';
import 'dart:developer' as developer;

final kAnalytics = FirebaseAnalytics();
final DatabaseReference kDatabase = FirebaseDatabase.instance.reference();
final Firestore kfirestore = Firestore.instance;
final kScreenloader = Loader();

String getUserName({String name, String id}) {
  String userName = '';
  name = name.split(' ')[0];
  id = id.substring(0, 4).toLowerCase();
  userName = '@$name$id';
  return userName;
}

void logEvent(String event, {Map<String, dynamic> parameter}) {
  kReleaseMode
      ? kAnalytics.logEvent(name: event, parameters: parameter)
      : print("[EVENT]: $event");
}

void cprint(dynamic data, {
  String errorIn,
  String event,
  String warningIn
}) {
  if(errorIn != null) {
    developer.log('[Error]', time: DateTime.now(), error: data, name: errorIn);
  } else if(data != null) {
    developer.log(data, time: DateTime.now());
  }
  if(event != null) {

  }
}
