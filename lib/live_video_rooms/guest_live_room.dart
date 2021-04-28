import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:provider/provider.dart';
import 'package:tawasal/app_settings.dart';
import 'package:tawasal/live_room.dart';
import 'package:tawasal/live_rooms_list.dart';

class GuestLiveRoom extends StatefulWidget {
  final String roomID;

  GuestLiveRoom({this.roomID});

  @override
  _GuestLiveRoomState createState() => _GuestLiveRoomState();
}

class _GuestLiveRoomState extends State<GuestLiveRoom> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  RtcEngine _engine;
  RtcEngineConfig _engineConfig;
  LiveRoom _tempRoom;

  @override
  void initState() {
    super.initState();
    _tempRoom = context.read<LiveRoomsList>().roomsMap[widget.roomID];
    initialize();
  }

  void dipose() {
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
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
    await _engine.enableVideo();
    await _engine.joinChannel(_tempRoom.roomToken, widget.roomID, null, 0);
  }

  _initAgoraRtcEngine() async {
    _engineConfig = RtcEngineConfig(appID);
    _engine = await RtcEngine.createWithConfig(_engineConfig);
    //await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    //await _engine.setClientRole(ClientRole.Audience);
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
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

  Widget _renderRemoteVideo() {
    if (_tempRoom.hostNumber != null) {
      return Container(
          child: RtcRemoteView.SurfaceView(uid: _tempRoom.hostNumber));
    } else {
      return Container(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomID),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: [_renderRemoteVideo(), _panel()],
        ),
      ),
    );
  }
}
