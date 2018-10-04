#import "VideoPlayerPlugin.h"
#import "PlayerViewController.h"

@implementation VideoPlayerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"tech.shmy.plugins/video_player/method_channel"
            binaryMessenger:[registrar messenger]];

  VideoPlayerPlugin *instance = [VideoPlayerPlugin new];
//  instance.hostViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  instance.hostViewController = (UIViewController *)registrar.messenger;
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"play" isEqualToString:call.method]) {
    NSString *name = call.arguments[@"name"];
    NSString *url = call.arguments[@"url"];
    NSString *pic = call.arguments[@"pic"];
    
    PlayerViewController *playViewController = [[PlayerViewController alloc] init];
    
    playViewController.name = name;
    playViewController.url = url;
    playViewController.pic = pic;
    
    [self.hostViewController presentViewController:playViewController animated:YES completion:nil];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
