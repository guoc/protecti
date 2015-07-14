/********************* Try to disable launch by LastApp and open link in AppStore ******************************/
/************* Accidentally found the way to disable launch apps in general way. It seems well. ****************/

%hook SBAppToAppWorkspaceTransaction

- (id)initWithAlertManager:(id)alertManager from:(id)from to:(id)to withResult:(id)result {
    if (global_Enable && appIdentifierIsInProtectedAppsList([to displayIdentifier])) {
        return nil;
    } else {
        return %orig;
    }
}

%end

/****************************************************************************************************************/


%hook SBApplication

// Disable launch from tapping
- (BOOL)icon:(id)icon launchFromLocation:(int)location context:(id)context {
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
