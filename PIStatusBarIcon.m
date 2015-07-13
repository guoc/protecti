#import "PIStatusBarIcon.h"

@implementation PIStatusBarIcon
@synthesize statusBarItem = _statusBarItem;
+ (PIStatusBarIcon *)sharedInstance {
  static PIStatusBarIcon* PIStatusBarIcon_sharedInst = nil;
  @synchronized(self) {
    if (PIStatusBarIcon_sharedInst == nil) {
        PIStatusBarIcon_sharedInst = [[PIStatusBarIcon alloc] init];
    }
  }
  return PIStatusBarIcon_sharedInst;
}

- (PIStatusBarIcon *)init {
	[self performSelector:@selector(delayedInit) withObject:nil afterDelay:0];
    return self;
}

- (void)delayedInit{
  self.statusBarItem =  [[NSClassFromString(@"LSStatusBarItem") alloc] initWithIdentifier: @"com.gviridis.protectiplus" alignment: StatusBarAlignmentLeft];
  _statusBarItem.imageName = @"protecti";
}

- (void)showIcon {
    self.statusBarItem.visible = YES;
}

- (void)hideIcon {
    self.statusBarItem.visible = NO;
}
@end
