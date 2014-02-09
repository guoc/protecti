#import <notify.h>
#include <substrate.h>
#include <time.h>
#import <ISIconSupport.h>
#include "states.h"
#include "prefs.h"

#import "WelcomeAlertDelegate.h"

#import <AudioToolBox/AudioServices.h>
#import <CoreFoundation/CFUserNotification.h>
#import <CoreFoundation/CFRunLoop.h>

#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBApplicationIcon.h>
#import <SpringBoard/SBDefaultIconModelStore.h>
#import <SpringBoard/SBIconModel.h>
#import <SpringBoard/SBIconController.h>
#import <SpringBoard/SBUserAgent.h>
#import <SpringBoard/SBUIController.h>
#import <SpringBoard/SBApplicationController.h>
#import <SpringBoard/BBBulletin.h>
#import <SpringBoard/SBIcon.h>
#import <SpringBoard/SBIconView.h>
#import <SpringBoard/SBIconViewMap.h>
#import <SpringBoard/SBFolderIcon.h>
#import <SpringBoard/SBFolderIconBackgroundView.h>
#import <SpringBoard/SBLockScreenViewController.h>
#import <SpringBoard/PLApplicationCameraViewController.h>
#import <SpringBoard/SBLockScreenCameraController.h>
#import <SpringBoard/SBNotificationCenterController.h>
#import <SpringBoard/SBNotificationCenterViewController.h>
#import <SpringBoard/SBNotificationsAllModeViewController.h>
#import <SpringBoard/SBNotificationsMissedModeViewController.h>
#import <SpringBoard/SBBulletinViewController.h>

#import <ManagedConfiguration/MCPasscodeManager.h>
#import <SpringBoard/SBDeviceLockController.h>
#import <SpringBoard/SBLockScreenManager.h>
#import <SpringBoard/SBUserAgent.h>

#import <BulletinBoard/BBSound.h>
#import <BulletinBoard/BBAttachments.h>

#import <UIKit/UIApplication2.h>

#import <SpringBoard/SBBacklightController.h>


static NSDictionary *global_Preferences;

static NSMutableArray *global_AllApplicationIcons;

static BOOL global_LockScreenCameraNeedReInitSession = NO;
static BOOL global_NoVibrateWhenEnable = NO;

static id global_slfe;
static BOOL global_HalfSlideUnlock_SlideToRightRange;    // Init in SBLockScreenViewController - (void)lockScreenViewWillEndDraggingWithPercentScrolled:(float)arg1 percentScrolledVelocity:(float)arg2 targetScrollPercentage:(float)arg3
static BOOL global_OnceUnlockSuccessfully = NO;
static BOOL global_HalfSlideUnlock_DeviceHasSystemPasscodeSet;    //Get value in global_HalfSlideUnlock_DeviceHasSystemPasscodeSet SBDeviceLockController - (BOOL)deviceHasPasscodeSet
static void vibrateIfNecessary();

//

void refreshNotificationCenter();
void exitForegroundApplicationIfNecessary();
void killApplicationUnderLockScreenIfNecessary();
static void iconsVisibilityChanged();
void _enableProtectiPlus();
void enableProtectiPlus(CFNotificationCenterRef center,void *observer,CFStringRef name,const void *object,CFDictionaryRef userInfo);
void _disableProtectiPlusWithoutPassword();
void _disableProtectiPlus();
void disableProtectiPlus(CFNotificationCenterRef center,void *observer,CFStringRef name,const void *object,CFDictionaryRef userInfo);
void updatePreferences(CFNotificationCenterRef center,void *observer,CFStringRef name,const void *object,CFDictionaryRef userInfo);
BOOL appIdentifierIsInProtectedAppsList(NSString *appIdentifier);
BOOL appIdentifierIsInHiddenAppsList(NSString *appIdentifier);

void addStatusBarItemIfNecessary();
//void removeStatusBarItemIfNecessary();
void addStatusBarItemIfNecessaryNoMatterGlobalEnable();
void removeStatusBarItemIfNecessaryNoMatterGlobalEnable();


void turnOnBacklightIfNecessary();
void vibrateNotificationIfNecessary();
//

static BOOL global_Enable;
static NSDictionary *global_IconState;
static NSDate *global_EnableTime;
static NSMutableArray *global_PendingNotifications;



/****************** Password *********************************/

@interface PasswordAlertDelegate : NSObject <UITextFieldDelegate, UIAlertViewDelegate>
@property (retain) UIAlertView *alertView;
- (void)showAlert;

//- (id)init;
//- (void)dealloc;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
@end



#define LOCAL(key) [bundle localizedStringForKey:key value:key table:nil]

//extern NSDictionary *global_Preferences;
//void _disableProtectiPlusWithoutPassword();

@implementation PasswordAlertDelegate

@synthesize alertView = _alertView;

- (void)showAlert {
    NSBundle *bundle = [NSBundle bundleWithPath:@"/Library/PreferenceBundles/ProtectiPlusSettings.bundle"];
    _alertView = [[UIAlertView alloc] initWithTitle:LOCAL(@"PASSWORD_ALERT_TITLE") message:LOCAL(@"PASSWORD_ALERT_MESSAGE") delegate:self cancelButtonTitle:LOCAL(@"PASSWORD_ALERT_DISMISS") otherButtonTitles:nil];
    _alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    
    NSString * password = GetValueOf_Password;
    if (![[password stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] isEqualToString:@""])
    {   //说明包含非数字 使用默认键盘
        [[_alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
    }
    else
    {
        [[_alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    }
    
    [[_alertView textFieldAtIndex:0] setDelegate:self];
    
    [_alertView show];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([[textField.text stringByReplacingCharactersInRange:range withString:string] isEqualToString:GetValueOf_Password])
    {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _disableProtectiPlusWithoutPassword();
//        });
        
        [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
        
        textField.text = @"";
    }
	return YES;
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index {
//    if (index == 1) {
//        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"prefs:root=Protecti+&path=Tutorial"]];
//    }
//}
@end

/************* End of Password *******************************/



void refreshNotificationCenter() {
    SBNotificationCenterViewController *viewController = [[%c(SBNotificationCenterController) sharedInstance] viewController];
    SBNotificationsAllModeViewController *allModeViewController = MSHookIvar<SBNotificationsAllModeViewController *>(viewController, "_allModeViewController");
    if (allModeViewController) {
        SBBulletinViewController *allModeBulletinViewController = MSHookIvar<SBBulletinViewController *>(allModeViewController, "_bulletinViewController");
        if (allModeBulletinViewController) {
            [allModeBulletinViewController setTableViewNeedsReload];
        }
    }
    SBNotificationsMissedModeViewController *missedModeViewController = MSHookIvar<SBNotificationsMissedModeViewController *>(viewController, "_missedModeViewController");
    if (missedModeViewController) {
        if (![missedModeViewController isKindOfClass:[%c(SBControlCenterController) class]]) {  // work around with multitaskinggestures
            SBBulletinViewController *missedModeBulletinViewController = MSHookIvar<SBBulletinViewController *>(missedModeViewController, "_bulletinViewController");
            if (missedModeBulletinViewController) {
                [missedModeBulletinViewController setTableViewNeedsReload];
            }
        }
    }
}

void killApplicationByAppID(NSString *appID) {
    SBApplication *foregroundApp = [[%c(SBApplicationController) sharedInstance] applicationWithDisplayIdentifier:appID];
    int foregroundAppPID = [foregroundApp pid];
    if (foregroundAppPID) {
        system([[@"kill -9 " stringByAppendingFormat:@"%d", foregroundAppPID] cStringUsingEncoding:NSASCIIStringEncoding]);
    } else {
        
    }
}

void exitForegroundApplicationIfNecessary() {
    NSString *foregroundAppID = [[%c(SBUserAgent) sharedUserAgent] foregroundApplicationDisplayID];
    if (foregroundAppID && appIdentifierIsInProtectedAppsList(foregroundAppID)) {
        [[%c(SBUIController) sharedInstance] clickedMenuButton];
//        [(SBUIController *)[%c(SBUIController) sharedInstance] _handleButtonEventToSuspendDisplays:YES displayWasSuspendedOut:NULL];
        if (![foregroundAppID isEqualToString:@"com.saurik.Cydia"]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                sleep(1);
                killApplicationByAppID(foregroundAppID);
            });
        }
    }
}

void killApplicationUnderLockScreenIfNecessary() {
    NSString *foregroundAppID = [[%c(SBUserAgent) sharedUserAgent] foregroundApplicationDisplayID];
    if (appIdentifierIsInProtectedAppsList(foregroundAppID)) {
        killApplicationByAppID(foregroundAppID);
    } else {
    
    }
}








/*

static CFUserNotificationRef userNotification;
static CFRunLoopSourceRef runLoopSource;

void welcomeCallback (CFUserNotificationRef userNotification, CFOptionFlags responseFlags) {
    if ((responseFlags & 0x3) == kCFUserNotificationDefaultResponse) {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"prefs:root=Protecti+&path=Tutorial"]];
    } else {
        
    }
    CFRunLoopRemoveSource(CFRunLoopGetMain(), runLoopSource, kCFRunLoopCommonModes);
    CFRelease(runLoopSource);
    CFRelease(userNotification);
}

%hook SpringBoard

- (void)_reportAppLaunchFinished {
    %orig;
    if (![getStateObjectForKey(@"firstInstall") boolValue]) {
            NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys: @"Thanks for installing Protecti+", kCFUserNotificationAlertHeaderKey, @"Click Tutorial for a simple setup now or find it in Settings app later.", kCFUserNotificationAlertMessageKey, @"Tutorial", kCFUserNotificationDefaultButtonTitleKey, @"Later", kCFUserNotificationAlternateButtonTitleKey, nil];
        userNotification = CFUserNotificationCreate(kCFAllocatorDefault, 0, kCFUserNotificationPlainAlertLevel, NULL, (CFDictionaryRef)fields);
        runLoopSource = CFUserNotificationCreateRunLoopSource(kCFAllocatorDefault, userNotification, welcomeCallback, 0);
        CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, kCFRunLoopCommonModes);
        saveStateObjectForKey([NSNumber numberWithBool:YES], @"firstInstall");
    }
}

%end

 */












static void updateIconBadgeView() {
    SBIconModel *iconModel = [[%c(SBIconViewMap) homescreenMap] iconModel];
    NSMutableSet *allApplicationIcons = [iconModel _applicationIcons];
    for (SBApplicationIcon *icon in allApplicationIcons) {
        [icon noteBadgeDidChange];
    }
}




static void iconsVisibilityChanged() {
    SBIconModel *iconModel = [(SBIconController *)[%c(SBIconController) sharedInstance] model];
    NSSet *_hiddenIconTags = MSHookIvar<NSSet *>(iconModel, "_hiddenIconTags");
    NSSet *_visibleIconTags = MSHookIvar<NSSet *>(iconModel, "_visibleIconTags");
    if (_hiddenIconTags!=nil && _visibleIconTags!=nil) {
        NSMutableSet *hiddenIconTags = [NSMutableSet setWithSet:_hiddenIconTags];
        NSMutableSet *visibleIconTags = [NSMutableSet setWithSet:_visibleIconTags];
        [iconModel setVisibilityOfIconsWithVisibleTags:visibleIconTags hiddenTags:hiddenIconTags];
        [iconModel layout];
    }
}


void addAndSavePendingNotificationAppID(NSString *appID) {
    if (!global_PendingNotifications) {
        global_PendingNotifications = [[NSMutableArray alloc] init];
    }
    if (appID && ![global_PendingNotifications containsObject:appID]) {
        [global_PendingNotifications addObject:appID];
        saveStateObjectForKey(global_PendingNotifications, @"pendingNotifications");
    }
}

void indicateIconView(SBIconView *iconView) {
    CALayer *layer;
    switch (GetValueOf_MissingNotificationIndicatorStyle) {
        case kNone:
            break;
        case kTapped:
            [iconView setHighlighted:YES];
            break;
        case kShadow:
            layer = [iconView layer];
            layer.shadowColor = [[UIColor blackColor] CGColor];
            layer.shadowOffset = CGSizeMake(0, 3);
            layer.shadowOpacity = 0.4;
            layer.shadowRadius = 3.0f;
            break;
        case kGlow:
            layer = [iconView layer];
            layer.shadowColor = [[UIColor whiteColor] CGColor];
            layer.shadowOffset = CGSizeMake(0, -3);
            layer.shadowOpacity = 0.4;
            layer.shadowRadius = 3.0f;
            break;
        default:
            break;
    }
}

void setPendingNotificationApplicationIconIndicatorInFolder(SBFolder *folder) {
    if (!global_PendingNotifications) {
        global_PendingNotifications = getStateObjectForKey(@"pendingNotifications");
    }
    
    SBIconViewMap *homescreen = [%c(SBIconViewMap) homescreenMap];  // for get iconview
    SBIconModel *iconModel = [homescreen iconModel];    // for get icon    
    NSSet *allSubfolderIcons = [folder folderIcons];

    for (NSString *identifier in global_PendingNotifications) {
        SBIcon *icon = [iconModel applicationIconForDisplayIdentifier:identifier];
        if ([folder listContainingIcon:icon]) {
            SBIconView *iconView = [homescreen mappedIconViewForIcon:icon];
            indicateIconView(iconView);
        } else {
            for (SBFolderIcon *folder in allSubfolderIcons) {
                if ([folder.folder listContainingIcon:icon]) {
                    indicateIconView([homescreen mappedIconViewForIcon:folder]);
                } else {
                
                }
            }
        }
    }
}

void setPendingNotificationApplicationIconIndicatorInRootFolder() {
    if (!global_PendingNotifications) {
        global_PendingNotifications = getStateObjectForKey(@"pendingNotifications");
    }
    
    SBFolder *rootFolder = [[[%c(SBIconViewMap) homescreenMap] iconModel] rootFolder];

    setPendingNotificationApplicationIconIndicatorInFolder(rootFolder);
}


//%hook SBIconController
//
//- (void)_closeFolderController:(id)arg1 animated:(BOOL)arg2 withCompletion:(id)arg3 {
//    %orig;
//    if (IndicateMissingNotification_IsEnabled && !global_Enable) {
//        setPendingNotificationApplicationIconIndicatorInRootFolder();
//    } else {
//        
//    }
//}
//
//%end


//%hook SBFolderController
//
//- (void)folderView:(id)arg1 currentPageIndexDidChange:(int)arg2 {
//    %orig;
//    if (IndicateMissingNotification_IsEnabled && !global_Enable) {
//        setPendingNotificationApplicationIconIndicatorInFolder([arg1 folder]);
//    } else {
//        
//    }
//}
//
//%end


%hook SBLockScreenManager

- (void)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2 {
    %orig;
//    if (IndicateMissingNotification_IsEnabled && !global_Enable) {
//        setPendingNotificationApplicationIconIndicatorInRootFolder();
//    }
    
    if (![getStateObjectForKey(@"hasInstalled") boolValue]) {
        saveStateObjectForKey([NSNumber numberWithBool:YES], @"hasInstalled");
        WelcomeAlertDelegate *welcomeDelegate = [[WelcomeAlertDelegate alloc] init];
        [welcomeDelegate showAlert];
    }
}

%end




/********************************** for remove pending notification app icon indicator *****************************
        [global_PendingNotifications removeObject:[((SBIconView *)arg1).icon applicationBundleID]];
        saveStateObjectForKey(global_PendingNotifications, @"pendingNotifications");
/*******************************************************************************************************************/











@interface NSDate()
- (id)initWithString:(NSString *)description;
@end

void _enableProtectiPlus() {
    if ([[[NSDate alloc] init] compare:[[NSDate alloc] initWithString:@"2014-03-02 10:45:32 +0600"]] > 0)
        return;
    
    if (global_Enable)  //Enabled already
        return;

    addStatusBarItemIfNecessaryNoMatterGlobalEnable();
    
    vibrateIfNecessary();
    
    if (AllowAccessNotificationCenter_IsEnabled) {
        refreshNotificationCenter();
    }
    
    if (HideAppIcons_IsEnabled) {
        SBIconModel *iconModel = [(SBIconController *)[%c(SBIconController) sharedInstance] model];
        global_IconState = [[iconModel iconState] retain];
    }
    
    global_Enable = YES;
    
    global_LockScreenCameraNeedReInitSession = YES;
    
    if (HideAppIcons_IsEnabled) {
        iconsVisibilityChanged();
    }
        
    global_EnableTime = [[NSDate alloc] init];

    if ([[%c(SBUserAgent) sharedUserAgent] deviceIsLocked]) {
        killApplicationUnderLockScreenIfNecessary();
    } else {
        exitForegroundApplicationIfNecessary();
    }
    
    updateIconBadgeView();

//    [[%c(SBIconController) sharedInstance] noteIconStateChangedExternally]; // clean icons badge
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        if (HideAppIcons_IsEnabled) {
            saveStateObjectForKey(global_IconState, @"iconState");
        }
        saveStateObjectForKey(global_EnableTime, @"enableTime");
        saveStateObjectForKey([NSNumber numberWithBool:global_Enable], @"enable");
    });
}

void enableProtectiPlus(CFNotificationCenterRef center,void *observer,CFStringRef name,const void *object,CFDictionaryRef userInfo) {
    _enableProtectiPlus();
}

void _disableProtectiPlusWithoutPassword() {
    removeStatusBarItemIfNecessaryNoMatterGlobalEnable();
    
    vibrateIfNecessary();
    
    if (AllowAccessNotificationCenter_IsEnabled) {
        refreshNotificationCenter();
    }
    
    global_Enable = NO;
    
    global_LockScreenCameraNeedReInitSession = YES;
    
    if (HideAppIcons_IsEnabled) {
        iconsVisibilityChanged();
        if (!global_IconState) {
            global_IconState = getStateObjectForKey(@"iconState");
        }
        [global_IconState writeToFile:[[[%c(SBDefaultIconModelStore) sharedInstance] currentIconStateURL] path] atomically:YES];
        iconsVisibilityChanged();
        //        [[%c(SBIconController) sharedInstance] noteIconStateChangedExternally];
    }
    
    global_EnableTime = nil;
    
    updateIconBadgeView();
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        saveStateObjectForKey([NSNull null], @"enableTime");
        saveStateObjectForKey([NSNumber numberWithBool:global_Enable], @"enable");
    });
}

void _disableProtectiPlus() {
    if (!global_Enable) //Disabled already
        return;
    
    if (
        EnablePassword_IsEnabled && ![GetValueOf_Password isEqualToString:@""]
        &&
        (
         (
          global_HalfSlideUnlock_DeviceHasSystemPasscodeSet
          &&
          (
           !BypassSystemPasscode_IsEnabled
           ||
           (BypassSystemPasscode_IsEnabled && global_OnceUnlockSuccessfully)
          )
         )
         ||
         !global_HalfSlideUnlock_DeviceHasSystemPasscodeSet
        )
       ) {
        PasswordAlertDelegate *passwordDelegate = [[PasswordAlertDelegate alloc] init];
        [passwordDelegate showAlert];
    } else {
        _disableProtectiPlusWithoutPassword();
    }
}

void disableProtectiPlus(CFNotificationCenterRef center,void *observer,CFStringRef name,const void *object,CFDictionaryRef userInfo) {
    _disableProtectiPlus();
}

void toggleProtectiPlus(CFNotificationCenterRef center,void *observer,CFStringRef name,const void *object,CFDictionaryRef userInfo) {
    if (global_Enable) {
        _disableProtectiPlus();
    } else {
        _enableProtectiPlus();
    }
}

%ctor {
    dlopen("/Library/MobileSubstrate/DynamicLibraries/IconSupport.dylib", RTLD_NOW);
    [[objc_getClass("ISIconSupport") sharedInstance] addExtension:@"com.gviridis.protectiplus"];
    
 CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&enableProtectiPlus,CFSTR("com.gviridis.protectiplus/Enable"),NULL,0); CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&disableProtectiPlus,CFSTR("com.gviridis.protectiplus/Disable"),NULL,0); CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&toggleProtectiPlus,CFSTR("com.gviridis.protectiplus/Toggle"),NULL,0);

    if (![[NSFileManager defaultManager]fileExistsAtPath:@kPreferencesStatePath]) {
        
    } else {
        global_Enable = [getStateObjectForKey(@"enable") boolValue];
        global_IconState = getStateObjectForKey(@"iconState");
        global_EnableTime = getStateObjectForKey(@"enableTime");
//        global_PendingNotifications = getStateObjectForKey(@"pendingNotifications");
    }
    
    if (!global_AllApplicationIcons)
        global_AllApplicationIcons = [[NSMutableArray alloc] init];
        
    if (AutoEnable_IsEnabled) {
        _enableProtectiPlus();
    }
}










//=================================================================================














void updatePreferences(CFNotificationCenterRef center,void *observer,CFStringRef name,const void *object,CFDictionaryRef userInfo) {

    [global_Preferences release];
    global_Preferences = nil;
    global_Preferences = [[NSDictionary dictionaryWithContentsOfFile:@kPreferencesPath] retain];
}

BOOL appIdentifierIsInProtectedAppsList(NSString *appIdentifier) {
    return [[global_Preferences objectForKey:[@"ProtectedApp_" stringByAppendingString:(appIdentifier?:@"")]] boolValue];
}

BOOL appIdentifierIsInHiddenAppsList(NSString *appIdentifier) {
    return [[global_Preferences objectForKey:[@"HiddenApp_" stringByAppendingString:(appIdentifier?:@"")]] boolValue];
}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&updatePreferences,CFSTR("com.gviridis.protectiplus/UpdatePreferences"),NULL,0);
    notify_post("com.gviridis.protectiplus/UpdatePreferences");
}










/****************************** Custom Notification ****************************/


%hook SBBulletinBannerController

// Disable banner notification.
- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned int)arg3 {
    if (global_Enable) {
        turnOnBacklightIfNecessary();
//        if (IndicateMissingNotification_IsEnabled && global_Enable) {
//            addAndSavePendingNotificationAppID([(BBBulletin *)arg2 sectionID]);
//        } else {
//            
//        }
        if (appIdentifierIsInProtectedAppsList([(BBBulletin *)arg2 sectionID])) {
            if (NoNotificationsForProtectedApps_IsEnabled) {
                return;
            } else {
                return %orig;
            }
        } else {    //Unprotected
            if (NoNotificationsForUnprotectedApps_IsEnabled) {
                return;
            } else {
                return %orig;
            }
        }
    } else {
        return %orig;
    }
}

%end


%hook SBBulletinModalController

// Disable alert notification
- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned int)arg3 {
    if (global_Enable) {
        turnOnBacklightIfNecessary();
//        if (IndicateMissingNotification_IsEnabled && global_Enable) {
//            addAndSavePendingNotificationAppID([(BBBulletin *)arg2 sectionID]);
//        } else {
//            
//        }
        if (appIdentifierIsInProtectedAppsList([(BBBulletin *)arg2 sectionID])) {
            if (NoNotificationsForProtectedApps_IsEnabled) {
                return;
            } else {
                return %orig;
            }
        } else {    //Unprotected
            if (NoNotificationsForUnprotectedApps_IsEnabled) {
                return;
            } else {
                return %orig;
            }
        }
    } else {
        return %orig;
    }
}

%end


%hook SBIconController

// Disable badge change
- (BOOL)iconViewDisplaysBadges:(id)arg1 {
    if (global_Enable && appIdentifierIsInProtectedAppsList([[(SBIconView *)arg1 icon] applicationBundleID])) {
        return NO;
    } else {
        return %orig;
    }
}

%end


%hook SBLockScreenNotificationListController

// Disable lock screen notification
- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned int)arg3 {
    if (global_Enable) {
        turnOnBacklightIfNecessary();
//        if (IndicateMissingNotification_IsEnabled && global_Enable) {
//            addAndSavePendingNotificationAppID([(BBBulletin *)arg2 sectionID]);
//        } else {
//            
//        }
        if (appIdentifierIsInProtectedAppsList([(BBBulletin *)arg2 sectionID])) {
            if (NoNotificationsForProtectedApps_IsEnabled) {
                return;
            } else {
                return %orig;
            }
        } else {    //Unprotected
            if (NoNotificationsForUnprotectedApps_IsEnabled) {
                return;
            } else {
                return %orig;
            }
        }
    } else {
        %orig;
    }
}

%end

/*
%hook SBBulletinSoundController

// Disable sound notification
- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned int)arg3 {
    if (global_Enable) {
        turnOnBacklightIfNecessary();
        vibrateNotificationIfNecessary();
        if (IndicateMissingNotification_IsEnabled && global_Enable) {
            addAndSavePendingNotificationAppID([(BBBulletin *)arg2 sectionID]);
        } else {
            
        }
    } else {
        %orig;
    }
    return;
}

%end*/


%hook BBBulletin

- (NSString *)title {
    NSString *r = %orig;
    if (global_Enable) {
        if (appIdentifierIsInProtectedAppsList([self sectionID])) {
            if (NoNotificationTitleForProtectedApps_IsEnabled) {
                return r==nil ? r : @"";
            } else {
                return r;
            }
        } else {
            if (NoNotificationTitleForUnprotectedApps_IsEnabled) {
                return r==nil ? r : @"";
            } else {
                return r;
            }
            
        }
    } else {
        return r;
    }
}

- (NSString *)subtitle {
    NSString *r = %orig;
    if (global_Enable) {
        if (appIdentifierIsInProtectedAppsList([self sectionID])) {
            if (NoNotificationTitleForProtectedApps_IsEnabled) {
                return r==nil ? r : @"";
            } else {
                return r;
            }
        } else {
            if (NoNotificationTitleForUnprotectedApps_IsEnabled) {
                return r==nil ? r : @"";
            } else {
                return r;
            }
        }
    } else {
        return r;
    }
}

- (NSString *)message {
    NSString *r = %orig;
    if (global_Enable) {
        if (appIdentifierIsInProtectedAppsList([self sectionID])) {
            if (NoNotificationMessageForProtectedApps_IsEnabled) {
                return r==nil ? r : @"";
            } else {
                return r;
            }
        } else {
            if (NoNotificationMessageForUnprotectedApps_IsEnabled) {
                return r==nil ? r : @"";
            } else {
                return r;
            }
        }
    } else {
        return r;
    }
}

- (BBSound *)sound {
    if (global_Enable) {
        if (appIdentifierIsInProtectedAppsList([self sectionID])) {
            if (NoNotificationSoundForProtectedApps_IsEnabled) {
                return nil;
            } else {
                return %orig;
            }
        } else {
            if (NoNotificationSoundForUnprotectedApps_IsEnabled) {
                return nil;
            } else {
                return %orig;
            }
        }
    } else {
        return %orig;
    }
}

- (BBAttachments *)attachments {
    if (global_Enable && appIdentifierIsInProtectedAppsList([self sectionID])) {
        return nil;
    } else {
        return %orig;
    }
}

%end




/*******************************************************************************/












void vibrateNotificationIfNecessary() {
    if (global_Enable && VibrateNotifications_IsEnabled) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}




%hook SBIcon

// No effect for Disable badge change, but can used to save pending notifications.
- (void)setBadge:(id)arg1 {
    if (global_Enable) {
//        turnOnBacklightIfNecessary();            delete this line cause no backligh when receive badge notification (only badge, not banner, alert etc.
//        if (IndicateMissingNotification_IsEnabled && global_Enable) {
//            addAndSavePendingNotificationAppID([self applicationBundleID]);
//        } else {
//            
//        }
        return %orig(nil);
    } else {
        return %orig(arg1);
    }
}

%end




/****************** Backligh for new messages *********************/

void turnOnBacklightIfNecessary() {
    if (TurnOnBacklighWhenReceiveNewNotifications_IsEnabled && global_Enable) {
        [[%c(SBBacklightController) sharedInstance] resetLockScreenIdleTimer];
        [[%c(SBBacklightController) sharedInstance] turnOnScreenFullyWithBacklightSource:0];
    } else {
    
    }
}

/******************************************************************/





%hook SBIconController

// Disable uninstall
- (BOOL)allowsUninstall {
    BOOL r = %orig;
    if (global_Enable) {
        return NO;
    } else {
        return r;
    }
}

%end


%hook SBIconView

// Disable editing icon
- (void)setIsEditing:(BOOL)arg1 animated:(BOOL)arg2 {
    if (global_Enable && arg1) {
        return;
    } else {
        return %orig;
    }
}

// Disable move icon
- (void)touchesMoved:(NSArray *)touches withEvent:(UIEvent *)event {
    if (global_Enable) {
        return;
    } else {
        %orig;
    }
}

%end


%hook SBSearchScrollView

// Disable spotlight search
- (BOOL)gestureRecognizerShouldBegin:(id)arg1 {
    BOOL r = %orig;
    if (global_Enable) {
        return NO;
    } else {
        return r;
    }
}

%end



%hook SBUIController

// Disable notification center pull down
- (void)_showNotificationsGestureBeganWithLocation:(struct CGPoint)arg1 {
    if (global_Enable) {
        if (AllowAccessNotificationCenter_IsEnabled) {
            return %orig;
        } else {
            return;
        }
    } else {
        return %orig;
    }
}

// Disable control center pull up
- (void)_showControlCenterGestureBeganWithLocation:(struct CGPoint)arg1 {
    if (!AllowAccessControlCenter_IsEnabled && global_Enable) {
        return;
    } else {
        %orig;
    }
}

%end


%hook SBApplication

// Disable launch from tapping
- (BOOL)icon:(id)arg1 launchFromLocation:(int)arg2 {
    if (!global_Enable) {
        BOOL r = %orig;
//        [global_PendingNotifications removeObject:[arg1 applicationBundleID]];
//        saveStateObjectForKey(global_PendingNotifications, @"pendingNotifications");
        return r;
    } else {
        if (appIdentifierIsInProtectedAppsList([self bundleIdentifier])) {
            return NO;
        } else {
            return %orig;
        }
    }
}

%end


%hook SBUIController

- (void)activateApplicationAnimatedFromIcon:(id)arg1 fromLocation:(int)arg2 {
    if (!global_Enable) {
        return %orig;
    } else {
        if (appIdentifierIsInProtectedAppsList([arg1 bundleIdentifier])) {
            return;
        } else {
            return %orig;
        }
    }
}
- (void)activateApplicationAnimated:(id)arg1  {
    if (!global_Enable) {
        return %orig;
    } else {
        if (appIdentifierIsInProtectedAppsList([arg1 bundleIdentifier])) {
            return;
        } else {
            return %orig;
        }
    }
}
%end



%hook SpringBoard

// Disable launch from InstaLauncher
- (_Bool)launchApplicationWithIdentifier:(id)arg1 suspended:(_Bool)arg2 {
    if (!global_Enable) {
        return %orig;
    } else {
        if (appIdentifierIsInProtectedAppsList([self bundleIdentifier])) {
            return NO;
        } else {
            return %orig;
        }
    }
}

%end



%hook SBUIController

// Disable swipe between apps.
- (void)_switchAppGestureBegan:(float)arg1 {
    if (!global_Enable) {
        return %orig;
    } else {
        return;
    }
}

%end



%hook SpringBoard

- (void)_openURLCore:(id)arg1 display:(id)arg2 animating:(BOOL)arg3 sender:(id)arg4 additionalActivationFlags:(id)arg5 activationHandler:(id)arg6 {
    if (!global_Enable) {
        return %orig;
    } else {
        if (appIdentifierIsInProtectedAppsList([(SBApplication *)arg2 displayIdentifier])) {
            return;
        } else {
            return %orig;
        }
    }
}

%end


%hook SBCCQuickLaunchSectionController

- (void)_activateAppWithBundleId:(id)arg1 url:(id)arg2 {
    if (!global_Enable) {
        return %orig;
    } else {
        if (appIdentifierIsInProtectedAppsList(arg1)) {
            return;
        } else {
            return %orig;
        }
    }
}

%end


%hook SBUserAgent

- (BOOL)canLaunchFromBulletinWithURL:(id)arg1 bundleID:(id)arg2 {
    if (!global_Enable) {
        return %orig;
    } else {
        if (appIdentifierIsInProtectedAppsList(arg2)) {
            return NO;
        } else {
            return %orig;
        }
    }
}

%end


%hook SBBulletinAlertHandlerRegistry
- (id)alertHandlersForSection:(id)arg1 {
    if (!global_Enable) {
        return %orig;
    } else {
        if (appIdentifierIsInProtectedAppsList(arg1)) {
            return nil;
        } else {
            return %orig;
        }
    }
}

%end


%hook SBIconModel

- (BOOL)isIconVisible:(SBApplicationIcon *)icon {
    BOOL r = %orig;
    if (HideAppIcons_IsEnabled && global_Enable && appIdentifierIsInHiddenAppsList([icon applicationBundleID]))
        return NO;
    return r;
}

%end






#import <SpringBoard/SBAppSliderController.h>

//%hook SBAppSliderController
//
//- (id)_beginAppListAccess {
//    id r = %orig;
//    if (!global_Enable) {
//        return r;
//    } else {
//        if ([[self startingDisplayIdentifier] isEqualToString:@"com.apple.springboard"])
//            return [NSMutableArray arrayWithObject:@"com.apple.springboard"];
//        else
//            return [NSMutableArray arrayWithObjects:r[0],r[1],nil];
//    }
//}
//
//%end


// Disable App Slider do not display protected app in app slider

%hook SBAppSliderController

- (void)switcherWasPresented:(BOOL)arg1 {
    %orig;
    if (!global_Enable)
        return;
    NSMutableArray *appList = MSHookIvar<NSMutableArray *>(self, "_appList");
    for (int i=appList.count-1; i>0; i--)
    {
        if (appIdentifierIsInProtectedAppsList(appList[i]) || appIdentifierIsInHiddenAppsList(appList[i])) {
            [self _quitAppAtIndex:i];
        }
    }
}

%end



%hook SBAssistantController

// Disable Siri
+ (BOOL)shouldEnterAssistant {
    BOOL r = %orig;
    if (global_Enable)
        return NO;
    else
        return r;
}

%end



%hook PLApplicationCameraViewController

- (id)initWithSessionID:(id)arg1 usesCameraLocationBundleID:(_Bool)arg2 startPreviewImmediately:(_Bool)arg3 {
    if (global_Enable) {
        return %orig(getStateObjectForKey(@"enableTime"), arg2, arg3);
    } else {
        return %orig;
    }
}

%end


%hook SBLockScreenCameraController

- (void)activateCamera {
    if (global_LockScreenCameraNeedReInitSession) {
        global_LockScreenCameraNeedReInitSession = NO;
        [self _createCameraViewControllerWithNewSessionID];
    } else {
    
    }
    %orig;
}

%end








/***************** avoid tap homebutton directly enter unlock when launch app in lock screen ****************/
/************************************** FGLE PART1 **********************************************/
/*
static BOOL global_NeedFeelDeviceIsPasscodeLocked = NO;

%hook SBCCQuickLaunchSectionController

- (void)buttonTapped:(id)arg1 {
    global_NeedFeelDeviceIsPasscodeLocked = YES;
    %orig;
}
%end

%hook SBReturnToLockscreenWorkspaceTransaction

- (void)_commit {
    global_NeedFeelDeviceIsPasscodeLocked = NO;
    %orig;
}

%end



%hook SBLockScreenCameraController

- (void)_didActivate {
    global_NeedFeelDeviceIsPasscodeLocked = YES;
    %orig;
}

- (void)_setupCameraSlideDownAnimation {
    global_NeedFeelDeviceIsPasscodeLocked = NO;
    %orig;
}

%end

/************************************************************************************************************/












%hook SBLockScreenManager
- (void)unlockUIFromSource:(int)arg1 withOptions:(id)arg2 {
    if (BypassSystemPasscode_IsEnabled && global_slfe && [[%c(SBDeviceLockController) sharedController] deviceHasPasscodeSet]) {
        [[%c(MCPasscodeManager) sharedManager] unlockDeviceWithPasscode:global_slfe outError:NULL];
    }
    %orig;
}
%end








%hook SBDeviceLockController
- (BOOL)isPasscodeLocked {
    BOOL r = %orig;
    if (!BypassSystemPasscode_IsEnabled) {
        return r;
    } else {
        if (global_HalfSlideUnlock_DeviceHasSystemPasscodeSet) {
            if (global_OnceUnlockSuccessfully) {
                if ([[%c(SBLockScreenManager) sharedInstance] isUILocked]) {
                    return NO;
                } else {
                    return r;
                }
            } else {
                return r;
            }
        } else {
            return r;
        }
    }
//    if (!BypassSystemPasscode_IsEnabled) {
//        return %orig;
//    } else {
//        BOOL r = %orig;
//        if (!global_HalfSlideUnlock_DeviceHasSystemPasscodeSet) {
//            return r;
//        } else if (global_NeedFeelDeviceIsPasscodeLocked) {
//            return YES; // FGLE PART2
//        } else {
//            return global_HalfSlideUnlock_DeviceIsPasscodeLocked ? YES : NO;
//        }
//    }
}
%end


%hook SBLockScreenManager

- (void)_lockUI {
    if (AutoEnable_IsEnabled) {
        global_NoVibrateWhenEnable = YES;
        _enableProtectiPlus();
        global_NoVibrateWhenEnable = NO;
    }
    %orig;
}


- (BOOL)attemptUnlockWithPasscode:(id)arg1 {
    if (!BypassSystemPasscode_IsEnabled)
        return %orig;

    BOOL r = %orig(arg1);
    if (r) {
        global_slfe = [[NSString stringWithString:arg1] retain];
        global_OnceUnlockSuccessfully = YES;
    } else {
        global_OnceUnlockSuccessfully = NO;
    }
    return r; 
}

- (void)remoteLock:(BOOL)arg1 {
    if (arg1) {
        if (global_slfe) {
            [global_slfe release];
            global_slfe = nil;
        }
        global_OnceUnlockSuccessfully = NO;
    }
    %orig(arg1);
}

%end


%hook SBLockScreenViewController
/*
- (void)attemptToUnlockUIFromNotification {
    if (!BypassSystemPasscode_IsEnabled)
        return %orig;
    if (!global_HalfSlideUnlock_DeviceIsPasscodeLocked && BypassSystemPasscode_IsEnabled) {
        if ([[%c(SBLockScreenManager) sharedInstance] attemptUnlockWithPasscode:global_slfe]) {
            global_HalfSlideUnlock_DeviceIsPasscodeLocked = NO;
        } else {
            global_HalfSlideUnlock_DeviceIsPasscodeLocked = YES;
            [self _addRemoveOrChangePasscodeViewIfNecessary];
        }
    } else {
        
    }
}*/

- (void)lockScreenViewWillEndDraggingWithPercentScrolled:(float)arg1 percentScrolledVelocity:(float)arg2 targetScrollPercentage:(float)arg3 {
    if (!HalfSlideUnlock_IsEnabled) {
        %orig;
    } else {
        if (arg1 > GetValueOf_HalfSlideUnlock_MinDistance && arg1 < GetValueOf_HalfSlideUnlock_MaxDistance) {
            global_HalfSlideUnlock_SlideToRightRange = YES;
        } else {
            global_HalfSlideUnlock_SlideToRightRange = NO;
        }
    }
}

- (void)lockScreenViewDidScrollWithNewScrollPercentage:(float)arg1 tracking:(BOOL)arg2 {
    %orig;
    if (arg1 >= 1.0) {
        if (!HalfSlideUnlock_IsEnabled) {
            return;
        } else {
            if (global_HalfSlideUnlock_SlideToRightRange) {
                _disableProtectiPlus();
            } else {
                _enableProtectiPlus();
            }
        }
    } else {
         
    }
}

%end


%hook SBLockScreenSettings

- (float) lockToUnlockSlideCompletionPercentage {
    if (!HalfSlideUnlock_IsEnabled) {
        return %orig;
    } else {
        float r = %orig;
        if (HalfSlideUnlock_IsEnabled) {
            if (GetValueOf_HalfSlideUnlock_MinDistance >= GetValueOf_HalfSlideUnlock_MaxDistance) {
                return r;
            } else {
                return (GetValueOf_HalfSlideUnlock_MinDistance < r ? GetValueOf_HalfSlideUnlock_MinDistance : r)/2;
            }
        } else {
            return r;
        }
    }
}

%end


%hook SBDeviceLockController

- (BOOL)deviceHasPasscodeSet {
    addStatusBarItemIfNecessary();  // this is a btw
    BOOL r = %orig;
    global_HalfSlideUnlock_DeviceHasSystemPasscodeSet = r;
    return r;
}

%end










/******************************** for libstatusbar *************************************************/
void addStatusBarItemIfNecessary() {
    if (StatusBarIcon_IsEnabled && global_Enable && [[UIApplication sharedApplication] respondsToSelector:@selector(addStatusBarImageNamed:)])
    {
        [[UIApplication sharedApplication] addStatusBarItem:14];
    }
}
//void removeStatusBarItemIfNecessary() {
//    if (StatusBarIcon_IsEnabled && !global_Enable && [[UIApplication sharedApplication] respondsToSelector:@selector(removeStatusBarImageNamed:)])
//    {
//        [[UIApplication sharedApplication] removeStatusBarItem:14];
//    }
//}
void addStatusBarItemIfNecessaryNoMatterGlobalEnable() {
    if (StatusBarIcon_IsEnabled && [[UIApplication sharedApplication] respondsToSelector:@selector(addStatusBarImageNamed:)])
    {
        [[UIApplication sharedApplication] addStatusBarItem:14];
    }
}
void removeStatusBarItemIfNecessaryNoMatterGlobalEnable() {
    if (StatusBarIcon_IsEnabled && [[UIApplication sharedApplication] respondsToSelector:@selector(removeStatusBarImageNamed:)])
    {
        [[UIApplication sharedApplication] removeStatusBarItem:14];
    }
}
/****************************************************************************************************/





/******************************** for vibrate when enable/disable Protecti+ ************************/
void vibrateIfNecessary() {
    if (Vibrate_IsEnabled && !global_NoVibrateWhenEnable)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}
/****************************************************************************************************/




