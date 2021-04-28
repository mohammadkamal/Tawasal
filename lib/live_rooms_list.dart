import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tawasal/live_room.dart';

class LiveRoomsList extends ChangeNotifier {
  CollectionReference roomList =
      FirebaseFirestore.instance.collection('LiveRooms');

  Map<String, LiveRoom> _roomsMap = new Map<String, LiveRoom>();
  UnmodifiableMapView<String, LiveRoom> get roomsMap =>
      UnmodifiableMapView(_roomsMap);

  void addRoom(LiveRoom room) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      await roomList.doc(room.roomName).set(room.toJson());
      _roomsMap[room.roomName] = room;
    });
    notifyListeners();
  }

  void removeRoom(String id) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      await roomList.doc(id).delete();
      _roomsMap.remove(id);
    });
    notifyListeners();
  }

  Future<void> fetchData() async {
    QuerySnapshot querySnapshot = await roomList.get();
    var list = querySnapshot.docs;
    list.forEach((element) {
      _roomsMap[element.id] = LiveRoom.fromJson(element.data());
      notifyListeners();
    });
  }

  void update(String id, LiveRoom room) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      await roomList.doc(id).set(room.toJson());
      _roomsMap[id] = room;
    });
    notifyListeners();
  }
}