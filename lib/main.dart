import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tawasal/GuestLiveRoom.dart';
import 'package:tawasal/LiveRoomsList.dart';
import 'package:tawasal/OneToOneCall.dart';
import 'package:tawasal/SplashScreen.dart';

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => LiveRoomsList())],
      child: Tawasal()));
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
          return MaterialApp(home: RoomsList());
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

class RoomsList extends StatefulWidget {
  _RoomsListState createState() => _RoomsListState();
}

class _RoomsListState extends State<RoomsList> {
  @override
  void initState() {
    super.initState();
    context.read<LiveRoomsList>().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tawasal'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('Not signed in'),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
                title: Text('Direct call'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OneToOneCall()));
                })
          ],
        ),
      ),
      body: ListView(
        children: Provider.of<LiveRoomsList>(context).roomsMap.isNotEmpty
            ? Provider.of<LiveRoomsList>(context).roomsMap.keys.map((e) {
                return ListTile(
                  title: Text(e),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GuestLiveRoom(roomID: e))),
                );
              }).toList()
            : [],
      ),
    );
  }
}
