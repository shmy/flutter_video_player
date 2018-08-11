#import "PlayerViewController.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>

@interface PlayerViewController ()
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *quitBtn;
@property (nonatomic, strong) NSArray <NSURL *>*assetURLs;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];

    [self.view addSubview:self.containerView];
    
    // [self.containerView addSubview:self.playBtn];
    [self.view addSubview:self.quitBtn];

    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
    // 直接全屏
    // [self.player enterFullScreen:YES animated:YES];
    
    self.assetURLs = @[[NSURL URLWithString:self.url]];
    
    self.player.assetURLs = self.assetURLs;

    [self.player playTheIndex:0];
    [self.controlView showTitle:self.name coverURLString:self.pic fullScreenMode:ZFFullScreenModeLandscape];

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

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame) + 100;
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = w*9/16;
    self.containerView.frame = CGRectMake(x, y, w, h);
    
    // w = 44;
    // h = w;
    // x = (CGRectGetWidth(self.containerView.frame)-w)/2;
    // y = (CGRectGetHeight(self.containerView.frame)-h)/2;
    // self.playBtn.frame = CGRectMake(x, y, w, h);
    
    w = 160;
    h = 30;
    x = (CGRectGetWidth(self.view.frame)-w)/2;
    y = CGRectGetMaxY(self.containerView.frame)+50;
    self.quitBtn.frame = CGRectMake(x, y, w, h);
}

- (void)quitClick:(UIButton *)sender {
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
    }
    return _controlView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor blackColor];
    }
    return _containerView;
}

// - (UIButton *)playBtn {
//     if (!_playBtn) {
//         _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//         [_playBtn setImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
//         [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
//     }
//     return _playBtn;
// }

- (UIButton *)quitBtn {
    if (!_quitBtn) {
        _quitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_quitBtn setTitle:@"点击退出播放器" forState:UIControlStateNormal];
        [_quitBtn addTarget:self action:@selector(quitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitBtn;
}

@end