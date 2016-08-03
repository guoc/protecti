#import "helpers.h"

#include <substrate.h>

#import "version.h"
#include "prefs.h"

#import "PIPreferences.h"

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <AudioToolBox/AudioServices.h>
#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBApplicationController.h>
#import <SpringBoard/SBNotificationCenterController.h>
#import <SpringBoard/SBNotificationsAllModeViewController.h>
#import <SpringBoard/SBBulletinViewController.h>
#import <SpringBoard/SBIconController.h>
#import <SpringBoard/SBIconModel.h>
#import <SpringBoard/SBIconViewMap.h>
#import <SpringBoard/SBApplicationIcon.h>
#import <SpringBoard/SBDisplayLayout.h>
#import <SpringBoard/SBAppSwitcherModel.h>
#import <SpringBoard/SBUserAgent.h>
#import <SpringBoard/SBUIController.h>
#import <SpringBoard/SBDisplayItem.h>

static BOOL global_NoVibrateWhenEnable = NO;

void refreshNotificationCenter() {
    if (IS_IOS_OR_NEWER(iOS_9_0)) {
        // TODO crash on iOS 9, so just return.
        return;
    }
    SBNotificationCenterViewController *viewController = (SBNotificationCenterViewController *)[[objc_getClass("SBNotificationCenterController") sharedInstance] viewController];
    SBNotificationsAllModeViewController *allModeViewController = MSHookIvar<SBNotificationsAllModeViewController *>(viewController, "_allModeViewController");
    if (allModeViewController) {
        SBBulletinViewController *allModeBulletinViewController = MSHookIvar<SBBulletinViewController *>(allModeViewController, "_bulletinViewController");
        if (allModeBulletinViewController) {
            [allModeBulletinViewController setTableViewNeedsReload];
        }
    }
}

void iconsVisibilityChanged() {
    SBIconModel *iconModel = [(SBIconController *)[objc_getClass("SBIconController") sharedInstance] model];
    NSSet *_hiddenIconTags = MSHookIvar<NSSet *>(iconModel, "_hiddenIconTags");
    NSSet *_visibleIconTags = MSHookIvar<NSSet *>(iconModel, "_visibleIconTags");
    if (_hiddenIconTags!=nil && _visibleIconTags!=nil) {
        NSMutableSet *hiddenIconTags = [NSMutableSet setWithSet:_hiddenIconTags];
        NSMutableSet *visibleIconTags = [NSMutableSet setWithSet:_visibleIconTags];
        [iconModel setVisibilityOfIconsWithVisibleTags:visibleIconTags hiddenTags:hiddenIconTags];
        [iconModel layout];
    }
}

void vibrateIfNecessary() {
    if (Vibrate_IsEnabled && !global_NoVibrateWhenEnable)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

void updateIconBadgeView() {
    SBIconViewMap *iconViewMap = [UIDevice.currentDevice.systemVersion floatValue] >= 9.2 ?
                                 [[NSClassFromString(@"SBIconController") sharedInstance] homescreenIconViewMap] :
                                 [objc_getClass("SBIconViewMap") homescreenMap];
    SBIconModel *iconModel = [iconViewMap iconModel];
    NSSet *allApplicationIcons = [iconModel _applicationIcons];
    for (SBApplicationIcon *icon in allApplicationIcons) {
        [icon noteBadgeDidChange];
    }
}

void removeProtectedOrHiddenAppsInAppSwitcher() {
    SBAppSwitcherModel *appSwitcherModel = (SBAppSwitcherModel *)[objc_getClass("SBAppSwitcherModel") sharedInstance];
    // recents is an array of SBDisplayLayout in iOS 8, or an array of SBDisplayItem in iOS 9
    NSArray *recents = [appSwitcherModel _recentsFromPrefs];

    for (id recent in recents) {
        SBDisplayItem *displayItem = nil;
        if (IS_IOS_OR_NEWER(iOS_9_0)) {
            displayItem = recent;
        } else {
            displayItem = ((SBDisplayLayout *)recent).displayItems[0];
        }
        NSString *appIdentifier = displayItem.displayIdentifier;
        if (appIdentifierIsInProtectedAppsList(appIdentifier) || appIdentifierIsInHiddenAppsList(appIdentifier)) {
            [appSwitcherModel remove: recent];
        }
    }
    [appSwitcherModel _saveRecents];
}

void killApplicationUnderLockScreenIfNecessary() {
    NSString *foregroundAppID = [[objc_getClass("SBUserAgent") sharedUserAgent] foregroundApplicationDisplayID];
    if (appIdentifierIsInProtectedAppsList(foregroundAppID)) {
        killApplicationByAppID(foregroundAppID);
    } else {

    }
}

void exitForegroundApplicationIfNecessary() {
    NSString *foregroundAppID = [[objc_getClass("SBUserAgent") sharedUserAgent] foregroundApplicationDisplayID];
    if (foregroundAppID && appIdentifierIsInProtectedAppsList(foregroundAppID)) {
        [[objc_getClass("SBUIController") sharedInstance] clickedMenuButton];
//        [(SBUIController *)[%c(SBUIController) sharedInstance] _handleButtonEventToSuspendDisplays:YES displayWasSuspendedOut:NULL];
        if (![foregroundAppID isEqualToString:@"com.saurik.Cydia"]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                sleep(1);
                killApplicationByAppID(foregroundAppID);
            });
        }
    }
}

void killApplicationByAppID(NSString *appID) {
    SBApplication *foregroundApp = nil;
    if (IS_IOS_OR_NEWER(iOS_9_0)) {
        foregroundApp = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithBundleIdentifier:appID];
    } else {
        foregroundApp = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithDisplayIdentifier:appID];
    }
    int foregroundAppPID = [foregroundApp pid];
    if (foregroundAppPID) {
        system([[@"kill -9 " stringByAppendingFormat:@"%d", foregroundAppPID] cStringUsingEncoding:NSASCIIStringEncoding]);
    } else {

    }
}

void updateSpotlight_ios9() {
    if (!IS_IOS_OR_NEWER(iOS_9_0)) {
        return;
    }
    [[objc_getClass("SPUISearchModel") sharedInstance ] performSelector: @selector(postSearchAgentClearedResultsToDelegate)];
    [[objc_getClass("SPUISearchViewController") sharedInstance ] performSelector: @selector(_updateTableContents)];
}

BOOL appIdentifierIsInProtectedAppsList(NSString *appIdentifier) {
    return [[PIPreferences.sharedPreferences objectForKey:[@"ProtectedApp_" stringByAppendingString:(appIdentifier?:@"")]] boolValue];
}

BOOL appIdentifierIsInHiddenAppsList(NSString *appIdentifier) {
    return [[PIPreferences.sharedPreferences objectForKey:[@"HiddenApp_" stringByAppendingString:(appIdentifier?:@"")]] boolValue];
}

/************* Compatible with Tage **************/

#define TAGE_DOMAIN "com.clezz.tage"
#define TAGE_PREF(method, key, defaultValue) (!CFPreferencesCopyAppValue(CFSTR(key), CFSTR(TAGE_DOMAIN)) ? (defaultValue) : [(id)CFPreferencesCopyAppValue(CFSTR(key), CFSTR(TAGE_DOMAIN)) method])

NSString *const TageDylibPath = @"/Library/MobileSubstrate/DynamicLibraries/Tage.dylib";
int const tagePrefsSwipeSideEnabledDefaultValue = 1;
static int tagePrefsSwipeSideEnabled = -1;
static BOOL tagePrefsSwipeSideEnabledCaching = NO;

BOOL tageIsInstalled() {
    return [[NSFileManager defaultManager]fileExistsAtPath:TageDylibPath];
}

int readTagePrefsSwipeSideEnabled() {
    CFPreferencesAppSynchronize(CFSTR(TAGE_DOMAIN));
    return TAGE_PREF(intValue, "SwipeSideEnabled", tagePrefsSwipeSideEnabledDefaultValue);
}

void writeTagePrefsSwipeSideEnabled(int value) {
    NSNumber *number = [NSNumber numberWithInt: value];
    CFPreferencesSetAppValue (CFSTR("SwipeSideEnabled"), number, CFSTR(TAGE_DOMAIN));
    CFPreferencesAppSynchronize(CFSTR(TAGE_DOMAIN));
    notify_post("com.clezz.tage.preferences-changed");
}

void cacheAndModifyTagePrefsSwipeSideEnabledIfNecessary() {
    if (!tagePrefsSwipeSideEnabledCaching && tageIsInstalled()) {
        tagePrefsSwipeSideEnabled = readTagePrefsSwipeSideEnabled();
        tagePrefsSwipeSideEnabledCaching = YES;
        writeTagePrefsSwipeSideEnabled(0);
    }
}

void restoreTagePrefsSwipeSideEnabledIfNecessaryWithDelay(CGFloat delay) {
    if (tagePrefsSwipeSideEnabledCaching && tageIsInstalled()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if (tagePrefsSwipeSideEnabledCaching) {
                tagePrefsSwipeSideEnabledCaching = NO;
                writeTagePrefsSwipeSideEnabled(tagePrefsSwipeSideEnabled);
            }
        });
    }
}
