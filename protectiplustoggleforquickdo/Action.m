#import <libquickdo/libquickdo.h>
#import "../states.h"
#import <objc/runtime.h>
#include <dlfcn.h>

@interface ProtectiQDAction : NSObject<QDAction> { }
@end
 
@implementation ProtectiQDAction
 
- (void)quickdo:(LibQuickDo *)quickdo handleAction:(QDGesture *)gesture
{
    ToggleProtectiPlus;
    [gesture setHandled:YES]; // To prevent the default OS implementation
}
 
+ (void)load
{
    [[LibQuickDo sharedInstance] addAction:[self new] name:@"com.gviridis.protectiplustoggleforquickdo"];
}

@end

