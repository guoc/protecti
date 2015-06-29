#ifndef _prefs_h
#define _prefs_h

#define kPreferencesPath "/var/mobile/Library/Preferences/com.gviridis.protectiplus.plist"
#define kPreferencesKeyPath "/var/mobile/Library/Preferences/com.gviridis.protectiplus.key"

typedef enum MissingNotificationIndicatorStyle : NSUInteger {
    kNone = 0,
    kTapped,
    kShadow,
    kGlow
} MissingNotificationIndicatorStyle;

#define HalfSlideUnlock_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"enableHalfSlideUnlock"] ? [[UserDefaults.sharedDefaults objectForKey:@"enableHalfSlideUnlock"] boolValue] : NO)
#define BypassSystemPasscode_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"enableBypassSystemPasscode"] ? [[UserDefaults.sharedDefaults objectForKey:@"enableBypassSystemPasscode"] boolValue] : NO)
#define Vibrate_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"enableVibrate"] ? [[UserDefaults.sharedDefaults objectForKey:@"enableVibrate"] boolValue] : NO)
#define StatusBarIcon_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"enableStatusBarIcon"] ? [[UserDefaults.sharedDefaults objectForKey:@"enableStatusBarIcon"] boolValue] : YES)
#define TurnOnBacklighWhenReceiveNewNotifications_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"enableTurnOnBacklighWhenReceiveNewNotifications"] ? [[UserDefaults.sharedDefaults objectForKey:@"enableTurnOnBacklighWhenReceiveNewNotifications"] boolValue] : NO)
#define VibrateNotifications_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"enableVibrateNotifications"] ? [[UserDefaults.sharedDefaults objectForKey:@"enableVibrateNotifications"] boolValue] : NO)
#define AllowAccessNotificationCenter_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"allowAccessNotificationCenter"] ? [[UserDefaults.sharedDefaults objectForKey:@"allowAccessNotificationCenter"] boolValue] : NO)
#define AllowAccessControlCenter_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"allowAccessControlCenter"] ? [[UserDefaults.sharedDefaults objectForKey:@"allowAccessControlCenter"] boolValue] : NO)
#define HideAppIcons_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"enableHideAppIcons"] ? [[UserDefaults.sharedDefaults objectForKey:@"enableHideAppIcons"] boolValue] : NO)
#define IndicateMissingNotification_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"enableIndicateMissingNotification"] ? [[UserDefaults.sharedDefaults objectForKey:@"enableIndicateMissingNotification"] boolValue] : NO)
#define GetValueOf_MissingNotificationIndicatorStyle \
([UserDefaults.sharedDefaults objectForKey:@"missingNotificationIndicatorStyle"] ? [[UserDefaults.sharedDefaults objectForKey:@"missingNotificationIndicatorStyle"] integerValue] : kTapped)
#define GetValueOf_HalfSlideUnlock_MinDistance \
([UserDefaults.sharedDefaults objectForKey:@"halfSlideUnlock_MinDistance"] ? [[UserDefaults.sharedDefaults objectForKey:@"halfSlideUnlock_MinDistance"] floatValue] : 0.2)
#define GetValueOf_HalfSlideUnlock_MaxDistance \
([UserDefaults.sharedDefaults objectForKey:@"halfSlideUnlock_MaxDistance"] ? [[UserDefaults.sharedDefaults objectForKey:@"halfSlideUnlock_MaxDistance"] floatValue] : 0.33)
//#define NoLoadSettingsWhenEnable_IsEnabled \
//([UserDefaults.sharedDefaults objectForKey:@"noLoadSettingsWhenEnable"] ? [[UserDefaults.sharedDefaults objectForKey:@"noLoadSettingsWhenEnable"] boolValue] : NO)

#define NoNotificationsForProtectedApps_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"noNotificationsForProtectedApps"] ? [[UserDefaults.sharedDefaults objectForKey:@"noNotificationsForProtectedApps"] boolValue] : NO)
#define NoNotificationTitleForProtectedApps_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"noNotificationTitleForProtectedApps"] ? [[UserDefaults.sharedDefaults objectForKey:@"noNotificationTitleForProtectedApps"] boolValue] : YES)
#define NoNotificationMessageForProtectedApps_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"noNotificationMessageForProtectedApps"] ? [[UserDefaults.sharedDefaults objectForKey:@"noNotificationMessageForProtectedApps"] boolValue] : YES)
#define NoNotificationSoundForProtectedApps_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"noNotificationSoundForProtectedApps"] ? [[UserDefaults.sharedDefaults objectForKey:@"noNotificationSoundForProtectedApps"] boolValue] : NO)

#define NoNotificationsForUnprotectedApps_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"noNotificationsForUnprotectedApps"] ? [[UserDefaults.sharedDefaults objectForKey:@"noNotificationsForUnprotectedApps"] boolValue] : NO)
#define NoNotificationTitleForUnprotectedApps_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"noNotificationTitleForUnprotectedApps"] ? [[UserDefaults.sharedDefaults objectForKey:@"noNotificationTitleForUnprotectedApps"] boolValue] : NO)
#define NoNotificationMessageForUnprotectedApps_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"noNotificationMessageForUnprotectedApps"] ? [[UserDefaults.sharedDefaults objectForKey:@"noNotificationMessageForUnprotectedApps"] boolValue] : YES)
#define NoNotificationSoundForUnprotectedApps_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"noNotificationSoundForUnprotectedApps"] ? [[UserDefaults.sharedDefaults objectForKey:@"noNotificationSoundForUnprotectedApps"] boolValue] : NO)

#define AutoEnable_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"autoEnable"] ? [[UserDefaults.sharedDefaults objectForKey:@"autoEnable"] boolValue] : NO)

#define EnablePassword_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"enablePassword"] ? [[UserDefaults.sharedDefaults objectForKey:@"enablePassword"] boolValue] : NO)
#define GetValueOf_Password \
([UserDefaults.sharedDefaults objectForKey:@"password"] ? : @"")



/********************************************* Hidden Options ****************************************************************/
#define DisableActivateAppSlider_IsEnabled \
([UserDefaults.sharedDefaults objectForKey:@"disableActivateAppSlider"] ? [[UserDefaults.sharedDefaults objectForKey:@"disableActivateAppSlider"] boolValue] : NO)
#define GetValueOf_DisabledFolders \
([UserDefaults.sharedDefaults objectForKey:@"disabledFolders"] ? : nil)
/*****************************************************************************************************************************/

#endif
