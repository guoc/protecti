#ifndef _states_h
#define _states_h

#import <notify.h>
#define kPreferencesStatePath "/var/mobile/Library/Preferences/com.gviridis.protectiplus.state.plist"
#define EnableProtectiPlus notify_post("com.gviridis.protectiplus/Enable")
#define DisableProtectiPlus notify_post("com.gviridis.protectiplus/Disable")
#define ToggleProtectiPlus notify_post("com.gviridis.protectiplus/Toggle")

id getStateObjectForKey(id key) {
    NSMutableDictionary *stateDict = [NSMutableDictionary dictionaryWithContentsOfFile:@kPreferencesStatePath];
    return [stateDict objectForKey:key];
}

void saveStateObjectForKey(id stateObj, id key) {
    NSMutableDictionary *stateDict = [NSMutableDictionary dictionaryWithContentsOfFile:@kPreferencesStatePath];
    if (!stateDict)
        stateDict = [NSMutableDictionary dictionary];
    [stateDict setObject:(stateObj?:[NSNull null]) forKey:key];
    [stateDict writeToFile:@kPreferencesStatePath atomically:YES];
}

#endif
