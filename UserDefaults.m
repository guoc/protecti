#import "UserDefaults.h"

// http://www.galloway.me.uk/tutorials/singleton-classes/
// http://sharedinstance.net/2014/11/settings-the-right-way/

@interface NSUserDefaults (Private)

- (instancetype)_initWithSuiteName:(NSString *)suiteName container:(NSURL *)container;

@end

static NSUserDefaults *sharedDefaults = nil;

@implementation UserDefaults

+ (void)updatePreferences {
    // http://sharedinstance.net/2014/11/settings-the-right-way/

    NSDictionary *protectedApps = [NSDictionary dictionaryWithContentsOfFile:[[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"Preferences"] stringByAppendingPathComponent:kPIPreferencesProtectedAppsDomain] stringByAppendingPathExtension:@"plist"]];
    NSDictionary *hiddenApps = [NSDictionary dictionaryWithContentsOfFile:[[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"Preferences"] stringByAppendingPathComponent:kPIPreferencesHiddenAppsDomain] stringByAppendingPathExtension:@"plist"]];
    [protectedApps enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        [UserDefaults.sharedDefaults setObject:object forKey: key];
    }];
    [hiddenApps enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        [UserDefaults.sharedDefaults setObject:object forKey: key];
    }];
}

#pragma mark Singleton Methods
+ (id)sharedDefaults {
  @synchronized(self) {
      if(sharedDefaults == nil)
          sharedDefaults = [[super allocWithZone:NULL] init];
  }
  return sharedDefaults;
}
+ (id)allocWithZone:(NSZone *)zone {
  return [[self sharedDefaults] retain];
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
  self = (UserDefaults *)[[NSUserDefaults alloc] _initWithSuiteName:kPIPreferencesDomain container:[NSURL URLWithString:@"/var/mobile"]];
//   [sharedDefaults registerDefaults:@{
//       kPIPreferencesEnabledKey: @YES
//     //   kHBCBPreferencesSwitchesKey: @[ /* ... */ ]
//     //   kHBCBPreferencesSectionLabelKey: @YES,
//     //   kHBCBPreferencesSwitchLabelsKey: @YES
//     }];
  return self;
}
- (void)dealloc {
  // Should never be called, but just here for clarity really.
  [super dealloc];
}

@end
