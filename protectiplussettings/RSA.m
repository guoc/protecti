#import "RSA.h"
#import "NSString+Base64.h"
#import "NSData+Base64.h"

@implementation RSA

- (id)init {
    self = [super init];

    NSString *publicKeyPath = @"/Library/PreferenceBundles/ProtectiPlusSettings.bundle/public_key.der";
    if (publicKeyPath == nil) {
        HBLogError(@"Can not find pub.der");
        return nil;
    }

    NSData *publicKeyFileContent = [NSData dataWithContentsOfFile:publicKeyPath];
    if (publicKeyFileContent == nil) {
        HBLogError(@"Can not read from pub.der");
        return nil;
    }

    certificate = SecCertificateCreateWithData(kCFAllocatorDefault, ( __bridge CFDataRef)publicKeyFileContent);
    if (certificate == nil) {
        HBLogError(@"Can not read certificate from pub.der");
        return nil;
    }

    policy = SecPolicyCreateBasicX509();
    OSStatus returnCode = SecTrustCreateWithCertificates(certificate, policy, &trust);
    if (returnCode != 0) {
        HBLogError(@"SecTrustCreateWithCertificates fail. Error Code: %d", (int)returnCode);
        return nil;
    }

    SecTrustResultType trustResultType;
    returnCode = SecTrustEvaluate(trust, &trustResultType);
    if (returnCode != 0) {
        return nil;
    }

    publicKey = SecTrustCopyPublicKey(trust);
    if (publicKey == nil) {
        HBLogError(@"SecTrustCopyPublicKey fail");
        return nil;
    }

    maxPlainLen = SecKeyGetBlockSize(publicKey) - 12;
    return self;
}

- (NSData *) encryptWithData:(NSData *)content {

    size_t plainLen = [content length];
    if (plainLen > maxPlainLen) {
        HBLogError(@"content(%ld) is too long, must < %ld", plainLen, maxPlainLen);
        return nil;
    }

    void *plain = malloc(plainLen);
    [content getBytes:plain
               length:plainLen];

    size_t cipherLen = 256; // currently RSA key length is set to 128 bytes
    void *cipher = malloc(cipherLen);

    OSStatus returnCode = SecKeyEncrypt(publicKey, kSecPaddingPKCS1, plain,
                                        plainLen, cipher, &cipherLen);

    NSData *result = nil;
    if (returnCode != 0) {
        HBLogError(@"SecKeyEncrypt fail. Error Code: %d", (int)returnCode);
    }
    else {
        result = [NSData dataWithBytes:cipher
                                length:cipherLen];
    }

    free(plain);
    free(cipher);

    return result;
}

- (NSData *) encryptWithString:(NSString *)content {
    return [self encryptWithData:[content dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSString *) encryptToString:(NSString *)content {
    NSData *data = [self encryptWithString:content];
    return [data base64EncodedString];
}

/*
// convert NSData to NSString
- (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];

    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;

    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;

            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }

        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }

    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}
*/
- (NSData *) decryptWithDataToData:(NSData *)cipherData {
    
    size_t cipherDataLen = [cipherData length];
    
    void *cipher = malloc(cipherDataLen);
    [cipherData getBytes:cipher
               length:cipherDataLen];
    
    size_t plainTextLen = 256;
    void *plainText = malloc(plainTextLen);
    
    OSStatus returnCode = SecKeyDecrypt(publicKey, kSecPaddingPKCS1, cipher,
                                        cipherDataLen, plainText, &plainTextLen);
    
    NSData *result = nil;
    if (returnCode != 0) {
        HBLogError(@"SecKeyDecrypt fail. Error Code: %d", (int)returnCode);
    }
    else {
        result = [NSData dataWithBytes:plainText
                                length:plainTextLen];
    }
    
    free(plainText);
    free(cipher);
    
    return result;
}

- (NSString *) decryptWithData:(NSData *)content {
    return [[self decryptWithDataToData:content] base64EncodedString];
//    return [self decryptWithData:[content dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSString *) decryptWithString:(NSString *)content {
    return [self decryptWithData:[content base64DecodedData]];
}
/*
// convert NSData to NSString
- (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}
*/
- (void)dealloc{
    CFRelease(certificate);
    CFRelease(trust);
    CFRelease(policy);
    CFRelease(publicKey);
    [super dealloc];
}

@end

