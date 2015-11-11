// Disable spotlight search

%hook SBSearchScrollView
- (BOOL)gestureRecognizerShouldBegin:(id)arg1 {
    BOOL r = %orig;
    if (global_Enable) {
        if (ccquickChangeSpotlightToLockDeviceIsSet()) {
            return r;
        } else {
            return NO;
        }
    } else {
        return r;
    }
}
%end

%group iOS_9
%hook SPUISearchViewController
- (void)setTableViewShown:(BOOL)arg1 {
    if (global_Enable) {
        return %orig(NO);
    } else {
        return %orig;
    }
}
%end
%end
