import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:tawasal/contact_accounts/contact_account.dart';

class ContactsList extends ChangeNotifier {
  Map<String, ContactAccount> _contactsMap = new Map<String, ContactAccount>();
  UnmodifiableMapView<String, ContactAccount> get contactsMap =>
      UnmodifiableMapView(_contactsMap);

  CollectionReference contactsDatabase =
      FirebaseFirestore.instance.collection('TawasalContacts');

  void addNewContact(String uid, ContactAccount contactAccount) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      await contactsDatabase.doc(uid).set(contactAccount.toJson());
      _contactsMap[uid] = contactAccount;
    });
    notifyListeners();
  }

  void removeContact(String uid) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      await contactsDatabase.doc(uid).delete();
      _contactsMap.remove(uid);
    });
    notifyListeners();
  }

  void updateContact(String uid, ContactAccount contactAccount) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      await contactsDatabase.doc(uid).set(contactAccount.toJson());
      _contactsMap[uid] = contactAccount;
    });
    notifyListeners();
  }

  void updateDisplayName(String uid, String displayName) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      await contactsDatabase.doc(uid).update({'displayName': displayName});
      var _newContact = await contactsDatabase.doc(uid).get();
      _contactsMap[uid] = ContactAccount.fromJson(_newContact.data());
    });
  }

  Future<void> fetchData() async {
    _contactsMap.clear();
    QuerySnapshot querySnapshot = await contactsDatabase.get();
    var list = querySnapshot.docs;
    list.forEach((element) {
      if (element.id == FirebaseAuth.instance.currentUser.uid) {
      } else {
        _contactsMap[element.id] = ContactAccount.fromJson(element.data());
      }
      notifyListeners();
    });
  }

  Future<int> getLocalNumberByUID(String uid) async {
    DocumentSnapshot _snapshot = await contactsDatabase.doc(uid).get();
    ContactAccount _account = ContactAccount.fromJson(_snapshot.data());
    return _account.phoneNumberLocal;
  }
}
