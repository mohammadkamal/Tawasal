import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tawasal/app_settings.dart';
import 'package:tawasal/live_room.dart';
import 'package:tawasal/live_rooms_list.dart';
import 'package:tawasal/rooms_list.dart';

class HostLiveRoom extends StatefulWidget {
  final LiveRoom liveRoom;

  HostLiveRoom({this.liveRoom});

  @override
  _HostLiveRoomState createState() => _HostLiveRoomState();
}

class _HostLiveRoomState extends State<HostLiveRoom> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  RtcEngine _engine;
  RtcEngineConfig _engineConfig;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    if (appID.isEmpty) {
      setState(() {
        _infoStrings
            .add('APP_ID missing, please provide your APP_ID in settings.dart');
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.joinChannel(widget.liveRoom.roomToken,
        widget.liveRoom.roomName, null, widget.liveRoom.hostNumber);
    //List<TranscodingUser> _transcodingusers = <TranscodingUser>[];
    //LiveTranscoding _liveTranscoding=LiveTranscoding(_transcodingusers);
    //await _engine.setLiveTranscoding(_liveTranscoding);
  }

  _initAgoraRtcEngine() async {
    _engineConfig = RtcEngineConfig(appID);
    _engine = await RtcEngine.createWithConfig(_engineConfig);
    await _engine.enableVideo();
    await _engine.startPreview();
    //await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    //await _engine.setClientRole(ClientRole.Broadcaster);
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'joinChannelSuccess: $channel, uid: $uid';
        _infoStrings.add(info);
        //Add host uid to firebase
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }));
  }

  Widget _renderLocalPreview() {
    return RtcLocalView.SurfaceView();
  }

  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
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

  /// Stop live streaming
  void _onCallEnd(BuildContext context) {
    context.read<LiveRoomsList>().removeRoom(widget.liveRoom.roomName);
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => RoomsList()));
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
    return Scaffold(
      appBar: AppBar(title: Text(widget.liveRoom.roomName)),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: [
            _renderLocalPreview(),
            _panel(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
