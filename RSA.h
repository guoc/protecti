#import <Foundation/Foundation.h>

@interface RSA : NSObject {
    SecKeyRef publicKey;
    SecCertificateRef certificate;
    SecPolicyRef policy;
    SecTrustRef trust;
    size_t maxPlainLen;
}
- (NSData *) encryptWithData:(NSData *)content;
- (NSData *) encryptWithString:(NSString *)content;
- (NSString *) encryptToString:(NSString *)content;

- (NSData *) decryptWithDataToData:(NSData *)cipherData;
- (NSString *) decryptWithData:(NSData *)content;
- (NSString *) decryptWithString:(NSString *)content;

@end

