import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tawasal/contact_accounts/contacts_list.dart';
import 'package:tawasal/contact_accounts/login_page.dart';
import 'package:tawasal/live_rooms_list.dart';
import 'package:tawasal/rooms_list.dart';
import 'package:tawasal/splash_screen.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => LiveRoomsList()),
    ChangeNotifierProvider(create: (context) => ContactsList())
  ], child: Tawasal()));
}

class Tawasal extends StatefulWidget {
  @override
  _TawasalState createState() => _TawasalState();
}

class _TawasalState extends State<Tawasal> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Error occured');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              home: FirebaseAuth.instance.currentUser == null
                  ? LoginPage()
                  : RoomsList());
        } else {
          return MaterialApp(
            title: 'Tawasal',
            home: SplashScreen(),
          );
        }
      },
    );
  }
}
