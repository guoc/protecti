#import <AudioToolBox/AudioServices.h>
#import <SpringBoard/SBBacklightController.h>

%hook SBBulletinBannerController

// Disable banner notification.
- (void)observer:(id)observer addBulletin:(id)bulletin forFeed:(unsigned)feed playLightsAndSirens:(BOOL)sirens withReply:(id)reply {
    if (global_Enable) {
        turnOnBacklightIfNecessary();
//        if (IndicateMissingNotification_IsEnabled && global_Enable) {
//            addAndSavePendingNotificationAppID([(BBBulletin *)arg2 sectionID]);
//        } else {
//
//        }
        if (appIdentifierIsInProtectedAppsList([(BBBulletin *)bulletin sectionID])) {
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
- (void)observer:(id)observer addBulletin:(id)bulletin forFeed:(unsigned)feed playLightsAndSirens:(BOOL)sirens withReply:(id)reply {
    if (global_Enable) {
        turnOnBacklightIfNecessary();
//        if (IndicateMissingNotification_IsEnabled && global_Enable) {
//            addAndSavePendingNotificationAppID([(BBBulletin *)arg2 sectionID]);
//        } else {
//
//        }
        if (appIdentifierIsInProtectedAppsList([(BBBulletin *)bulletin sectionID])) {
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
    SBIcon *icon = MSHookIvar<SBIcon *>(arg1, "_icon");

    if (global_Enable && appIdentifierIsInProtectedAppsList([icon applicationBundleID])) {
        return NO;
    } else {
        return %orig;
    }
}

%end


%hook SBLockScreenNotificationListController

// Disable lock screen notification
- (void)observer:(id)observer addBulletin:(id)bulletin forFeed:(unsigned)feed playLightsAndSirens:(BOOL)sirens withReply:(id)reply {
    if (global_Enable) {
        turnOnBacklightIfNecessary();
//        if (IndicateMissingNotification_IsEnabled && global_Enable) {
//            addAndSavePendingNotificationAppID([(BBBulletin *)arg2 sectionID]);
//        } else {
//
//        }
        if (appIdentifierIsInProtectedAppsList([(BBBulletin *)bulletin sectionID])) {
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


void vibrateNotificationIfNecessary() {
    if (global_Enable && VibrateNotifications_IsEnabled) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

/* Backligh for new messages */
void turnOnBacklightIfNecessary() {
    if (TurnOnBacklighWhenReceiveNewNotifications_IsEnabled && global_Enable) {
        [[objc_getClass("SBBacklightController") sharedInstance] resetLockScreenIdleTimer];
        [[objc_getClass("SBBacklightController") sharedInstance] turnOnScreenFullyWithBacklightSource:0];
    } else {

    }
}
