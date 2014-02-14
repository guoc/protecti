#import <MobileGestalt/MobileGestalt.h>
#import "RSA.h"
#import "NSString+Base64.h"
#import "NSData+Base64.h"

#import "PICheck.h"

#import "prefs.h"

static unsigned int global_CheckCount = 0;

@implementation PICheck

+ (NSString *)getUdid {
    CFStringRef value = (CFStringRef)MGCopyAnswer(kMGUniqueDeviceID);
    NSString *_udid = [NSString stringWithString:(NSString *)value];
    CFRelease(value);
    return _udid;
}

+ (void)tryToSaveKey {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *urlHead = @"http://gviridis.com/yjvg/yjvg.php/org.thebigboss.protectiplus?";
        NSString *qyqqmaStr = [PICheck qyqqma];
        NSString *url = [urlHead stringByAppendingFormat:@"qyqqma=%@",[PICheck urlsafe_b64encode:qyqqmaStr]];
        NSMutableURLRequest *request = [NSMutableURLRequest new];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"GET"];
        NSURLResponse *response;
        NSData *fjhvviEncryptedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        [fjhvviEncryptedData writeToFile:@kPreferencesKeyPath atomically:YES];
    });
    
    return;
}

+ (BOOL)keyIsValid {
    if ([[NSFileManager defaultManager]fileExistsAtPath:@kPreferencesKeyPath]) {
        NSData *keyData = [NSData dataWithContentsOfFile:@kPreferencesKeyPath];
        NSString *keyEncryptedStr = [PICheck urlsafe_b64decode:[[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding]];
        RSA *rsa = [[RSA alloc] init];
        if (rsa != nil) {
            NSString *keyDecryptedStr = [[rsa decryptWithString:keyEncryptedStr] base64DecodedString];
            NSArray *keyInfoArray = [keyDecryptedStr componentsSeparatedByString:@"_"];
            if ([keyInfoArray[0] isEqualToString:[PICheck getUdid]] && [keyInfoArray[1] isEqualToString:@"completed"]) {
                return YES;
            } else {
                return NO;
            }
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

+ (BOOL)needGiveMilkPowderMoney {
    if ([PICheck keyIsValid]) {
        return NO;
    } else {
        if (global_CheckCount == 0) {
            global_CheckCount = 3 + arc4random() % 3;
            return YES;
        } else {
            global_CheckCount--;
            return NO;
        }
    }
}

+ (NSString *)qyqqma {
    NSString *udid = [PICheck getUdid];
    
    NSTimeInterval time = [[[NSDate alloc] init] timeIntervalSince1970];
    
    NSString *encryptedQyqqmaStr = [NSString stringWithFormat:@"%@_%f",udid,time];
    
    RSA *rsa = [[RSA alloc] init];
    if (rsa != nil) {
        return [rsa encryptToString:encryptedQyqqmaStr];
    }
    return nil;
}

+ (NSString *)urlsafe_b64encode:(NSString *)str {
    return [[str stringByReplacingOccurrencesOfString:@"+" withString:@"-"] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
}

+ (NSString *)urlsafe_b64decode:(NSString *)str {
    return [[str stringByReplacingOccurrencesOfString:@"_" withString:@"/"] stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
}

@end
