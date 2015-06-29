#import <libactivator/libactivator.h>
#import "../states.h"
#import <objc/runtime.h>
#include <dlfcn.h>

@interface ProtectiLAListener_Toggle : NSObject<LAListener> { }
@end

@implementation ProtectiLAListener_Toggle

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
    ToggleProtectiPlus;
    [event setHandled:YES]; // To prevent the default OS implementation
}

- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event
{
    // Dismiss your plugin
}

+ (void)load
{
    [[LAActivator sharedInstance] registerListener:[self new] forName:@"com.gviridis.protectiplustoggleforactivator_toggle"];
}

@end



@interface ProtectiLAListener_Enable : NSObject<LAListener> { }
@end

@implementation ProtectiLAListener_Enable

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
    EnableProtectiPlus;
    [event setHandled:YES]; // To prevent the default OS implementation
}

- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event
{
    // Dismiss your plugin
}

+ (void)load
{
    [[LAActivator sharedInstance] registerListener:[self new] forName:@"com.gviridis.protectiplustoggleforactivator_enable"];
}

@end



@interface ProtectiLAListener_Disable : NSObject<LAListener> { }
@end

@implementation ProtectiLAListener_Disable

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
    DisableProtectiPlus;
    [event setHandled:YES]; // To prevent the default OS implementation
}

- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event
{
    // Dismiss your plugin
}

+ (void)load
{
    [[LAActivator sharedInstance] registerListener:[self new] forName:@"com.gviridis.protectiplustoggleforactivator_disable"];
}

@end
