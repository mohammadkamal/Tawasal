import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PrivateDualCall {
  PrivateDualCall({this.senderNumber, this.receiverNumber, this.callToken});
  int senderNumber;
  int receiverNumber;
  String callToken;

  factory PrivateDualCall.fromJson(Map<String, dynamic> json) =>
      _$PrivateDualCallFromJson(json);
  Map<String, dynamic> toJson() => _$PrivateDualCallToJson(this);
}

PrivateDualCall _$PrivateDualCallFromJson(Map<String, dynamic> json) {
  return PrivateDualCall(
      senderNumber: json['senderNumber'],
      receiverNumber: json['receiverNumber'],
      callToken: json['callToken']);
}

Map<String, dynamic> _$PrivateDualCallToJson(PrivateDualCall call) =>
    <String, dynamic>{
      'senderNumber': call.senderNumber,
      'receiverNumber': call.receiverNumber,
      'callToken': call.callToken
    };
