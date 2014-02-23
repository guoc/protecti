@interface PICheck : NSObject

+ (NSString *)getUdid;
+ (void)tryToSaveKey;
+ (BOOL)keyIsValid;
+ (BOOL)keyIsReallyValid;
+ (BOOL)needGiveMilkPowderMoney;

@end