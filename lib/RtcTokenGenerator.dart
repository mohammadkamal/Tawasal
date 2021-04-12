import 'package:flutter/services.dart';
import 'package:tawasal/AppSettings.dart';

class RtcTokenGenerator {
  static const platform = const MethodChannel('samples.flutter.dev/agora');
  static Future<String> getAgoraToken(String channelName, int userId, int expirationTimeInSeconds) async {
    String token;

    try {
      //String appId, String appCertificate, String channelName, int uid, int expirationTimeInSeconds
      final String result =
          await platform.invokeMethod('getAgoraToken', <String, dynamic>{
        'appId': appID,
        'appCertificate': appCertificate,
        'channelName': channelName,
        'uid': userId,
        'expirationTimeInSeconds': expirationTimeInSeconds
      });
      token = result;
    } on PlatformException catch (e) {
      token = e.message;
    }
    return token;
  }
}
