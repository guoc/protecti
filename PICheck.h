@interface PICheck : NSObject

+ (NSString *)getUdid;
+ (void)tryToSaveKey;
+ (BOOL)keyIsValid;

@end