package tech.shmy.plugins.videoplayer;


import android.content.Intent;


import io.flutter.app.FlutterActivity;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;

/** VideoPlayerPlugin */
public class VideoPlayerPlugin implements MethodCallHandler, StreamHandler {
  public FlutterActivity activity;
  public static final String CHANNEL_NAME = "tech.shmy.plugins/video_player/";

  public VideoPlayerPlugin(FlutterActivity activity) {
    this.activity = activity;
  }
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel methodChannel = new MethodChannel(registrar.messenger(), CHANNEL_NAME + "method_channel");
    final EventChannel eventChannel = new EventChannel(registrar.messenger(), CHANNEL_NAME + "event_channel");
    final VideoPlayerPlugin instance = new VideoPlayerPlugin((FlutterActivity) registrar.activity());
    eventChannel.setStreamHandler(instance);
    methodChannel.setMethodCallHandler(instance);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    String name = call.argument("name").toString(); // 影片名称
    String url = call.argument("url").toString();   // 播放地址
    String pic = call.argument("pic").toString();   // 预览图
    String id = call.argument("id").toString(); // 影片id
    String tag = call.argument("tag").toString(); // 影片标签
    String append = call.argument("append").toString(); // 播放显示的后缀
    int seek = call.argument("seek"); // 开始播放时间
    int kernel = call.argument("kernel"); // 播放内核 1 IJK, 2 EXO2
    boolean enableMediaCodec = call.argument("enableMediaCodec"); // 是否启用硬件加速
    if (call.method.equals("play")) {
      // 直接播放
      playWithGSY(name, url, pic, id, tag, append, seek, kernel, enableMediaCodec);
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

    @Override
    public void onListen(Object arguments, EventSink events) {
      PlayerActivity.eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        PlayerActivity.eventSink = null;
    }

    private void playWithGSY (String name,
                              String url,
                              String pic,
                              String id,
                              String tag,
                              String append,
                              int seek,
                              int kernel,
                              boolean enableMediaCodec) {
      Intent intent = new Intent(this.activity, PlayerActivity.class);
      intent.putExtra("name", name);
      intent.putExtra("url", url);
      intent.putExtra("pic", pic);
      intent.putExtra("id", id);
      intent.putExtra("tag", tag);
      intent.putExtra("append", append);
      intent.putExtra("seek", seek);
      intent.putExtra("kernel", kernel);
      intent.putExtra("enableHardwareAcceleration", enableMediaCodec);
      this.activity.startActivity(intent);

  }

}
