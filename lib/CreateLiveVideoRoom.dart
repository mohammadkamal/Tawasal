import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tawasal/ContactsList.dart';
import 'package:tawasal/HostLiveRoom.dart';
import 'package:tawasal/LiveRoom.dart';
import 'package:tawasal/LiveRoomsList.dart';
import 'package:tawasal/RtcTokenGenerator.dart';

class CreateLiveVideoRoom extends StatefulWidget {
  @override
  _CreateLiveVideoRoomState createState() => _CreateLiveVideoRoomState();
}

class _CreateLiveVideoRoomState extends State<CreateLiveVideoRoom> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roomNameCtrl = TextEditingController();
  int _userPhone;
  String _token;
  LiveRoom _liveRoom;

  Widget _roomNameLabel() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        'Room name',
        softWrap: true,
      ),
    );
  }

  Widget _roomNameField() {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: TextFormField(
        controller: _roomNameCtrl,
        decoration: InputDecoration(
            border: null, labelText: 'Enter the name of the room'),
        autofocus: true,
        validator: (value) {
          if (value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _createButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: _onCreate,
        child: Text('Create'),
      ),
    );
  }

  Future<void> _onCreate() async {
    if (_formKey.currentState.validate()) {
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);

      _userPhone = await context.read<ContactsList>().getLocalNumberByUID(FirebaseAuth.instance.currentUser.uid);

      _token = await RtcTokenGenerator.getAgoraToken(
          _roomNameCtrl.text, _userPhone, 86400);

      _liveRoom = LiveRoom(
          roomName: _roomNameCtrl.text,
          hostNumber: _userPhone,
          roomToken: _token);

      context.read<LiveRoomsList>().addRoom(_liveRoom);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HostLiveRoom(
                    liveRoom: _liveRoom,
                  )));
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  Widget _mainForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Column(
            children: [_roomNameLabel(), _roomNameField(), _createButton()],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Live Video Room'),
      ),
      body: _mainForm(),
    );
  }
}
