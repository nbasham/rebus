#import "Products.h"
#import "UsageTracking.h"
#import "AlertUtil.h"

@interface Products()
    @property(nonatomic, assign) BOOL isCryptogram;
    @property(nonatomic, assign) BOOL isQuotefalls;
    @property(nonatomic, assign) BOOL isSudoku;
    @property(nonatomic, assign) BOOL isCryptoFamilies;
    @property(nonatomic, assign) BOOL isRebus;
    @property(nonatomic, strong) NSString* productKey;
    @property(nonatomic, strong) NSString* appId;
    @property(nonatomic, strong) NSString* productName;
    @property(nonatomic, strong) NSString* productClassName;
    @property(nonatomic, strong) NSString* productClassNamePrefix;
    @property(nonatomic, strong) NSString* iTunesUrl;
    +(Products*)sharedInstance;
@end

@implementation Products

@synthesize isCryptogram;
@synthesize isQuotefalls;
@synthesize isSudoku;
@synthesize isCryptoFamilies;
@synthesize isRebus;
@synthesize productKey;
@synthesize appId;
@synthesize productName;
@synthesize productClassName;
@synthesize productClassNamePrefix;
@synthesize iTunesUrl;

+(Products*)sharedInstance {
    static Products* myInstance = nil;
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        myInstance.productKey = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"productKey"] lowercaseString];
        myInstance.isCryptogram = [myInstance.productKey isEqualToString:@"cryptogram"];
        myInstance.isQuotefalls = [myInstance.productKey isEqualToString:@"quotefalls"];
        myInstance.isSudoku = [myInstance.productKey isEqualToString:@"sudoku"];
        myInstance.isCryptoFamilies = [myInstance.productKey isEqualToString:@"crypto-families"];
        myInstance.isRebus = [myInstance.productKey isEqualToString:@"rebus"];

        if(myInstance.isCryptogram) {
            myInstance.appId = @"380210791";
        } else if(myInstance.isCryptoFamilies) {
            myInstance.appId = @"386532458";
        } else if(myInstance.isSudoku) {
            myInstance.appId = @"364295181";
        } else if(myInstance.isQuotefalls) {
            myInstance.appId = @"392990960";
        } else if(myInstance.isRebus) {
            myInstance.appId = @"506800979";
        }

        if(myInstance.isCryptogram) {
            myInstance.iTunesUrl = @"http://itunes.apple.com/us/app/cryptogram/id380210791?mt=8";
        } else if(myInstance.isCryptoFamilies) {
            myInstance.iTunesUrl = @"http://itunes.apple.com/us/app/crypto-families-hd/id386532458?mt=8";
        } else if(myInstance.isSudoku) {
            myInstance.iTunesUrl = @"http://itunes.apple.com/us/app/sudoku-takeout/id364295181?mt=8";
        } else if(myInstance.isQuotefalls) {
            myInstance.iTunesUrl = @"http://itunes.apple.com/us/app/quotefalls/id392990960?mt=8";
        } else if(myInstance.isRebus) {
            myInstance.iTunesUrl = @"http://itunes.apple.com/us/app/the-rebus-show/id506800979?mt=8";
        }
        myInstance.productName = NSLocalizedString(myInstance.productKey, myInstance.productKey);

        if(myInstance.isCryptoFamilies) {
            myInstance.productClassNamePrefix = @"CryptoFamilies";
        } else {
            myInstance.productClassNamePrefix = [myInstance.productKey stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[myInstance.productKey substringToIndex:1] capitalizedString]];
        }
    }
    return myInstance;
}

+(BOOL)isCryptogram {
    return [[Products sharedInstance] isCryptogram];
}

+(BOOL)isQuotefalls {
    return [[Products sharedInstance] isQuotefalls];
}

+(BOOL)isSudoku {
    return [[Products sharedInstance] isSudoku];
}

+(BOOL)isCryptoFamilies {
    return [[Products sharedInstance] isCryptoFamilies];
}

+(BOOL)isRebus {
    return [[Products sharedInstance] isRebus];
}

+(NSString*)getProductName {
    return [[Products sharedInstance] productName];
}

+(NSString*)productKeyToClassName:(NSString*)suffix {
    NSString* s = [NSString stringWithFormat:@"%@%@", [Products productKeyToClassNamePrefix], suffix];
    return s;
}

+(NSString*)productKeyToClassNamePrefix {
    return [[Products sharedInstance] productClassNamePrefix];
}

+(NSString*)productKeyToAppStoreUrl:(NSString*)productKey {
    NSString* urlStr = nil;
    if(productKey == nil) {
        productKey = [[Products sharedInstance] productKey];
    }
    if([productKey isEqualToString:@"cryptogram"]) {
        urlStr = @"http://itunes.apple.com/us/app/cryptogram/id380210791?mt=8";
    } else if([productKey isEqualToString:@"crypto-families"]) {
        urlStr = @"http://itunes.apple.com/us/app/crypto-families-hd/id386532458?mt=8";
    } else if([productKey isEqualToString:@"sudoku"]) {
        urlStr = @"http://itunes.apple.com/us/app/sudoku-takeout/id364295181?mt=8";
    } else if([productKey isEqualToString:@"quotefalls"]) {
        urlStr = @"http://itunes.apple.com/us/app/quotefalls/id392990960?mt=8";
    } else if([productKey isEqualToString:@"rebus"]) {
        urlStr = @"http://itunes.apple.com/us/app/the-rebus-show/id506800979?mt=8";
    }
    return urlStr;
}

+(void)launchAppStoreForProduct:(NSString*)productKey {
	if([DeviceUtil isSimulator]) {
        [AlertUtil showOKAlert:[NSString stringWithFormat:@"The simulator can't launch '%@' the App Store", productKey]];
	} else {
        NSString* urlStr = [Products productKeyToAppStoreUrl:productKey];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
}

+(NSString*)getAppId {
    return [[Products sharedInstance] appId];
}

+(void)navigateToReviewPage {
    NSString* s = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", [Products getAppId]]; 
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:s]];
}

+(void)navigateToGiftForAppWithId:(NSString*)appId {
    NSString* s = [NSString stringWithFormat:@"https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/giftSongsWizard?gift=1&salableAdamId=%@&productType=C&pricingParameter=STDQ", appId]; 
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:s]];
}

@end
