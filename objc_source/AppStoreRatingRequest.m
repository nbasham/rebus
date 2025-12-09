#import "AppStoreRatingRequest.h"
#import "Products.h"
#import "UsageTracking.h"
#import "AlertUtil.h"

@interface AppStoreRatingRequest()
-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@implementation AppStoreRatingRequest

-(void)showIfAppropriate {
    BOOL okToAskForRating = [DataUtil getBoolWithKey:@"okToAskForRating" withDefault:YES];
    //DebugLog(@"showRequestRatings.okToAskForRating = %@", [StringUtil getStringForBool:okToAskForRating]);
    if(okToAskForRating) {
        int count = [DataUtil getIntWithKey:@"request.rating.counter" withDefault:1] + 1;
        [DataUtil setInt:count withKey:@"request.rating.counter"];
        int period = [DeviceUtil isSimulator] ? 25 : 25;
        //DebugLog(@"showRequestRatings.count = %d, period = %d, c mod p = %d, checking if equal to %d", count, period, count % period, (period - 1));
        if(count % period == (period - 1) && ![RebusGlobals isUnpaid]) {
            NSString* title = [ResourceManager getLocalizedString:@"request.rating.title" module:nil isPortrait:NO];
            NSString* message = [ResourceManager getLocalizedString:@"request.rating.message" module:nil isPortrait:NO];
            NSString* productName = [Products getProductName];
            message = [NSString stringWithFormat:message, productName];
            NSString* yes = [ResourceManager getLocalizedString:@"request.rating.option.yes" module:nil isPortrait:NO];
            NSString* later = [ResourceManager getLocalizedString:@"request.rating.option.later" module:nil isPortrait:NO];
            NSString* no = [ResourceManager getLocalizedString:@"request.rating.option.no" module:nil isPortrait:NO];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:yes, later, no, nil];
            [alert show];
        }
    }
}

-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [SimpleSoundManager play:@"button"];
    int timesDeferred = [DataUtil getIntWithKey:@"request.rating.count" withDefault:0] + 1;
    NSString* label = @"";
    if(timesDeferred != 0) {
        label = [NSString stringWithFormat:@"%d", timesDeferred];
    }
    NSString* choice = @"undefined";
    if (buttonIndex == 0) {
        if([DeviceUtil isSimulator]) {
            [AlertUtil showLocalizedOKAlert:@"app.store.simulator"];
        } else {
            [Products navigateToReviewPage];
        }
        choice = @"yes";
        [DataUtil setBool:NO withKey:@"okToAskForRating"];
    }
    else if (buttonIndex == 1) {
        choice = @"later";
        [DataUtil setInt:timesDeferred withKey:@"request.rating.count"];
    }
    else if (buttonIndex == 2) {
        choice = @"no";
        [DataUtil setBool:NO withKey:@"okToAskForRating"];
    }
    [UsageTracking trackEvent:@"rating.request" action:choice label:label value: -1];
}

@end
