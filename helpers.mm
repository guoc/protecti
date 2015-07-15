#import "helpers.h"

#include <substrate.h>

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
    SBIconModel *iconModel = [[objc_getClass("SBIconViewMap") homescreenMap] iconModel];
    NSSet *allApplicationIcons = [iconModel _applicationIcons];
    for (SBApplicationIcon *icon in allApplicationIcons) {
        [icon noteBadgeDidChange];
    }
}

void removeProtectedOrHiddenAppsInAppSwitcher() {
    NSArray *displayLayouts = [[objc_getClass("SBAppSwitcherModel") sharedInstance] _recentsFromPrefs];
    for (SBDisplayLayout *displayLayout in displayLayouts) {
        SBDisplayItem *displayItem = displayLayout.displayItems[0];
        NSString *appIdentifier = displayItem.displayIdentifier;
        if (appIdentifierIsInProtectedAppsList(appIdentifier) || appIdentifierIsInHiddenAppsList(appIdentifier)) {
            [(SBAppSwitcherModel *)[objc_getClass("SBAppSwitcherModel") sharedInstance] remove: displayLayout];
        }
    }
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
    SBApplication *foregroundApp = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithDisplayIdentifier:appID];
    int foregroundAppPID = [foregroundApp pid];
    if (foregroundAppPID) {
        system([[@"kill -9 " stringByAppendingFormat:@"%d", foregroundAppPID] cStringUsingEncoding:NSASCIIStringEncoding]);
    } else {

    }
}

BOOL appIdentifierIsInProtectedAppsList(NSString *appIdentifier) {
    return [[PIPreferences.sharedPreferences objectForKey:[@"ProtectedApp_" stringByAppendingString:(appIdentifier?:@"")]] boolValue];
}

BOOL appIdentifierIsInHiddenAppsList(NSString *appIdentifier) {
    return [[PIPreferences.sharedPreferences objectForKey:[@"HiddenApp_" stringByAppendingString:(appIdentifier?:@"")]] boolValue];
}
