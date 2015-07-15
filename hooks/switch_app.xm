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
