%hook SBUIController

// Disable swipe between apps.
- (_Bool)allowSystemGestureType:(unsigned long long)arg1 atLocation:(struct CGPoint)arg2 {
    // http://iphonedevwiki.net/index.php/SBGestureRecognizer
    if (global_Enable && arg1 == 1<<2) {
        return NO;
    } else {
        return %orig;
    }
}

%end
