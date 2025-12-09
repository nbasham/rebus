#import <Foundation/Foundation.h>

@interface Settings : NSObject {
    BOOL soundOn;
    BOOL showIncorrect;
    BOOL showTimer;
    BOOL usageTracking;
    float musicVolume;
}

+(BOOL)getSoundOn;
+(BOOL)getShowIncorrect;
+(BOOL)getShowTimer;
+(BOOL)getUsageTracking;
+(float)getMusicVolume;

@end
