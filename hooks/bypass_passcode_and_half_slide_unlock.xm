extern BOOL global_HalfSlideUnlock_DeviceHasSystemPasscodeSet;

static NSString *global_slfe;
static BOOL global_HalfSlideUnlock_SlideToRightRange;    // Init in SBLockScreenViewController - (void)lockScreenViewWillEndDraggingWithPercentScrolled:(double)arg1 percentScrolledVelocity:(double)arg2 targetScrollPercentage:(double)arg3

void handleSystemPasscodeChange(CFNotificationCenterRef center,void *observer,CFStringRef name,const void *object,CFDictionaryRef userInfo) {
    global_slfe = nil;
    global_OnceUnlockSuccessfully = NO;
}


%hook SBLockScreenManager
- (void)unlockUIFromSource:(int)arg1 withOptions:(id)arg2 {
    if (BypassSystemPasscode_IsEnabled && global_slfe && [[%c(SBDeviceLockController) sharedController] deviceHasPasscodeSet]) {
        [[%c(MCPasscodeManager) sharedManager] unlockDeviceWithPasscode:global_slfe outError:NULL];
    }
    %orig;
}
%end


%hook SBDeviceLockController
- (BOOL)isPasscodeLocked {
    BOOL r = %orig;
    if (!BypassSystemPasscode_IsEnabled) {
        return r;
    } else {
        if (global_HalfSlideUnlock_DeviceHasSystemPasscodeSet) {
            if (global_OnceUnlockSuccessfully) {
                if ([[%c(SBLockScreenManager) sharedInstance] isUILocked]) {
                    return NO;
                } else {
                    return r;
                }
            } else {
                return r;
            }
        } else {
            return r;
        }
    }
//    if (!BypassSystemPasscode_IsEnabled) {
//        return %orig;
//    } else {
//        BOOL r = %orig;
//        if (!global_HalfSlideUnlock_DeviceHasSystemPasscodeSet) {
//            return r;
//        } else if (global_NeedFeelDeviceIsPasscodeLocked) {
//            return YES; // FGLE PART2
//        } else {
//            return global_HalfSlideUnlock_DeviceIsPasscodeLocked ? YES : NO;
//        }
//    }
}
%end


%hook SBLockScreenManager

- (BOOL)attemptUnlockWithPasscode:(id)passcode {
    if (!BypassSystemPasscode_IsEnabled)
        return %orig;

    BOOL r = %orig(passcode);
    if (r && passcode != nil && [passcode isKindOfClass: [NSString class]]) {
        global_slfe = [[NSString stringWithString:passcode] retain];
        global_OnceUnlockSuccessfully = YES;
    } else {
        global_OnceUnlockSuccessfully = NO;
    }
    return r;
}

- (void)remoteLock:(BOOL)arg1 {
    if (arg1) {
        if (global_slfe) {
            [global_slfe release];
            global_slfe = nil;
        }
        global_OnceUnlockSuccessfully = NO;
    }
    %orig(arg1);
}

%end


%hook SBLockScreenViewController
/*
- (void)attemptToUnlockUIFromNotification {
    if (!BypassSystemPasscode_IsEnabled)
        return %orig;
    if (!global_HalfSlideUnlock_DeviceIsPasscodeLocked && BypassSystemPasscode_IsEnabled) {
        if ([[%c(SBLockScreenManager) sharedInstance] attemptUnlockWithPasscode:global_slfe]) {
            global_HalfSlideUnlock_DeviceIsPasscodeLocked = NO;
        } else {
            global_HalfSlideUnlock_DeviceIsPasscodeLocked = YES;
            [self _addRemoveOrChangePasscodeViewIfNecessary];
        }
    } else {

    }
}*/

- (void)lockScreenViewWillEndDraggingWithPercentScrolled:(double)arg1 percentScrolledVelocity:(double)arg2 targetScrollPercentage:(double)arg3 {
    if (!HalfSlideUnlock_IsEnabled) {
        %orig;
    } else {
        if (arg1 > GetValueOf_HalfSlideUnlock_MinDistance && arg1 < GetValueOf_HalfSlideUnlock_MaxDistance) {
            global_HalfSlideUnlock_SlideToRightRange = YES;
        } else {
            global_HalfSlideUnlock_SlideToRightRange = NO;
        }
    }
}

- (void)lockScreenViewDidScrollWithNewScrollPercentage:(double)arg1 tracking:(BOOL)arg2 {
    %orig;
    if (arg1 >= 1.0) {
        if (!HalfSlideUnlock_IsEnabled) {
            return;
        } else {
            if (global_HalfSlideUnlock_SlideToRightRange) {
                _disableProtectiPlus();
            } else {
                _enableProtectiPlus();
            }
        }
    } else {

    }
}

%end


%hook SBLockScreenSettings

- (double) lockToUnlockSlideCompletionPercentage {
    if (!HalfSlideUnlock_IsEnabled) {
        return %orig;
    } else {
        double r = %orig;
        if (HalfSlideUnlock_IsEnabled) {
            if (GetValueOf_HalfSlideUnlock_MinDistance >= GetValueOf_HalfSlideUnlock_MaxDistance) {
                return r;
            } else {
                return (GetValueOf_HalfSlideUnlock_MinDistance < r ? GetValueOf_HalfSlideUnlock_MinDistance : r)/2;
            }
        } else {
            return r;
        }
    }
}

%end


%hook SBDeviceLockController

- (BOOL)deviceHasPasscodeSet {
    if (global_Enable) {
        [PIStatusBarIcon addStatusBarItemIfNecessary];  // this is a btw
    }
    BOOL r = %orig;
    global_HalfSlideUnlock_DeviceHasSystemPasscodeSet = r;
    return r;
}

%end
