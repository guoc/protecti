#import "PIPreferences.h"

// http://www.galloway.me.uk/tutorials/singleton-classes/
// http://sharedinstance.net/2014/11/settings-the-right-way/

static HBPreferences *sharedPreferences = nil;

@implementation PIPreferences

+ (void)updatePreferences {
    // http://sharedinstance.net/2014/11/settings-the-right-way/

    NSDictionary *protectedApps = [NSDictionary dictionaryWithContentsOfFile:[[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"Preferences"] stringByAppendingPathComponent:kPIPreferencesProtectedAppsDomain] stringByAppendingPathExtension:@"plist"]];
    NSDictionary *hiddenApps = [NSDictionary dictionaryWithContentsOfFile:[[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"Preferences"] stringByAppendingPathComponent:kPIPreferencesHiddenAppsDomain] stringByAppendingPathExtension:@"plist"]];
    [protectedApps enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        [PIPreferences.sharedPreferences setObject:object forKey: key];
    }];
    [hiddenApps enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        [PIPreferences.sharedPreferences setObject:object forKey: key];
    }];
}

#pragma mark Singleton Methods
+ (id)sharedPreferences {
  @synchronized(self) {
      if(sharedPreferences == nil)
          sharedPreferences = [[super allocWithZone:NULL] init];
  }
  return sharedPreferences;
}
+ (id)allocWithZone:(NSZone *)zone {
  return [[self sharedPreferences] retain];
}
- (id)copyWithZone:(NSZone *)zone {
  return self;
}
- (id)retain {
  return self;
}
- (unsigned)retainCount {
  return UINT_MAX; //denotes an object that cannot be released
}
- (oneway void)release {
  // never release
}
- (id)autorelease {
  return self;
}
- (id)init {
  self = (PIPreferences *)[[HBPreferences alloc] initWithIdentifier:kPIPreferencesDomain];
  [self registerDefaults:@{
        kPIPreferencesEnableHalfSlideUnlockKey: @NO,
        kPIPreferencesEnableBypassSystemPasscodeKey: @NO,
        kPIPreferencesEnableVibrateKey: @NO,
        kPIPreferencesEnableStatusBarIconKey: @YES,
        kPIPreferencesEnableTurnOnBacklighWhenReceiveNewNotificationsKey: @NO,
        kPIPreferencesEnableVibrateNotificationsKey: @NO,
        kPIPreferencesAllowAccessNotificationCenterKey: @NO,
        kPIPreferencesAllowAccessControlCenterKey: @NO,
        kPIPreferencesEnableHideAppIconsKey: @NO,
        kPIPreferencesEnableIndicateMissingNotificationKey: @NO,
        kPIPreferencesMissingNotificationIndicatorStyleKey: [NSNumber numberWithInt: kTapped],
        kPIPreferencesHalfSlideUnlock_MinDistanceKey: @0.2,
        kPIPreferencesHalfSlideUnlock_MaxDistanceKey: @0.33,

        kPIPreferencesNoNotificationsForProtectedAppsKey: @NO,
        kPIPreferencesNoNotificationTitleForProtectedAppsKey: @YES,
        kPIPreferencesNoNotificationMessageForProtectedAppsKey: @YES,
        kPIPreferencesNoNotificationSoundForProtectedAppsKey: @NO,

        kPIPreferencesNoNotificationsForUnprotectedAppsKey: @NO,
        kPIPreferencesNoNotificationTitleForUnprotectedAppsKey: @NO,
        kPIPreferencesNoNotificationMessageForUnprotectedAppsKey: @YES,
        kPIPreferencesNoNotificationSoundForUnprotectedAppsKey: @NO,

        kPIPreferencesAutoEnableKey: @NO,

        kPIPreferencesEnablePasswordKey: @NO,
        kPIPreferencesPasswordKey: @"",

        kPIPreferencesDisableActivateAppSliderKey: @NO,
    }];
  return self;
}
- (void)dealloc {
  // Should never be called, but just here for clarity really.
  [super dealloc];
}

@end
