#import <notify.h>
#include "../states.h"
#include "../prefs.h"

#import <UIKit/UIKit.h>

%hook UIImagePickerController

- (UIImagePickerControllerSourceType)sourceType {
    BOOL r = %orig;
    if ([[[NSDictionary dictionaryWithContentsOfFile:@kPreferencesStatePath] objectForKey:@"enable"] boolValue]
        &&
        [[[NSDictionary dictionaryWithContentsOfFile:@kPreferencesPath] objectForKey:@"enableStopThirdpartyAppPhotosAccess"] boolValue]) {
        return UIImagePickerControllerSourceTypeCamera;
    } else {
        return r;
    }
}

- (void)setSourceType:(UIImagePickerControllerSourceType)type {
    if ([[[NSDictionary dictionaryWithContentsOfFile:@kPreferencesStatePath] objectForKey:@"enable"] boolValue]
        &&
        [[[NSDictionary dictionaryWithContentsOfFile:@kPreferencesPath] objectForKey:@"enableStopThirdpartyAppPhotosAccess"] boolValue]) {
        return %orig(UIImagePickerControllerSourceTypeCamera);
    } else {
        return %orig;
    }
}

%end



%hook ALAssetsLibraryPrivate

- (id)photoLibrary {
    if ([[[NSDictionary dictionaryWithContentsOfFile:@kPreferencesStatePath] objectForKey:@"enable"] boolValue]
        &&
        [[[NSDictionary dictionaryWithContentsOfFile:@kPreferencesPath] objectForKey:@"enableStopThirdpartyAppPhotosAccess"] boolValue])
        return nil;
    else
        return %orig;
}

%end



%hook MCProfileConnection

- (_Bool)changePasscodeFrom:(id)arg1 to:(id)arg2 outError:(id *)arg3 {
    BOOL r = %orig;
    notify_post("com.gviridis.protectiplus/SystemPasscodeChanged");
    return r;
}

%end
