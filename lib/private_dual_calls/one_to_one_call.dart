import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:tawasal/app_settings.dart';
import 'package:tawasal/private_dual_calls/private_dual_call.dart';
import 'package:tawasal/utilities/rtc_token_generator.dart';

class OneToOneCall extends StatefulWidget {
  OneToOneCall({this.privateDualCall});
  final PrivateDualCall privateDualCall;
  @override
  _OneToOneCallState createState() => _OneToOneCallState();
}

class _OneToOneCallState extends State<OneToOneCall> {
  String name = 'PrivateCall';
  bool _localJoined = false;
  bool _remoteJoined = false;
  int _remoteUid;
  bool muted = false;
  RtcEngine _engine;
  RtcEngineConfig _config;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void dipose() {
    _engine.destroy();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    await Permission.camera.request();
    await Permission.microphone.request();
    _config = RtcEngineConfig(appID);
    _engine = await RtcEngine.createWithConfig(_config);

    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      print(code);
    }, joinChannelSuccess: (String channel, int uid, int elapsed) {
      print('joinChannelSuccess $channel $uid');
      setState(() {
        _localJoined = true;
      });
    }, userJoined: (int uid, int elapsed) {
      print('userJoined $uid');
      setState(() {
        _remoteUid = uid;
        _remoteJoined = true;
        setState(() {});
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      print('userOffline $uid');
      setState(() {
        _remoteUid = uid;
        _remoteJoined = false;
        setState(() {});
      });
    }));

    await _engine.enableVideo();
    var _token =
        await RtcTokenGenerator.getAgoraToken(name, widget.privateDualCall.senderNumber, 86400);
    await _engine.joinChannel(_token, name, null, widget.privateDualCall.senderNumber);
  }

  Widget _renderLocalPreview() {
    if (_localJoined) {
      return RtcLocalView.SurfaceView();
    } else {
      return CircularProgressIndicator();
    }
  }

  Widget _renderRemoteVideo() {
    if (_remoteJoined) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid,
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    _engine.leaveChannel();
    Navigator.pop(context);
  }

  /// Mute
  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
            child:
                _remoteJoined ? _renderRemoteVideo() : _renderLocalPreview()),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
            child: Center(
              child:
                  _remoteJoined ? _renderLocalPreview() : _renderRemoteVideo(),
            ),
          ),
        ),
        _toolbar()
      ],
    );
  }
}
