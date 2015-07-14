/******************** Hidden option: Disable activate App Slider when Protecti+ is enabled **********************/

%hook SBUIController

- (BOOL)_activateAppSwitcher {
    if (global_Enable && DisableActivateAppSlider_IsEnabled) {
        return NO;
    } else {
        return %orig;
    }
}

%end

/****************************************************************************************************************/
