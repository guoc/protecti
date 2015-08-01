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

@interface PIPSListController: PSListController
- (id) readPreferenceValue:(PSSpecifier*)specifier;
- (void) setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier;
@end

@implementation PIPSListController
// http://iphonedevwiki.net/index.php/PreferenceBundles#Loading_Preferences_into_sandboxed.2Funsandboxed_processes_in_iOS_8
- (id) readPreferenceValue:(PSSpecifier*)specifier {
	NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:@kPreferencesPath];
	if (!prefs[specifier.properties[@"key"]]) {
		return specifier.properties[@"default"];
	}
	return prefs[specifier.properties[@"key"]];
}

- (void) setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:@kPreferencesPath]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:@kPreferencesPath atomically:YES];
	CFStringRef toPost = (CFStringRef)specifier.properties[@"PostNotification"];
	if(toPost) CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}
@end

@interface ProtectiPlusSettingsListController: PIPSListController {
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



@interface ProtectiPlusSettingsListControllerForTutorial: PIPSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForTutorial

@end



//@interface ProtectiPlusSettingsListControllerForProtectedMode: PIPSListController {
//}
//@end
//
//@implementation ProtectiPlusSettingsListControllerForProtectedMode
//
//@end



@interface ProtectiPlusSettingsListControllerForChooseGestures: PIPSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForChooseGestures

@end



@interface ProtectiPlusSettingsListControllerForProtectedAppNotifications: PIPSListController {
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



@interface ProtectiPlusSettingsListControllerForProtectedActions: PIPSListController {
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



@interface ProtectiPlusSettingsListControllerForHideAppIcons: PIPSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForHideAppIcons

@end



//@interface ProtectiPlusSettingsListControllerForUnprotectedMode: PIPSListController {
//}
//@end
//
//@implementation ProtectiPlusSettingsListControllerForUnprotectedMode
//
//@end



@interface ProtectiPlusSettingsListControllerForUnprotectedAppNotifications: PIPSListController {
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



@interface ProtectiPlusSettingsListControllerForIndicateMissingNotifications: PIPSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForIndicateMissingNotifications

@end



@interface ProtectiPlusSettingsListControllerForVibrateAndIcon: PIPSListController {
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


@interface ProtectiPlusSettingsListControllerForAdvance: PIPSListController {
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



@interface ProtectiPlusSettingsListControllerForPassword: PIPSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForPassword

@end



@interface ProtectiPlusSettingsListControllerForBypassSystemPasscode: PIPSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForBypassSystemPasscode

@end



@interface ProtectiPlusSettingsListControllerForDisableOpenFolders: PIPSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForDisableOpenFolders

@end



@interface ProtectiPlusSettingsListControllerForHalfSlideUnlock: PIPSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForHalfSlideUnlock

@end



@interface ProtectiPlusSettingsListControllerForPhotosAccess: PIPSListController {
}
@end

@implementation ProtectiPlusSettingsListControllerForPhotosAccess

@end




/******************************** About *********************************/


@interface ProtectiPlusSettingsListControllerForAbout: PIPSListController {
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
