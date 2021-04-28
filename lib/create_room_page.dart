import 'package:flutter/material.dart';
import 'package:tawasal/CreateLiveVideoRoom.dart';

class CreateRoomPage extends StatefulWidget {
  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  Widget _liveCamRoom() {
    return GestureDetector(
      child: Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            children: [
              Row(children: [
                Icon(Icons.video_call),
              ]),
              Row(
                children: [
                  Container(
                    child: Text(
                      'Video Camera Room',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    padding: EdgeInsets.only(left: 5, right: 5),
                    color: Colors.purple[300],
                  )
                ],
              )
            ],
          )),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreateLiveVideoRoom())),
    );
  }

  Widget _shareScreen() {
    return GestureDetector(
      child: Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            children: [
              Row(children: [
                Icon(Icons.screen_share),
              ]),
              Row(
                children: [
                  Container(
                    child: Text(
                      'Share Screen Room',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    padding: EdgeInsets.only(left: 5, right: 5),
                    color: Colors.purple[300],
                  ),
                ],
              ),
              Row(
                children: [Container(child: Text('Coming soon...'))],
              )
            ],
          )),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Feature not supported yet...'),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Room Type'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(children: [_liveCamRoom()]),
          Column(children: [_shareScreen()])
        ],
      ),
    );
  }
}
