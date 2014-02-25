#import <libquickdo/libquickdo.h>
#import "../states.h"
#import <objc/runtime.h>
#include <dlfcn.h>

@interface ProtectiQDAction_Toggle : NSObject<QDAction> { }
@end
 
@implementation ProtectiQDAction_Toggle
 
- (void)quickdo:(LibQuickDo *)quickdo handleAction:(QDGesture *)gesture
{
    ToggleProtectiPlus;
    [gesture setHandled:YES]; // To prevent the default OS implementation
}
 
+ (void)load
{
    [[LibQuickDo sharedInstance] addAction:[self new] name:@"com.gviridis.protectiplustoggleforquickdo_toggle"];
}

@end



@interface ProtectiQDAction_Enable : NSObject<QDAction> { }
@end

@implementation ProtectiQDAction_Enable

- (void)quickdo:(LibQuickDo *)quickdo handleAction:(QDGesture *)gesture
{
    EnableProtectiPlus;
    [gesture setHandled:YES]; // To prevent the default OS implementation
}

+ (void)load
{
    [[LibQuickDo sharedInstance] addAction:[self new] name:@"com.gviridis.protectiplustoggleforquickdo_enable"];
}

@end



@interface ProtectiQDAction_Disable : NSObject<QDAction> { }
@end

@implementation ProtectiQDAction_Disable

- (void)quickdo:(LibQuickDo *)quickdo handleAction:(QDGesture *)gesture
{
    DisableProtectiPlus;
    [gesture setHandled:YES]; // To prevent the default OS implementation
}

+ (void)load
{
    [[LibQuickDo sharedInstance] addAction:[self new] name:@"com.gviridis.protectiplustoggleforquickdo_disable"];
}

@end

