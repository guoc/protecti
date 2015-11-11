/******************** Hidden option: Disable activate App Slider when Protecti+ is enabled **********************/

%hook SBUIController

%group iOS_8
- (BOOL)_activateAppSwitcher {
    if (global_Enable && DisableActivateAppSlider_IsEnabled) {
        return NO;
    } else {
        return %orig;
    }
}
%end

%group iOS_9
- (_Bool)_appSwitcherForcePressSystemGestureShouldBegin:(id)arg1 {
    if (global_Enable && DisableActivateAppSlider_IsEnabled) {
        return NO;
    } else {
        return %orig;
    }
}
- (_Bool)_appSwitcherSystemGestureShouldBegin:(id)arg1 {
    if (global_Enable && DisableActivateAppSlider_IsEnabled) {
        return NO;
    } else {
        return %orig;
    }
}
%end

%end

/****************************************************************************************************************/
