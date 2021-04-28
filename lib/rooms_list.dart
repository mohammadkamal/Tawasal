import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tawasal/AppSideDrawer.dart';
import 'package:tawasal/CreateRoomPage.dart';
import 'package:tawasal/GuestLiveRoom.dart';
import 'package:tawasal/LiveRoomsList.dart';

class RoomsList extends StatefulWidget {
  @override
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
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => CreateRoomPage())),
        child: Icon(Icons.add),
      ),
      drawer: AppSideDrawer(),
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
