// Disable control center pull up

%hook SBUIController

- (void)_showControlCenterGestureBeganWithLocation:(struct CGPoint)arg1 {
    if (!AllowAccessControlCenter_IsEnabled && global_Enable) {
        return;
    } else {
        %orig;
    }
}

%end
