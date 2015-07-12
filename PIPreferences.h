#import <Cephei/HBPreferences.h>

static NSString *const kPIPreferencesDomain = @"com.gviridis.protectiplus";
static NSString *const kPIPreferencesProtectedAppsDomain = @"com.gviridis.protectiplus.protectedapps";
static NSString *const kPIPreferencesHiddenAppsDomain = @"com.gviridis.protectiplus.hiddenapps";
static NSString *const kPIPreferencesEnabledKey = @"Enabled";

static NSString *const kPIPreferencesEnableHalfSlideUnlockKey = @"enableHalfSlideUnlock";
static NSString *const kPIPreferencesEnableBypassSystemPasscodeKey = @"enableBypassSystemPasscode";
static NSString *const kPIPreferencesEnableVibrateKey = @"enableVibrate";
static NSString *const kPIPreferencesEnableStatusBarIconKey = @"enableStatusBarIcon";
static NSString *const kPIPreferencesEnableTurnOnBacklighWhenReceiveNewNotificationsKey = @"enableTurnOnBacklighWhenReceiveNewNotifications";
static NSString *const kPIPreferencesEnableVibrateNotificationsKey = @"enableVibrateNotifications";
static NSString *const kPIPreferencesAllowAccessNotificationCenterKey = @"allowAccessNotificationCenter";
static NSString *const kPIPreferencesAllowAccessControlCenterKey = @"allowAccessControlCenter";
static NSString *const kPIPreferencesEnableHideAppIconsKey = @"enableHideAppIcons";
static NSString *const kPIPreferencesEnableIndicateMissingNotificationKey = @"enableIndicateMissingNotification";
static NSString *const kPIPreferencesMissingNotificationIndicatorStyleKey = @"missingNotificationIndicatorStyle";
static NSString *const kPIPreferencesHalfSlideUnlock_MinDistanceKey = @"halfSlideUnlock_MinDistance";
static NSString *const kPIPreferencesHalfSlideUnlock_MaxDistanceKey = @"halfSlideUnlock_MaxDistance";

static NSString *const kPIPreferencesNoNotificationsForProtectedAppsKey = @"noNotificationsForProtectedApps";
static NSString *const kPIPreferencesNoNotificationTitleForProtectedAppsKey = @"noNotificationTitleForProtectedApps";
static NSString *const kPIPreferencesNoNotificationMessageForProtectedAppsKey = @"noNotificationMessageForProtectedApps";
static NSString *const kPIPreferencesNoNotificationSoundForProtectedAppsKey = @"noNotificationSoundForProtectedApps";

static NSString *const kPIPreferencesNoNotificationsForUnprotectedAppsKey = @"noNotificationsForUnprotectedApps";
static NSString *const kPIPreferencesNoNotificationTitleForUnprotectedAppsKey = @"noNotificationTitleForUnprotectedApps";
static NSString *const kPIPreferencesNoNotificationMessageForUnprotectedAppsKey = @"noNotificationMessageForUnprotectedApps";
static NSString *const kPIPreferencesNoNotificationSoundForUnprotectedAppsKey = @"noNotificationSoundForUnprotectedApps";

static NSString *const kPIPreferencesAutoEnableKey = @"autoEnable";

static NSString *const kPIPreferencesEnablePasswordKey = @"enablePassword";
static NSString *const kPIPreferencesPasswordKey = @"password";

static NSString *const kPIPreferencesDisableActivateAppSliderKey = @"disableActivateAppSlider";
static NSString *const kPIPreferencesDisabledFoldersKey = @"disabledFolders";

typedef enum MissingNotificationIndicatorStyle : NSUInteger {
    kNone = 0,
    kTapped,
    kShadow,
    kGlow
} MissingNotificationIndicatorStyle;

@interface PIPreferences: HBPreferences

+ (void)updatePreferences;
+ (void)resetPreferences;

#pragma mark Singleton Methods
+ (id)sharedPreferences;
+ (id)allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;
- (id)retain;
- (unsigned)retainCount;
- (oneway void)release;
- (id)autorelease;
- (id)init;
- (void)dealloc;

@end
