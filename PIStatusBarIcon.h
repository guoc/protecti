#import <libstatusbar/LSStatusBarItem.h>

@interface PIStatusBarIcon : NSObject

+ (void)addStatusBarItemIfNecessary;
+ (void)removeStatusBarItem;

@property (nonatomic, retain) LSStatusBarItem *statusBarItem;
+ (PIStatusBarIcon *)sharedInstance;
- (PIStatusBarIcon *)init;
- (void)delayedInit;
- (void)showIcon;
- (void)hideIcon;
@end
