#import "WelcomeAlertDelegate.h"
#import "states.h"
#import <SpringBoard/SpringBoard.h>

#define LOCAL(key) [bundle localizedStringForKey:key value:key table:nil]

@implementation WelcomeAlertDelegate
- (void)showAlert {
        NSBundle *bundle = [NSBundle bundleWithPath:@"/Library/PreferenceBundles/ProtectiPlusSettings.bundle"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCAL(@"WELCOME_TITLE") message:LOCAL(@"WELCOME_MESSAGE") delegate:self cancelButtonTitle:LOCAL(@"WELCOME_DISMISS") otherButtonTitles:LOCAL(@"WELCOME_SETTINGS"), nil];

        [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index {
    if (index == 1) {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"prefs:root=Protecti+&path=Tutorial"]];
    }
}
@end
