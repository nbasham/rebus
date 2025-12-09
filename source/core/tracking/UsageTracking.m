#import "UsageTracking.h"
#import "GANTracker.h"
#import "Settings.h"

#define TRACKING YES

@interface UsageTracking(Private)
    +(void)track:(int)what data:(NSString*)data;
    +(BOOL)shouldTrack;
    +(void)track:(int)what;
    +(void)track:(int)what data:(NSString*)data;
@end

@implementation UsageTracking

+(BOOL)shouldTrack {
    if([DeviceUtil isSimulator]) {
        return NO;
    }
    BOOL userTracking = [Settings getUsageTracking];
    return userTracking && TRACKING;
}

+(void)initAnalytics {
    NSString* trackingAccountId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"tracking"];
    [[GANTracker sharedTracker] startTrackerWithAccountID:trackingAccountId dispatchPeriod:10 delegate:nil];
    [[GANTracker sharedTracker] setDebug:NO];
    [[GANTracker sharedTracker] setDryRun:NO];
}

+(void)destroyAnalytics {
    [[GANTracker sharedTracker] dispatch];
    [[GANTracker sharedTracker] stopTracker];
}


+(void)trackPageView:(NSString*)pageUrl {
    if(![UsageTracking shouldTrack]) {
        return;
    }
    @try {
        NSError* error;
        if (
            ![[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"/%@", pageUrl] withError:&error]
            ) {
            DebugLog(@"trackPageView '%@' error: %@", pageUrl, error);
        }
    }
    @catch (NSException* e) {
		DebugLog(@"UsageTracking.trackPageView: %@", e);
    }    
}

//  Events detailed at https://www.google.com/fusiontables/DataSource?snapid=S280932PzsI
+(void)trackEvent:(NSString*)category action:(NSString*)action label:(NSString*)label value:(NSInteger)value {
    if(![UsageTracking shouldTrack]) {
        return;
    }
    @try {
        NSError* error;
        if (![[GANTracker sharedTracker] trackEvent:category == nil ? @"" : category
                                             action:action == nil ? @"" : action
                                              label:label == nil ? @"" : label
                                              value:value
                                          withError:&error]
            ) {
            DebugLog(@"trackEvent %@/%@/%@ error: %@", category, action, label, error);
        }
    }
    @catch (NSException* e) {
		DebugLog(@"UsageTracking.trackEvent: %@", e);
    }    
}

@end
