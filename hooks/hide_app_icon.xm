%hook SBIconModel

- (BOOL)isIconVisible:(SBIcon *)icon {
    BOOL r = %orig;
    if (HideAppIcons_IsEnabled && global_Enable && appIdentifierIsInHiddenAppsList([icon applicationBundleID])) {
        return NO;
    }
    return r;
}

%end
