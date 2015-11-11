%hook SBUIController

// Disable swipe between apps.

%group iOS_8
- (_Bool)allowSystemGestureType:(unsigned long long)arg1 atLocation:(struct CGPoint)arg2 {
    // http://iphonedevwiki.net/index.php/SBGestureRecognizer
    if (global_Enable && arg1 == 1<<2) {
        return NO;
    } else {
        return %orig;
    }
}
%end

%group iOS_9
- (void)_handleSwitchAppGesture:(id)arg1 {
    if (!global_Enable) {
        return %orig;
    }
    if (tageIsInstalled() && readTagePrefsSwipeSideEnabled()) {
        // Nothing special is done here.
        // In this case, Tage's settings are cached and restored in
        // _enableProtectiPlus and _disableProtectiPlusWithoutPassword
        // by calling following functions,
        // void cacheAndModifyTagePrefsSwipeSideEnabledIfNecessary();
        // void restoreTagePrefsSwipeSideEnabledIfNecessaryWithDelay(CGFloat delay);
        return %orig;
    }
    return;
}
%end

%end
