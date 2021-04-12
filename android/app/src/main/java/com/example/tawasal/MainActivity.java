package com.example.tawasal;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import com.example.tawasal.media.RtcTokenBuilder;
import com.example.tawasal.media.RtcTokenBuilder.Role;

public class MainActivity extends FlutterActivity {
    private static final String channel = "samples.flutter.dev/agora";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine FlutterEngine) {
        super.configureFlutterEngine(FlutterEngine);
        new MethodChannel(FlutterEngine.getDartExecutor().getBinaryMessenger(), channel)
                .setMethodCallHandler((call, result) -> {
                    String appId = call.argument("appId");
                    String appCertificate = call.argument("appCertificate");
                    String channelName = call.argument("channelName");
                    int uid = call.argument("uid");
                    int expirationTimeInSeconds = call.argument("expirationTimeInSeconds");

                    if (call.method.equals("getAgoraToken")) {
                        String token = getAgoraToken(appId, appCertificate, channelName, uid, expirationTimeInSeconds);
                        result.success(token);
                    } else {
                        result.notImplemented();
                    }
                });
    }

    private String getAgoraToken(String appId, String appCertificate, String channelName, int uid,
            int expirationTimeInSeconds) {
        // String appId = "5a30ef7ec3bf4f67aa60e6b730059f6e";
        // String appCertificate = "e1bdb01372cb4acd8d7800c3454eb43b";
        // String userId = "1129022635";
        // int expireTimestamp = 0;

        RtcTokenBuilder token = new RtcTokenBuilder();
        int timestamp = (int) (System.currentTimeMillis() / 1000 + expirationTimeInSeconds);
        String result = "Failed";
        try {
            result = token.buildTokenWithUid(appId, appCertificate, channelName, uid, Role.Role_Publisher, timestamp);
        } catch (Exception e) {
        }

        return result;
    }

}
