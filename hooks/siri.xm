%hook SBAssistantController

// Disable Siri
+ (BOOL)shouldEnterAssistant {
    BOOL r = %orig;
    if (global_Enable)
        return NO;
    else
        return r;
}

%end
