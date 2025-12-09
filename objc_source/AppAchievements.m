#import "AppAchievements.h"
#import "GameCenter.h"
#import "AppDelegate.h"

@interface AppAchievements(Private)
    -(void)expectedAchievements:(NSMutableArray*)achievements scores:(NSArray*)scores;
@end


@implementation AppAchievements

-(void)updateAchievementIfNecessary {
	if([GameCenter singleton].isAuthenticated) {
		NSDictionary* achievements = [[GameCenter singleton] achievements];
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSMutableArray* localAchievements = [NSMutableArray array];
		[self expectedAchievements:localAchievements scores:delegate.scores];
		for(NSString* identifier in localAchievements) {
			if([achievements objectForKey:identifier] == nil) {
				[[GameCenter singleton] reportAchievementIdentifier:identifier progress:100.0];
                DebugLog(@"Updating acheivement: %@", identifier);
			}
		}
        //  update progress for current acheivement
        NSString* identifier = [self getAchievementInProgressIdentifier];
        double progress = [self getAchievementProgress];
        [[GameCenter singleton] reportAchievementIdentifier:identifier progress:progress];
	}
}

-(NSString*)getAchievementInProgressIdentifier {
    return nil;
}

-(void)expectedAchievements:(NSMutableArray*)achievements scores:(NSArray*)scores {
    DebugLog(@"AppAchievements.expectedAchievements must be overriden by each app.");
}

-(double)getAchievementProgress {
    return 100.0;
}

@end
