#ifndef _prefs_h
#define _prefs_h

#import "PIPreferences.h"

#define kPreferencesPath "/var/mobile/Library/Preferences/com.gviridis.protectiplus.plist"
#define kPreferencesKeyPath "/var/mobile/Library/Preferences/com.gviridis.protectiplus.key"

#define HalfSlideUnlock_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesEnableHalfSlideUnlockKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesEnableHalfSlideUnlockKey] boolValue] : NO)
#define BypassSystemPasscode_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesEnableBypassSystemPasscodeKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesEnableBypassSystemPasscodeKey] boolValue] : NO)
#define Vibrate_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesEnableVibrateKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesEnableVibrateKey] boolValue] : NO)
#define StatusBarIcon_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesEnableStatusBarIconKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesEnableStatusBarIconKey] boolValue] : YES)
#define TurnOnBacklighWhenReceiveNewNotifications_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesEnableTurnOnBacklighWhenReceiveNewNotificationsKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesEnableTurnOnBacklighWhenReceiveNewNotificationsKey] boolValue] : NO)
#define VibrateNotifications_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesEnableVibrateNotificationsKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesEnableVibrateNotificationsKey] boolValue] : NO)
#define AllowAccessNotificationCenter_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesAllowAccessNotificationCenterKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesAllowAccessNotificationCenterKey] boolValue] : NO)
#define AllowAccessControlCenter_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesAllowAccessControlCenterKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesAllowAccessControlCenterKey] boolValue] : NO)
#define HideAppIcons_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesEnableHideAppIconsKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesEnableHideAppIconsKey] boolValue] : NO)
#define IndicateMissingNotification_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesEnableIndicateMissingNotificationKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesEnableIndicateMissingNotificationKey] boolValue] : NO)
#define GetValueOf_MissingNotificationIndicatorStyle \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesMissingNotificationIndicatorStyleKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesMissingNotificationIndicatorStyleKey] integerValue] : kTapped)
#define GetValueOf_HalfSlideUnlock_MinDistance \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesHalfSlideUnlock_MinDistanceKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesHalfSlideUnlock_MinDistanceKey] floatValue] : 0.2)
#define GetValueOf_HalfSlideUnlock_MaxDistance \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesHalfSlideUnlock_MaxDistanceKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesHalfSlideUnlock_MaxDistanceKey] floatValue] : 0.33)
#define NoLoadSettingsWhenEnable_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesNoLoadSettingsWhenEnableKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesNoLoadSettingsWhenEnableKey] boolValue] : NO)

#define NoNotificationsForProtectedApps_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesNoNotificationsForProtectedAppsKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesNoNotificationsForProtectedAppsKey] boolValue] : NO)
#define NoNotificationTitleForProtectedApps_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesNoNotificationTitleForProtectedAppsKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesNoNotificationTitleForProtectedAppsKey] boolValue] : YES)
#define NoNotificationMessageForProtectedApps_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesNoNotificationMessageForProtectedAppsKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesNoNotificationMessageForProtectedAppsKey] boolValue] : YES)
#define NoNotificationSoundForProtectedApps_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesNoNotificationSoundForProtectedAppsKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesNoNotificationSoundForProtectedAppsKey] boolValue] : NO)

#define NoNotificationsForUnprotectedApps_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesNoNotificationsForUnprotectedAppsKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesNoNotificationsForUnprotectedAppsKey] boolValue] : NO)
#define NoNotificationTitleForUnprotectedApps_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesNoNotificationTitleForUnprotectedAppsKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesNoNotificationTitleForUnprotectedAppsKey] boolValue] : NO)
#define NoNotificationMessageForUnprotectedApps_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesNoNotificationMessageForUnprotectedAppsKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesNoNotificationMessageForUnprotectedAppsKey] boolValue] : YES)
#define NoNotificationSoundForUnprotectedApps_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesNoNotificationSoundForUnprotectedAppsKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesNoNotificationSoundForUnprotectedAppsKey] boolValue] : NO)

#define AutoEnable_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesAutoEnableKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesAutoEnableKey] boolValue] : NO)

#define EnablePassword_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesEnablePasswordKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesEnablePasswordKey] boolValue] : NO)
#define GetValueOf_Password \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesPasswordKey] ? : @"")
#define HidePasswordAlertMessage_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesHidePasswordAlertMessageKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesHidePasswordAlertMessageKey] boolValue] : NO)

#define GetValueOf_DisabledFolders \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesDisabledFoldersKey] ? : nil)

/* Options cross dylibs, another method is applied to get their preference value */
#define DisableAccessPhotos_IsEnabled \
([[NSDictionary dictionaryWithContentsOfFile:@kPreferencesPath][kPIPreferencesDisableAccessPhotos] boolValue])    // Default value is NO.

/********************************************* Hidden Options ****************************************************************/
#define DisableActivateAppSlider_IsEnabled \
([PIPreferences.sharedPreferences objectForKey:kPIPreferencesDisableActivateAppSliderKey] ? [[PIPreferences.sharedPreferences objectForKey:kPIPreferencesDisableActivateAppSliderKey] boolValue] : NO)
/*****************************************************************************************************************************/

#endif
