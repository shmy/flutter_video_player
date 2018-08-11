#import "PlayerViewController.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>

@interface PlayerViewController ()
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@property (nonatomic, strong) NSArray <NSURL *>*assetURLs;
@property UIColor *parsedPrimaryColor;
@property UIColor *parsedTitleColor;
@property UINavigationItem *navItem;

@property CGRect bounds;
@property NSUInteger heightOfStatusbar;
@property NSUInteger heightOfNavigationBar;
@property NSUInteger heightOfAll;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.parsedPrimaryColor = [UIColor colorWithRed:[self.primaryColor[@"red"] intValue]/255.0 green:[self.primaryColor[@"green"] intValue]/255.0 blue:[self.primaryColor[@"blue"] intValue]/255.0 alpha:[self.primaryColor[@"alpha"] intValue]]; // 设置颜色
    // 获取文字颜色
    self.parsedTitleColor = [UIColor colorWithRed:[self.titleColor[@"red"] intValue]/255.0 green:[self.titleColor[@"green"] intValue]/255.0 blue:[self.titleColor[@"blue"] intValue]/255.0 alpha:[self.titleColor[@"alpha"] intValue]]; // 设置颜色
    
    self.view.backgroundColor = self.parsedPrimaryColor;
    
    self.heightOfStatusbar = [[UIApplication sharedApplication] statusBarFrame].size.height;
    self.heightOfNavigationBar = 44;
    self.heightOfAll = self.heightOfStatusbar + self.heightOfNavigationBar;
    self.bounds = self.view.bounds;
    
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.bodyView];
    
    [self.bodyView addSubview:self.containerView];

    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
    
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

- (void)quitAction:(UIButton *)sender {
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

// 构建导航栏
-(UINavigationBar *) navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, self.heightOfStatusbar, self.bounds.size.width, self.heightOfNavigationBar)];
        
        _navigationBar.barStyle = UIBarStyleDefault;
        _navigationBar.translucent = false;
        _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _navigationBar.barTintColor = self.parsedPrimaryColor; // 设置颜色
        _navigationBar.tintColor = self.parsedTitleColor;
        _navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName: self.parsedTitleColor };
        
        // navigationBar button items 用系统图标
        UIBarButtonItem *quitItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(quitAction:)];
//        UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction:)];
        
        
        // UINavigationItem
        self.navItem = [[UINavigationItem alloc] initWithTitle:self.name];
        self.navItem.leftBarButtonItem = quitItem;
//        self.navItem.rightBarButtonItem = refreshItem;
        [_navigationBar pushNavigationItem:self.navItem animated:NO];
        
    }
    return _navigationBar;
}
- (UIView *)bodyView {
    if (!_bodyView) {
        _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.heightOfAll, self.bounds.size.width, self.bounds.size.height - self.heightOfAll)];
        _bodyView.backgroundColor = [UIColor whiteColor];
    }
    return _bodyView;
}
- (UIView *)containerView {
    if (!_containerView) {
        
        CGFloat h = self.bounds.size.width * 9 / 16;
        CGFloat y = (self.bounds.size.height - self.heightOfAll) / 2 - h / 2;
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.bounds.size.width, h)];
        _containerView.backgroundColor = [UIColor blackColor];
    }
    return _containerView;
}

@end
