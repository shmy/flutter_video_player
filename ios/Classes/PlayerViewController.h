#import <UIKit/UIKit.h>
@interface PlayerViewController : UIViewController
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *pic;

// 主题颜色
@property(nonatomic, copy) NSDictionary *primaryColor;
@property(nonatomic, copy) NSDictionary *titleColor;

@end
