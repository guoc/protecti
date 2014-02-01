#import <libactivator/libactivator.h>
#import "../states.h"
#import <objc/runtime.h>
#include <dlfcn.h>

@interface ProtectiLAListener : NSObject<LAListener> { }
@end
 
@implementation ProtectiLAListener
 
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
    [[LAActivator sharedInstance] registerListener:[self new] forName:@"com.gviridis.protectiplustoggleforactivator"];
}

@end

