import 'package:tawasal/AppSettings.dart';
import 'package:tawasal/RtcTokenGenerator.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

class OneToOneCall extends StatefulWidget {
  @override
  _OneToOneCallState createState() => _OneToOneCallState();
}

class _OneToOneCallState extends State<OneToOneCall> {
  String name = 'PrivateCall';
  bool _joined = false;
  int _remoteUid;
  bool _switch = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await Permission.camera.request();
    await Permission.microphone.request();
    RtcEngineConfig config = RtcEngineConfig(appID);
    var _engine = await RtcEngine.createWithConfig(config);

    _engine.setEventHandler(RtcEngineEventHandler(error: (code)
    {
      print(code);
    },
        joinChannelSuccess: (String channel, int uid, int elapsed) {
      print('joinChannelSuccess $channel $uid');
      setState(() {
        _joined = true;
      });
    }, userJoined: (int uid, int elapsed) {
      print('userJoined $uid');
      setState(() {
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      print('userOffline $uid');
      setState(() {
        _remoteUid = uid;
      });
    }));

    await _engine.enableVideo();
    var _token = await RtcTokenGenerator.getAgoraToken(name, 1129022635, 86400);
    await _engine.joinChannel(_token, name, null, 1129022635);
  }

  Widget _renderLocalPreview() {
    if (_joined) {
      return RtcLocalView.SurfaceView();
    } else {
      return Text(
        'Please join channel first',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _renderRemoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid,
      );
    } else {
      return Text(
        'Please wait remote user join',
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(child: _switch ? _renderRemoteVideo() : _renderLocalPreview()),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _switch = !_switch;
                });
              },
              child: Center(
                child: _switch ? _renderLocalPreview() : _renderRemoteVideo(),
              ),
            ),
          ),
        )
      ],
    );
  }
}
