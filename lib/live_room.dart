import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class LiveRoom {
  LiveRoom({this.roomName, this.hostNumber, this.roomToken});
  String roomName;
  int hostNumber;
  String roomToken;

  factory LiveRoom.fromJson(Map<String, dynamic> json) =>
      _$LiveRoomFromJson(json);
  Map<String, dynamic> toJson() => _$LiveRoomToJson(this);
}

LiveRoom _$LiveRoomFromJson(Map<String, dynamic> json) {
  return LiveRoom(
      roomName: json['roomName'],
      hostNumber: json['hostNumber'],
      roomToken: json['roomToken']);
}

Map<String, dynamic> _$LiveRoomToJson(LiveRoom room) => <String, dynamic>{
      'roomName': room.roomName,
      'hostNumber': room.hostNumber,
      'roomToken': room.roomToken
    };
