#import "DeviceUtil.h"

@interface DeviceUtil()
    @property(nonatomic, assign) BOOL iPad;
    @property(nonatomic, assign) BOOL isSimulator;
	+(DeviceUtil*)sharedInstance;
@end

@implementation DeviceUtil

@synthesize iPad;

@synthesize isSimulator;

//	e.g. [DeviceUtil osVersionSupported:@"4.1"]
+(BOOL)osVersionSupported:(NSString*)version {
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:version options:NSNumericSearch] != NSOrderedAscending);
	return osVersionSupported;
}

+(BOOL)isPad {
    return [[DeviceUtil sharedInstance] iPad];
}

+(int)deviceWidth {
    return [DeviceUtil isPad] ? 1024 : 480;
}

+(int)deviceHeight {
    return [DeviceUtil isPad] ? 768 : 320;
}

+(int)deviceWidthPortrait {
    return [DeviceUtil isPad] ? 768 : 320;
}

+(int)deviceHeightPortrait {
    return [DeviceUtil isPad] ? 1024 : 480;
}

+(BOOL)isPhone {
    return ![[DeviceUtil sharedInstance] iPad];
}

+(BOOL)isSimulator {
    return [[DeviceUtil sharedInstance] isSimulator];
}

+(DeviceUtil*)sharedInstance {
    static DeviceUtil* myInstance = nil;
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            myInstance.iPad = YES;
        } else {
            myInstance.iPad = NO;
        }
        NSString* model = [[UIDevice currentDevice] model];
        NSRange range = [model rangeOfString:@"Simulator" options:NSCaseInsensitiveSearch];
        if(range.location != NSNotFound) {
            myInstance.isSimulator = YES;
        }
    }
    return myInstance;
}


@end
