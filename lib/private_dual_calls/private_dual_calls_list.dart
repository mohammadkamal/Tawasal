import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tawasal/PrivateDualCall.dart';

class PrivateDualCallsList extends ChangeNotifier {
  Map<String, PrivateDualCall> _callsMap = new Map<String, PrivateDualCall>();
  UnmodifiableMapView<String, PrivateDualCall> get callsMap =>
      UnmodifiableMapView(_callsMap);

  CollectionReference callsDatabase =
      FirebaseFirestore.instance.collection('DualCalls');

  void addDualCall(PrivateDualCall privateDualCall) {
    String callID = privateDualCall.senderNumber.toString() +
        privateDualCall.receiverNumber.toString();
    FirebaseFirestore.instance.runTransaction((transaction) async {
      await callsDatabase.doc(callID).set(privateDualCall.toJson());
      _callsMap[callID] = privateDualCall;
    });
    notifyListeners();
  }

  void removeDualCall(String id) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      await callsDatabase.doc(id).delete();
      _callsMap.remove(id);
    });
    notifyListeners();
  }

  Future<void> fetchData() async {
    QuerySnapshot querySnapshot = await callsDatabase.get();
    var list = querySnapshot.docs;
    list.forEach((element) {
      _callsMap[element.id] = PrivateDualCall.fromJson(element.data());
      notifyListeners();
    });
  }
}
