#import <notify.h>
#include "../states.h"
#include "../prefs.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>



%hook MCProfileConnection

- (_Bool)changePasscodeFrom:(id)arg1 to:(id)arg2 outError:(id *)arg3 {
    BOOL r = %orig;
    notify_post("com.gviridis.protectiplus/SystemPasscodeChanged");
    return r;
}

%end



%hook UIImagePickerController

+ (BOOL)isSourceTypeAvailable:(UIImagePickerControllerSourceType)sourceType {
    if (![getStateObjectForKey(@"enable") boolValue] || DisableAccessPhotos_IsEnabled) {
        return %orig;
    }
    if (sourceType != UIImagePickerControllerSourceTypePhotoLibrary && sourceType != UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        return %orig;
    }
    return NO;
}

%end



%hook ALAssetsLibrary

+ (ALAuthorizationStatus)authorizationStatus {
    ALAuthorizationStatus r = %orig;
    if (![getStateObjectForKey(@"enable") boolValue] || DisableAccessPhotos_IsEnabled) {
        return r;
    }
    return ALAuthorizationStatusDenied;
}

/* Prevent TweetBot access last photo taken */
- (void)enumerateGroupsWithTypes:(ALAssetsGroupType)types usingBlock:(ALAssetsLibraryGroupsEnumerationResultsBlock)enumerationBlock failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock {
    if (![getStateObjectForKey(@"enable") boolValue] || DisableAccessPhotos_IsEnabled) {
        return %orig;
    }
    failureBlock(nil);
}

%end



%hook PHPhotoLibrary

+ (PHAuthorizationStatus)authorizationStatus {
    PHAuthorizationStatus r = %orig;
    if (![getStateObjectForKey(@"enable") boolValue] || DisableAccessPhotos_IsEnabled) {
        return r;
    }
    return PHAuthorizationStatusDenied;
}

%end



%hook CAMCameraView

- (BOOL)_shouldEnableImageWell {
    if (![getStateObjectForKey(@"enable") boolValue] || DisableAccessPhotos_IsEnabled) {
        return %orig;
    }
    return NO;
}

- (BOOL)_shouldHideImageWellForMode:(int)arg1 {
    if (![getStateObjectForKey(@"enable") boolValue] || DisableAccessPhotos_IsEnabled) {
        return %orig;
    }
    return YES;
}

%end
