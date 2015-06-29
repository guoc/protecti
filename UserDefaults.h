static NSString *const kPIPreferencesDomain = @"com.gviridis.protectiplus";
static NSString *const kPIPreferencesProtectedAppsDomain = @"com.gviridis.protectiplus.protectedapps";
static NSString *const kPIPreferencesHiddenAppsDomain = @"com.gviridis.protectiplus.hiddenapps";
static NSString *const kPIPreferencesEnabledKey = @"Enabled";

@interface UserDefaults: NSUserDefaults

+ (void)updatePreferences;

#pragma mark Singleton Methods
+ (id)sharedDefaults;
+ (id)allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;
- (id)retain;
- (unsigned)retainCount;
- (oneway void)release;
- (id)autorelease;
- (id)init;
- (void)dealloc;

@end
