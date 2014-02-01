#include "../states.h"
#include "../prefs.h"


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




