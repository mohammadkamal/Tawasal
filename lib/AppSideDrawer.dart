import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tawasal/ViewContactsList.dart';

class AppSideDrawer extends StatefulWidget {
  @override
  _AppSideDrawerState createState() => _AppSideDrawerState();
}

class _AppSideDrawerState extends State<AppSideDrawer> {
  Widget _drawerHeader() {
    String _name = '';
    if (FirebaseAuth.instance.currentUser.displayName == null ||
        FirebaseAuth.instance.currentUser.displayName.isEmpty) {
      _name = FirebaseAuth.instance.currentUser.phoneNumber;
    } else {
      _name = FirebaseAuth.instance.currentUser.displayName;
    }
    return DrawerHeader(
      child: FirebaseAuth.instance.currentUser == null
          ? Text('Not signed in')
          : Text(_name),
      decoration: BoxDecoration(color: Colors.blue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          _drawerHeader(),
          ListTile(
              title: Text('Contacts'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewContactsList()));
              })
        ],
      ),
    );
  }
}
