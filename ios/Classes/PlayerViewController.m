#import "PlayerViewController.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>

@interface PlayerViewController ()
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) NSArray <NSURL *>*assetURLs;
@property CGRect bounds;
@property NSUInteger heightOfStatusbar;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    self.heightOfStatusbar = [[UIApplication sharedApplication] statusBarFrame].size.height;

    self.bounds = self.view.bounds;
    
    [self.view addSubview:self.containerView];
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
    
//    self.assetURLs = @[[NSURL URLWithString:@"https://vip888.kuyun99.com/20180811/jzl4IQbn/index.m3u8"]];
    self.assetURLs = @[[NSURL URLWithString:self.url]];
    
    self.player.assetURLs = self.assetURLs;
    
    [self.controlView showTitle:self.name coverURLString:self.pic fullScreenMode:ZFFullScreenModeLandscape];
    // 返回按钮变退出
    [self.controlView.landScapeControlView.backBtn addTarget:self action:@selector(quitAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    // 直接横屏
    [self.player enterPortraitFullScreen:YES animated:YES];
    
    [self.player playTheIndex:0];
//    [self.player seekToTime:30 * 60 completionHandler:nil]; // TODO 跳转到指定时间播放
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.player.currentPlayerManager.isPreparedToPlay) {
        [self.player addDeviceOrientationObserver];
        if (self.player.isPauseByEvent) {
            self.player.pauseByEvent = NO;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.player.currentPlayerManager.isPreparedToPlay) {
        [self.player removeDeviceOrientationObserver];
        if (self.player.currentPlayerManager.isPlaying) {
            self.player.pauseByEvent = YES;
        }
    }
}

- (void)quitAction:(UIButton *)sender {
    [self.player stop];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        //        _controlView.backgroundColor = [UIColor blackColor];
    }
    return _controlView;
}

- (UIView *)containerView {
    if (!_containerView) {
        
        CGFloat h = self.bounds.size.width * 9 / 16;
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.heightOfStatusbar, self.bounds.size.width, h)];
        _containerView.backgroundColor = [UIColor blackColor];
    }
    return _containerView;
}

@end
