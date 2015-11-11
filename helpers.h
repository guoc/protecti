#import <QuartzCore/QuartzCore.h>
#include <notify.h>

void refreshNotificationCenter();
void iconsVisibilityChanged();
void vibrateIfNecessary();
void updateIconBadgeView();
void removeProtectedOrHiddenAppsInAppSwitcher();
void killApplicationUnderLockScreenIfNecessary();
void exitForegroundApplicationIfNecessary();
void killApplicationByAppID(NSString *appID);
void updateSpotlight_ios9();
BOOL appIdentifierIsInProtectedAppsList(NSString *appIdentifier);
BOOL appIdentifierIsInHiddenAppsList(NSString *appIdentifier);

/************* Compatible with Tage **************/    // From SimpleReach
BOOL tageIsInstalled();
int readTagePrefsSwipeSideEnabled();
void cacheAndModifyTagePrefsSwipeSideEnabledIfNecessary();
void restoreTagePrefsSwipeSideEnabledIfNecessaryWithDelay(CGFloat delay);
