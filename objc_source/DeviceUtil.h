#import <Foundation/Foundation.h>

@interface DeviceUtil : NSObject {
    BOOL iPad;
    int deviceWidth;
    int deviceHeight;
}

+(BOOL)isPad;
+(BOOL)isPhone;
+(int)deviceWidth;
+(int)deviceHeight;
+(int)deviceWidthPortrait;
+(int)deviceHeightPortrait;
+(BOOL)isSimulator;
+(BOOL)osVersionSupported:(NSString*)version;

@end
