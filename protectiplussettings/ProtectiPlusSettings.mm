#import <notify.h>
#import <objc/runtime.h>
//#import <CoreFoundation/CFUserNotification.h>
#import <CoreFoundation/CFRunLoop.h>
#import <SpringBoard/SBUIController.h>
//#import <Preferences/Preferences.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSListController.h>
#import "../states.h"
#import "../prefs.h"

#define LOCAL(key) [bundle localizedStringForKey:key value:key table:nil]

@interface ProtectiPlusSettingsListController: PSListController {
}
@end

@implementation ProtectiPlusSettingsListController
- (id)specifiers {
	if(_specifiers == nil) {
        if (!([[[NSDictionary dictionaryWithContentsOfFile:@kPreferencesStatePath] objectForKey:@"enable"] boolValue] && NoLoadSettingsWhenEnable_IsEnabled))
            _specifiers = [[self loadSpecifiersFromPlistName:@"ProtectiPlusSettings" target:self] retain];
	}
	return _specifiers;
}

-(void)setEnable:(id)enabled forSpecifier:(PSSpecifier*)spec {
    if ([enabled boolValue]) {
        notify_post("com.gviridis.protectiplus/Enable");
    } else {
        notify_post("com.gviridis.protectiplus/Disable");
    }
}

- (id)getEnabled {
    return getStateObjectForKey(@"enable");
}

-(void)restoreDefaults {
	notify_post("com.gviridis.protectiplus/Disable");
	notify_post("com.gviridis.protectiplus/ResetPreferences");
    sleep(3);
	system("rm -f /var/mobile/Library/Preferences/com.gviridis.protectiplus.plist");
	system("rm -f /var/mobile/Library/Preferences/com.gviridis.protectiplus.state.plist");
	system("rm -f /var/mobile/Library/Preferences/com.gviridis.protectiplus.protectedapps.plist");
	system("rm -f /var/mobile/Library/Preferences/com.gviridis.protectiplus.hiddenapps.plist");
}
@end



@interface ProtectiPlusSettingsListControllerForTutorial: PSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForTutorial

@end



//@interface ProtectiPlusSettingsListControllerForProtectedMode: PSListController {
//}
//@end
//
//@implementation ProtectiPlusSettingsListControllerForProtectedMode
//
//@end



@interface ProtectiPlusSettingsListControllerForChooseGestures: PSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForChooseGestures

@end



@interface ProtectiPlusSettingsListControllerForProtectedAppNotifications: PSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForProtectedAppNotifications
- (id)specifiers {
	if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Protected App Notifications" target:self] retain];
	}
	return _specifiers;
}
@end



@interface ProtectiPlusSettingsListControllerForProtectedActions: PSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForProtectedActions
- (id)specifiers {
	if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Protected Actions" target:self] retain];
	}
	return _specifiers;
}
@end



@interface ProtectiPlusSettingsListControllerForHideAppIcons: PSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForHideAppIcons

@end



//@interface ProtectiPlusSettingsListControllerForUnprotectedMode: PSListController {
//}
//@end
//
//@implementation ProtectiPlusSettingsListControllerForUnprotectedMode
//
//@end



@interface ProtectiPlusSettingsListControllerForUnprotectedAppNotifications: PSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForUnprotectedAppNotifications
- (id)specifiers {
	if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Unprotected App Notifications" target:self] retain];
	}
	return _specifiers;
}
@end



@interface ProtectiPlusSettingsListControllerForIndicateMissingNotifications: PSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForIndicateMissingNotifications

@end



@interface ProtectiPlusSettingsListControllerForVibrateAndIcon: PSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForVibrateAndIcon
- (id)specifiers {
	if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Vibrate & Icon" target:self] retain];
	}
	return _specifiers;
}
@end


/******************************** Advance *********************************/


@interface ProtectiPlusSettingsListControllerForAdvance: PSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForAdvance
- (id)specifiers {
	if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Advance" target:self] retain];
	}
	return _specifiers;
}
@end



@interface ProtectiPlusSettingsListControllerForPassword: PSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForPassword

@end



@interface ProtectiPlusSettingsListControllerForBypassSystemPasscode: PSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForBypassSystemPasscode

@end



@interface ProtectiPlusSettingsListControllerForDisableOpenFolders: PSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForDisableOpenFolders

@end



@interface ProtectiPlusSettingsListControllerForHalfSlideUnlock: PSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForHalfSlideUnlock

@end



@interface ProtectiPlusSettingsListControllerForPhotosAccess: PSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForPhotosAccess
// http://iphonedevwiki.net/index.php/PreferenceBundles#Loading_Preferences_into_sandboxed.2Funsandboxed_processes_in_iOS_8
- (id)readPreferenceValue:(PSSpecifier *)specifier {
	NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:@kPreferencesPath];
	if (!prefs[specifier.properties[@"key"]]) {
		return specifier.properties[@"default"];
	}
	return prefs[specifier.properties[@"key"]];
}
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:@kPreferencesPath]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:@kPreferencesPath atomically:YES];
	CFStringRef toPost = (CFStringRef)specifier.properties[@"PostNotification"];
	if(toPost) CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}
@end




/******************************** About *********************************/


@interface ProtectiPlusSettingsListControllerForAbout: PSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForAbout
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"About" target:self] retain];
	}
	return _specifiers;
}

- (NSString *) statusForSpecifier: (PSSpecifier *) specifier {
    return @"[[:";
}

-(void)respring {
    system("killall -9 SpringBoard");
}

- (void)contactWithAuthor {
//    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"cydia://package/com.gviridis.protectiplus"]];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"cydia://package/org.thebigboss.protecti"]];
}

- (void)openQuestionsAndAnswers {
    NSBundle *bundle = [NSBundle bundleWithPath:@"/Library/PreferenceBundles/ProtectiPlusSettings.bundle"];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:LOCAL(@"http://gviridis.com/protectiplus/questions_and_answers.html.en")]];
}

@end

// vim:ft=objc
