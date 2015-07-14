%hook SBIconModel

- (BOOL)isIconVisible:(SBApplicationIcon *)icon {
    BOOL r = %orig;
    if (HideAppIcons_IsEnabled && global_Enable && appIdentifierIsInHiddenAppsList([icon applicationBundleID])) {
        return NO;
    }
    return r;
}

%end
