#import <UIKit/UIKit.h>

@interface PasswordAlertDelegate : NSObject <UITextFieldDelegate, UIAlertViewDelegate>
@property (retain) UIAlertView *alertView;
- (void)showAlert;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
@end
