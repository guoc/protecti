static NSMutableArray *global_PendingNotifications;

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
        SBIcon *icon = [iconModel applicationIconForBundleIdentifier:identifier];
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

    SBFolder *rootFolder = (SBFolder *)[[[%c(SBIconViewMap) homescreenMap] iconModel] rootFolder];

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
