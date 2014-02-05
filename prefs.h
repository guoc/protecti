#ifndef _prefs_h
#define _prefs_h

#define kPreferencesPath "/var/mobile/Library/Preferences/com.gviridis.protectiplus.plist"

typedef enum MissingNotificationIndicatorStyle : NSUInteger {
    kNone = 0,
    kTapped,
    kShadow,
    kGlow
} MissingNotificationIndicatorStyle;

#define HalfSlideUnlock_IsEnabled \
([global_Preferences objectForKey:@"enableHalfSlideUnlock"] ? [[global_Preferences objectForKey:@"enableHalfSlideUnlock"] boolValue] : NO)
#define BypassPasscode_IsEnabled \
([global_Preferences objectForKey:@"enableBypassPasscode"] ? [[global_Preferences objectForKey:@"enableBypassPasscode"] boolValue] : NO)
#define Vibrate_IsEnabled \
([global_Preferences objectForKey:@"enableVibrate"] ? [[global_Preferences objectForKey:@"enableVibrate"] boolValue] : NO)
#define StatusBarIcon_IsEnabled \
([global_Preferences objectForKey:@"enableStatusBarIcon"] ? [[global_Preferences objectForKey:@"enableStatusBarIcon"] boolValue] : YES)
#define TurnOnBacklighWhenReceiveNewNotifications_IsEnabled \
([global_Preferences objectForKey:@"enableTurnOnBacklighWhenReceiveNewNotifications"] ? [[global_Preferences objectForKey:@"enableTurnOnBacklighWhenReceiveNewNotifications"] boolValue] : NO)
#define VibrateNotifications_IsEnabled \
([global_Preferences objectForKey:@"enableVibrateNotifications"] ? [[global_Preferences objectForKey:@"enableVibrateNotifications"] boolValue] : NO)
#define AllowAccessNotificationCenter_IsEnabled \
([global_Preferences objectForKey:@"allowAccessNotificationCenter"] ? [[global_Preferences objectForKey:@"allowAccessNotificationCenter"] boolValue] : NO)
#define AllowAccessControlCenter_IsEnabled \
([global_Preferences objectForKey:@"allowAccessControlCenter"] ? [[global_Preferences objectForKey:@"allowAccessControlCenter"] boolValue] : NO)
#define HideAppIcons_IsEnabled \
([global_Preferences objectForKey:@"enableHideAppIcons"] ? [[global_Preferences objectForKey:@"enableHideAppIcons"] boolValue] : NO)
#define IndicateMissingNotification_IsEnabled \
([global_Preferences objectForKey:@"enableIndicateMissingNotification"] ? [[global_Preferences objectForKey:@"enableIndicateMissingNotification"] boolValue] : NO)
#define GetValueOf_MissingNotificationIndicatorStyle \
([global_Preferences objectForKey:@"missingNotificationIndicatorStyle"] ? [[global_Preferences objectForKey:@"missingNotificationIndicatorStyle"] integerValue] : kTapped)
#define GetValueOf_HalfSlideUnlock_MinDistance \
([global_Preferences objectForKey:@"halfSlideUnlock_MinDistance"] ? [[global_Preferences objectForKey:@"halfSlideUnlock_MinDistance"] floatValue] : 0.2)
#define GetValueOf_HalfSlideUnlock_MaxDistance \
([global_Preferences objectForKey:@"halfSlideUnlock_MaxDistance"] ? [[global_Preferences objectForKey:@"halfSlideUnlock_MaxDistance"] floatValue] : 0.33)
//#define NoLoadSettingsWhenEnable_IsEnabled \
//([global_Preferences objectForKey:@"noLoadSettingsWhenEnable"] ? [[global_Preferences objectForKey:@"noLoadSettingsWhenEnable"] boolValue] : NO)

#define NoNotificationsForProtectedApps_IsEnabled \
([global_Preferences objectForKey:@"noNotificationsForProtectedApps"] ? [[global_Preferences objectForKey:@"noNotificationsForProtectedApps"] boolValue] : NO)
#define NoNotificationTitleForProtectedApps_IsEnabled \
([global_Preferences objectForKey:@"noNotificationTitleForProtectedApps"] ? [[global_Preferences objectForKey:@"noNotificationTitleForProtectedApps"] boolValue] : YES)
#define NoNotificationMessageForProtectedApps_IsEnabled \
([global_Preferences objectForKey:@"noNotificationMessageForProtectedApps"] ? [[global_Preferences objectForKey:@"noNotificationMessageForProtectedApps"] boolValue] : YES)
#define NoNotificationSoundForProtectedApps_IsEnabled \
([global_Preferences objectForKey:@"noNotificationSoundForProtectedApps"] ? [[global_Preferences objectForKey:@"noNotificationSoundForProtectedApps"] boolValue] : NO)

#define NoNotificationsForUnprotectedApps_IsEnabled \
([global_Preferences objectForKey:@"noNotificationsForUnprotectedApps"] ? [[global_Preferences objectForKey:@"noNotificationsForUnprotectedApps"] boolValue] : NO)
#define NoNotificationTitleForUnprotectedApps_IsEnabled \
([global_Preferences objectForKey:@"noNotificationTitleForUnprotectedApps"] ? [[global_Preferences objectForKey:@"noNotificationTitleForUnprotectedApps"] boolValue] : NO)
#define NoNotificationMessageForUnprotectedApps_IsEnabled \
([global_Preferences objectForKey:@"noNotificationMessageForUnprotectedApps"] ? [[global_Preferences objectForKey:@"noNotificationMessageForUnprotectedApps"] boolValue] : YES)
#define NoNotificationSoundForUnprotectedApps_IsEnabled \
([global_Preferences objectForKey:@"noNotificationSoundForUnprotectedApps"] ? [[global_Preferences objectForKey:@"noNotificationSoundForUnprotectedApps"] boolValue] : NO)

#define AutoEnable_IsEnabled \
([global_Preferences objectForKey:@"autoEnable"] ? [[global_Preferences objectForKey:@"autoEnable"] boolValue] : NO)

#define EnablePassword_IsEnabled \
([global_Preferences objectForKey:@"enablePassword"] ? [[global_Preferences objectForKey:@"enablePassword"] boolValue] : NO)
#define GetValueOf_Password \
([global_Preferences objectForKey:@"password"] ? : @"")

#endif
