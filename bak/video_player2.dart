import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VideoPlayer {
  static const MethodChannel _channel = const MethodChannel('video_player');
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
    int kernel = 0,
    bool enableMediaCodec = true,
    Color primaryColor = Colors.blue,
    Color titleColor = Colors.white,
  }) async {
    url = Uri.encodeFull(url);
    pic = Uri.encodeFull(pic);
    Map args = {
      "name": name,
      "url": url,
      "pic": pic,
      "kernel": kernel,
      "enableMediaCodec": enableMediaCodec,
    };
    if (Platform.isIOS) {
      // IOS主题
      args["iosOnly"] = {
        "primaryColor": {
          "red": primaryColor.red,
          "green": primaryColor.green,
          "blue": primaryColor.blue,
          "alpha": primaryColor.alpha,
        },
        "titleColor": {
          "red": titleColor.red,
          "green": titleColor.green,
          "blue": titleColor.blue,
          "alpha": titleColor.alpha,
        }
      };
    }
    await _channel.invokeMethod("play", args);
  }
}
