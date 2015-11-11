// Disable notification center pull down

%group iOS_8
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
%end

%group iOS_9
%hook SBNotificationCenterController
- (void)_handleShowNotificationCenterGesture:(id)arg1 {
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
%end
