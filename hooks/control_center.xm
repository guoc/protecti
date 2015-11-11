// Disable control center pull up

%group iOS_8
%hook SBUIController
- (void)_showControlCenterGestureBeganWithLocation:(struct CGPoint)arg1 {
    if (!AllowAccessControlCenter_IsEnabled && global_Enable) {
        return;
    } else {
        %orig;
    }
}
%end
%end


%group iOS_9
%hook SBControlCenterController
- (void)_handleShowControlCenterGesture:(id)arg1 {
    if (!AllowAccessControlCenter_IsEnabled && global_Enable) {
        return;
    } else {
        %orig;
    }
}
%end
%end
