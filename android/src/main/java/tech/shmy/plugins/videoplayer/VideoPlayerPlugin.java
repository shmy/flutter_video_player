package tech.shmy.plugins.videoplayer;


import android.content.Context;
import android.content.Intent;

//import android.os.Bundle;


//import com.shuyu.gsyvideoplayer.GSYVideoManager;
//
import io.flutter.app.FlutterActivity;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** VideoPlayerPlugin */
public class VideoPlayerPlugin implements MethodCallHandler {
  private FlutterActivity activity;

  public VideoPlayerPlugin(FlutterActivity activity) {
    this.activity = activity;
  }
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "video_player");
    channel.setMethodCallHandler(new VideoPlayerPlugin((FlutterActivity) registrar.activity()));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {

    String name = call.argument("name").toString();
    String url = call.argument("url").toString();
    String pic = call.argument("pic").toString();
    int kernel = call.argument("kernel"); // 播放内核 1 IJK, 2 EXO2
    boolean enableMediaCodec = call.argument("enableMediaCodec"); // 是否启用硬件加速
    if (call.method.equals("play")) {
      // 直接播放
      playWithGSY(name, url, pic, kernel, enableMediaCodec);
    }
    // TODO 清除缓存
//    else if (call.method.equals("clean")) {
//      // 清除缓存
//      GSYVideoManager.instance().clearAllDefaultCache(this.context);
//    }
    else {
      result.notImplemented();
    }
  }

  private void playWithGSY (String name, String url, String pic, int kernel, boolean enableMediaCodec) {
    Intent intent = new Intent(this.activity, PlayerActivity.class);
    intent.putExtra("name", name);
    intent.putExtra("url", url);
    intent.putExtra("pic", pic);
    intent.putExtra("kernel", kernel);
    intent.putExtra("enableHardwareAcceleration", enableMediaCodec);
    this.activity.startActivity(intent);

  }

}
