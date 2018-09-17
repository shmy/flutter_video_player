import 'dart:async';
import 'package:flutter/services.dart';

class VideoPlayer {
  static const CHANNEL_NAME = "tech.shmy.plugins/video_player/";
  static const MethodChannel methodChannel = const MethodChannel(CHANNEL_NAME + "method_channel");
  static const EventChannel eventChannel = const EventChannel(CHANNEL_NAME + "event_channel");
  // static StreamSubscription eventSubscription = null;
  static init() {
    eventChannel.receiveBroadcastStream().listen((data) {
      print("--------------------");
      print(data);
    });
  }
  /**
   * 设置了视频的播放类型
   * IJKPLAYER = 0; 默认IJK
   * IJKEXOPLAYER2 = 2;EXOPlayer2
   * SYSTEMPLAYER = 4;系统播放器
   */
  // enableMediaCodec 是否启用硬件加速
  static Future<void> play(
    String name,
    String url,
    String pic, {
      String id = "",
      String tag = "",
      String append = "",
      int seek = 0,
      int kernel = 0,
      bool enableMediaCodec = true,
  }) async {
    url = Uri.encodeFull(url);
    pic = Uri.encodeFull(pic);
    Map args = {
      "name": name,
      "url": url,
      "pic": pic,
      "id": id,
      "tag": tag,
      "append": append,
      "seek": seek,
      "kernel": kernel,
      "enableMediaCodec": enableMediaCodec,
    };
    await methodChannel.invokeMethod("play", args);
  }
}
