#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"

#import <notify.h>
#include "../states.h"

@interface ProtectiPlusFlipSwitchSwitch : NSObject <FSSwitchDataSource>
@end

@implementation ProtectiPlusFlipSwitchSwitch

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
	NSNumber *valueObj = [[NSDictionary dictionaryWithContentsOfFile:@kPreferencesStatePath] objectForKey:@"enable"];
	if (valueObj) {
		if ([valueObj boolValue]) { 
			return FSSwitchStateOn;
		} else {
			return FSSwitchStateOff;
		}
	} else {
		return FSSwitchStateIndeterminate;
	}
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
	if (newState == FSSwitchStateIndeterminate)
		return;
	if (newState == FSSwitchStateOn) {
		EnableProtectiPlus;
		return;
	}
	if (newState == FSSwitchStateOff) {
		DisableProtectiPlus;
		return;
	}
}

- (NSString *)titleForSwitchIdentifier:(NSString *)switchIdentifier
{
	return @"Protecti+";
}

@end
