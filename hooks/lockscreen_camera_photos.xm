%hook CAMApplicationViewController

- (id)initWithSessionID:(id)arg1 usesCameraLocationBundleID:(_Bool)arg2 startPreviewImmediately:(_Bool)arg3 {
    if (global_Enable) {
        return %orig(getStateObjectForKey(@"enableTime"), arg2, arg3);
    } else {
        return %orig;
    }
}

%end
