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
