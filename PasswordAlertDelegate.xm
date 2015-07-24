#import "PasswordAlertDelegate.h"

#import <UIKit/UIKit.h>

#import "prefs.h"
#import "PIPreferences.h"

#define LOCAL(key) [bundle localizedStringForKey:key value:key table:nil]

void _disableProtectiPlusWithoutPassword();

%subclass PasswordAlertDelegate : NSObject <UITextFieldDelegate, UIAlertViewDelegate>

%new
- (UIAlertView *)alertView {
    return objc_getAssociatedObject(self, @selector(alertView));
}

%new
- (void)setAlertView: (UIAlertView *)value {
    objc_setAssociatedObject(self, @selector(alertView), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
- (void)showAlert {
    NSBundle *bundle = [NSBundle bundleWithPath:@"/Library/PreferenceBundles/ProtectiPlusSettings.bundle"];
    NSString *alertTitle = HidePasswordAlertMessage_IsEnabled ? @"" : LOCAL(@"PASSWORD_ALERT_TITLE");
    NSString *alertMessage = HidePasswordAlertMessage_IsEnabled ? @"" : LOCAL(@"PASSWORD_ALERT_MESSAGE");
    self.alertView = [[[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:LOCAL(@"PASSWORD_ALERT_DISMISS") otherButtonTitles:nil] autorelease];
    self.alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;

    NSString * password = GetValueOf_Password;
    if (![[password stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] isEqualToString:@""])
    {   //说明包含非数字 使用默认键盘
        [[self.alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
    }
    else
    {
        [[self.alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    }

    [[self.alertView textFieldAtIndex:0] setDelegate:self];

    [self.alertView show];
}

%new
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([[textField.text stringByReplacingCharactersInRange:range withString:string] isEqualToString:GetValueOf_Password])
    {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _disableProtectiPlusWithoutPassword();
//        });

        [self.alertView dismissWithClickedButtonIndex:0 animated:YES];

        textField.text = @"";
    }
	return YES;
}

%end
