#import "RebusGlobals.h"
#import "Products.h"

@implementation RebusGlobals

+(BOOL)isUnpaid {
    if([RebusGlobals isFreeApp]) {
        BOOL userPaidForApp = [DataUtil keyExists:kUserPayedForAppKey];
        return !userPaidForApp;
    }
    return NO;
}

+(BOOL)isFreeApp {
    BOOL isFreeApp = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"isFreeApp"] boolValue];
    return isFreeApp;
}

+(int)getControlPanelHeight {
    return [DeviceUtil isPad] ? 335 : 144;
}

+(int)getStageHeight {
    return [DeviceUtil isPad] ? 489 : 204;
}

+(NSString*)getProductName {
    NSString* product = [Products getProductName];
    if([RebusGlobals isFreeApp]) {
        product = [NSString stringWithFormat:@"%@ Free", product];
    }
    return product;
}

+(BOOL)didUserJustUpdate:(NSString*)tokenKey {
    if([RebusGlobals isFreeApp]) {
        if([DataUtil keyExists:kUserPayedForAppKey]) {
            if([DataUtil isKeyUndefinedThenDefine:tokenKey]) {
                DebugLog(@"true == didUserJustUpdate:@'%@'", tokenKey);
                return YES;
            }
        }
    }
    return NO;
}

@end
