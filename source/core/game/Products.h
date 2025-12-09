#import <Foundation/Foundation.h>

@interface Products : NSObject {
    BOOL isCryptogram;
    BOOL isQuotefalls;
    BOOL isSudoku;
    BOOL isCryptoFamilies;
    BOOL isRebus;
    NSString* productKey;
    NSString* appId;
    NSString* productName;
    NSString* productClassNamePrefix;
    NSString* iTunesUrl;
}

+(NSString*)getProductName;
+(NSString*)productKeyToClassName:(NSString*)suffix;
+(NSString*)productKeyToClassNamePrefix;
+(NSString*)productKeyToAppStoreUrl:(NSString*)productKey;
+(BOOL)isCryptogram;
+(BOOL)isQuotefalls;
+(BOOL)isSudoku;
+(BOOL)isCryptoFamilies;
+(BOOL)isRebus;
+(void)navigateToReviewPage;
+(NSString*)getAppId;
+(void)navigateToGiftForAppWithId:(NSString*)appId;
+(void)launchAppStoreForProduct:(NSString*)productKey;

@end
