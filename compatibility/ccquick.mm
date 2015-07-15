/* Compitable With CCQuick */

#import "ccquick.h"

#define kCCQuickDylibPath "/Library/MobileSubstrate/DynamicLibraries/CCQuick.dylib"
#define kCCQuickSettingsFilePath "/var/mobile/Library/Preferences/com.cunstuck.CCQuick.plist"

BOOL ccquickIsInstalled() {
    return [[NSFileManager defaultManager]fileExistsAtPath:@kCCQuickDylibPath];
}

BOOL ccquickChangeSpotlightToLockDeviceIsSet() {
    if ([[NSFileManager defaultManager] fileExistsAtPath:@kCCQuickSettingsFilePath]) {
        if ([[[NSDictionary dictionaryWithContentsOfFile:@kCCQuickSettingsFilePath] objectForKey:@"isSpotLock"] boolValue]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}
