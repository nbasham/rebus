#import <Foundation/Foundation.h>

@interface UsageTracking : NSObject

+(void)initAnalytics;
+(void)destroyAnalytics;
+(void)trackPageView:(NSString*)pageUrl;
+(void)trackEvent:(NSString*)category action:(NSString*)action label:(NSString*)label value:(NSInteger)value;

@end

/*
 #import "UsageTracking.h"

 -(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UsageTracking track:kPuzzlePop];
}
*/