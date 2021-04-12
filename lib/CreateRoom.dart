import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tawasal/HostLiveRoom.dart';
import 'package:tawasal/LiveRoom.dart';
import 'package:tawasal/LiveRoomsList.dart';

class CreateRoom extends StatefulWidget {
  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roomNameCtrl = TextEditingController();

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
      context
          .read<LiveRoomsList>()
          .addRoom(new LiveRoom(roomName: _roomNameCtrl.text));
      await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HostLiveRoom(roomID: _roomNameCtrl.text)));
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
        title: Text('Create Room'),
      ),
      body: _mainForm(),
    );
  }
}