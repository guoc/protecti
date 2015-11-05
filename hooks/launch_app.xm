/********************* Try to disable launch by LastApp and open link in AppStore ******************************/
/************* Accidentally found the way to disable launch apps in general way. It seems well. ****************/

#import <SpringBoard/SBWorkspaceTransitionRequest.h>
#import <SpringBoard/SBWorkspaceApplication.h>

@interface SBAppToAppWorkspaceTransaction
@property(readonly, retain, nonatomic) SBWorkspaceTransitionRequest *transitionRequest;
@end

%group iOS_8
%hook SBAppToAppWorkspaceTransaction
- (id)initWithAlertManager:(id)alertManager from:(id)from to:(id)to withResult:(id)result {
    if (global_Enable && appIdentifierIsInProtectedAppsList([to displayIdentifier])) {
        return nil;
    } else {
        return %orig;
    }
}
%end
%end

%group iOS_9
%hook SBMainWorkspace
- (_Bool)_setCurrentTransactionForRequest:(id)request fallbackProvider:(id)arg2 {
    if (![request isKindOfClass:[%c(SBWorkspaceTransitionRequest) class]]) {
        return %orig;
    }
    NSSet *activatingApps = ((SBWorkspaceTransitionRequest *)request).activatingApps;
    SBApplication *app = ((SBWorkspaceApplication *)[activatingApps anyObject]).application;
    if (global_Enable && appIdentifierIsInProtectedAppsList([app bundleIdentifier])) {
        return NO;
    } else {
        return %orig;
    }
}
%end
%end

/****************************************************************************************************************/


%hook SBApplication

// Disable launch from tapping
- (BOOL)icon:(id)icon launchFromLocation:(int)location context:(id)context {
    if (!global_Enable) {
        BOOL r = %orig;
/* Deprecated Indicate Missing Notification
       [global_PendingNotifications removeObject:[arg1 applicationBundleID]];
       saveStateObjectForKey(global_PendingNotifications, @"pendingNotifications");
*/
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

%group iOS_8
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

%group iOS_9
- (void)activateApplication:(id)arg1 fromIcon:(id)arg2 location:(int)arg3 {
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
- (void)activateApplication:(id)arg1 {
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

%end


%hook SpringBoard

- (void)_openURLCore:(id)core display:(id)display animating:(BOOL)animating sender:(id)sender activationSettings:(id)settings withResult:(id)result {
    if (!global_Enable) {
        return %orig;
    } else {
        if (appIdentifierIsInProtectedAppsList([(SBApplication *)display displayIdentifier])) {
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


%hook SpringBoard

// Disable launch from InstaLauncher
- (_Bool)launchApplicationWithIdentifier:(id)arg1 suspended:(_Bool)arg2 {
    if (!global_Enable) {
        return %orig;
    } else {
        if (appIdentifierIsInProtectedAppsList(arg1)) {
            return NO;
        } else {
            return %orig;
        }
    }
}

%end
