#ifndef _prefs_h
#define _prefs_h

#import "PIPreferences.h"

#define kPreferencesPath "/var/mobile/Library/Preferences/com.gviridis.protectiplus.plist"
#define kPreferencesKeyPath "/var/mobile/Library/Preferences/com.gviridis.protectiplus.key"

#define HalfSlideUnlock_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"enableHalfSlideUnlock"] ? [[PIPreferences.sharedPreferences objectForKey:@"enableHalfSlideUnlock"] boolValue] : NO)
#define BypassSystemPasscode_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"enableBypassSystemPasscode"] ? [[PIPreferences.sharedPreferences objectForKey:@"enableBypassSystemPasscode"] boolValue] : NO)
#define Vibrate_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"enableVibrate"] ? [[PIPreferences.sharedPreferences objectForKey:@"enableVibrate"] boolValue] : NO)
#define StatusBarIcon_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"enableStatusBarIcon"] ? [[PIPreferences.sharedPreferences objectForKey:@"enableStatusBarIcon"] boolValue] : YES)
#define TurnOnBacklighWhenReceiveNewNotifications_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"enableTurnOnBacklighWhenReceiveNewNotifications"] ? [[PIPreferences.sharedPreferences objectForKey:@"enableTurnOnBacklighWhenReceiveNewNotifications"] boolValue] : NO)
#define VibrateNotifications_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"enableVibrateNotifications"] ? [[PIPreferences.sharedPreferences objectForKey:@"enableVibrateNotifications"] boolValue] : NO)
#define AllowAccessNotificationCenter_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"allowAccessNotificationCenter"] ? [[PIPreferences.sharedPreferences objectForKey:@"allowAccessNotificationCenter"] boolValue] : NO)
#define AllowAccessControlCenter_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"allowAccessControlCenter"] ? [[PIPreferences.sharedPreferences objectForKey:@"allowAccessControlCenter"] boolValue] : NO)
#define HideAppIcons_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"enableHideAppIcons"] ? [[PIPreferences.sharedPreferences objectForKey:@"enableHideAppIcons"] boolValue] : NO)
#define IndicateMissingNotification_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"enableIndicateMissingNotification"] ? [[PIPreferences.sharedPreferences objectForKey:@"enableIndicateMissingNotification"] boolValue] : NO)
#define GetValueOf_MissingNotificationIndicatorStyle \
([PIPreferences.sharedPreferences objectForKey:@"missingNotificationIndicatorStyle"] ? [[PIPreferences.sharedPreferences objectForKey:@"missingNotificationIndicatorStyle"] integerValue] : kTapped)
#define GetValueOf_HalfSlideUnlock_MinDistance \
([PIPreferences.sharedPreferences objectForKey:@"halfSlideUnlock_MinDistance"] ? [[PIPreferences.sharedPreferences objectForKey:@"halfSlideUnlock_MinDistance"] floatValue] : 0.2)
#define GetValueOf_HalfSlideUnlock_MaxDistance \
([PIPreferences.sharedPreferences objectForKey:@"halfSlideUnlock_MaxDistance"] ? [[PIPreferences.sharedPreferences objectForKey:@"halfSlideUnlock_MaxDistance"] floatValue] : 0.33)
//#define NoLoadSettingsWhenEnable_IsEnabled \
//([PIPreferences.sharedPreferences objectForKey:@"noLoadSettingsWhenEnable"] ? [[PIPreferences.sharedPreferences objectForKey:@"noLoadSettingsWhenEnable"] boolValue] : NO)

#define NoNotificationsForProtectedApps_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"noNotificationsForProtectedApps"] ? [[PIPreferences.sharedPreferences objectForKey:@"noNotificationsForProtectedApps"] boolValue] : NO)
#define NoNotificationTitleForProtectedApps_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"noNotificationTitleForProtectedApps"] ? [[PIPreferences.sharedPreferences objectForKey:@"noNotificationTitleForProtectedApps"] boolValue] : YES)
#define NoNotificationMessageForProtectedApps_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"noNotificationMessageForProtectedApps"] ? [[PIPreferences.sharedPreferences objectForKey:@"noNotificationMessageForProtectedApps"] boolValue] : YES)
#define NoNotificationSoundForProtectedApps_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"noNotificationSoundForProtectedApps"] ? [[PIPreferences.sharedPreferences objectForKey:@"noNotificationSoundForProtectedApps"] boolValue] : NO)

#define NoNotificationsForUnprotectedApps_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"noNotificationsForUnprotectedApps"] ? [[PIPreferences.sharedPreferences objectForKey:@"noNotificationsForUnprotectedApps"] boolValue] : NO)
#define NoNotificationTitleForUnprotectedApps_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"noNotificationTitleForUnprotectedApps"] ? [[PIPreferences.sharedPreferences objectForKey:@"noNotificationTitleForUnprotectedApps"] boolValue] : NO)
#define NoNotificationMessageForUnprotectedApps_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"noNotificationMessageForUnprotectedApps"] ? [[PIPreferences.sharedPreferences objectForKey:@"noNotificationMessageForUnprotectedApps"] boolValue] : YES)
#define NoNotificationSoundForUnprotectedApps_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"noNotificationSoundForUnprotectedApps"] ? [[PIPreferences.sharedPreferences objectForKey:@"noNotificationSoundForUnprotectedApps"] boolValue] : NO)

#define AutoEnable_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"autoEnable"] ? [[PIPreferences.sharedPreferences objectForKey:@"autoEnable"] boolValue] : NO)

#define EnablePassword_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"enablePassword"] ? [[PIPreferences.sharedPreferences objectForKey:@"enablePassword"] boolValue] : NO)
#define GetValueOf_Password \
([PIPreferences.sharedPreferences objectForKey:@"password"] ? : @"")

#define GetValueOf_DisabledFolders \
([PIPreferences.sharedPreferences objectForKey:@"disabledFolders"] ? : nil)

/* Options cross dylibs, another method is applied to get their preference value */
#define DisableAccessPhotos_IsEnabled \
([[[[NSUserDefaults standardUserDefaults] persistentDomainForName:kPIPreferencesDomain] objectForKey:kPIPreferencesDisableAccessPhotos] boolValue])

/********************************************* Hidden Options ****************************************************************/
#define DisableActivateAppSlider_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:@"disableActivateAppSlider"] ? [[PIPreferences.sharedPreferences objectForKey:@"disableActivateAppSlider"] boolValue] : NO)
/*****************************************************************************************************************************/

#endif
