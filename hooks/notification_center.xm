// Disable notification center pull down

%hook SBUIController

- (void)_showNotificationsGestureBeganWithLocation:(struct CGPoint)arg1 {
    if (global_Enable) {
        if (AllowAccessNotificationCenter_IsEnabled) {
            return %orig;
        } else {
            return;
        }
    } else {
        return %orig;
    }
}

%end
