#import "GameCenter.h"
#import "DeviceUtil.h"

//  http://developer.apple.com/library/ios/#documentation/NetworkingInternet/Conceptual/GameKit_Guide/GameCenterOverview/GameCenterOverview.html%23//apple_ref/doc/uid/TP40008304-CH5-SW16

@interface GameCenter()
	-(BOOL)isGameCenterAvailable;
	-(void)loadAchievements;
	+(GameCenter*)sharedInstance;
@end

@implementation GameCenter

@synthesize isAuthenticated;
@synthesize achievements;

+(GameCenter*)singleton {
    return [GameCenter sharedInstance];
}

+(GameCenter*)sharedInstance {
    static GameCenter* myInstance = nil;
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
   }
    return myInstance;
}

-(NSString*)getPlayerId {
	if(isAuthenticated) {
        return [GKLocalPlayer localPlayer].playerID;
    }
    return nil;
}

-(BOOL)isGameCenterAvailable {
    // Check for presence of GKLocalPlayer API.
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	BOOL osVersionSupported = [DeviceUtil osVersionSupported:@"4.1"];
    return (gcClass && osVersionSupported);
}

-(void)authenticateLocalPlayer {
	if([self isGameCenterAvailable]) {
		[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
			if (error == nil) {
				// Insert code here to handle a successful authentication.
				DebugLog(@"GameCenter authenticated");
				isAuthenticated = YES;
                [self loadAchievements];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"authenticatedGameCenterPlayer" object:nil];
			}
			else {
				// Your application can process the error parameter to report the error to the player.
				DebugLog(@"GameCenter NOT authenticated %@", error);
				isAuthenticated = NO;
			}
		}];
	}
}

-(void)loadAchievements {
    if(achievements == nil) {
        achievements = [NSMutableDictionary dictionary];
    } else {
        [achievements removeAllObjects];
    }
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray* serverAchievements, NSError *error) {
		 if (error == nil) {
			 for (GKAchievement* achievement in serverAchievements) {
				 [achievements setObject: achievement forKey: achievement.identifier];
			 }
		 }
	 }];
}

-(BOOL)hasAchievement:(NSString*)identifier {
	return [achievements objectForKey:identifier] != nil;
}

-(void)postScore:(int)score toCategory:(NSString*)category {
	if([self isGameCenterAvailable]) {
		GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
		scoreReporter.value = score;
		[scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
			if (error != nil) {
				DebugLog(@"Error posting score to GameCenter %@", [error description]);
			}
		}];
	}
}

//	ASSUMES delegate is a UIViewController
-(void)showScores:(id<GKLeaderboardViewControllerDelegate>)delegate {
	if([self isGameCenterAvailable]) {
        GKLeaderboardViewController* leaderboardController = [[GKLeaderboardViewController alloc] init];
        if (leaderboardController != nil) {
            leaderboardController.leaderboardDelegate = delegate;
            [(UIViewController*)delegate presentModalViewController: leaderboardController animated: YES];
        }
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"gamecenternotfound", @"gamecenternotfound") delegate: self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

//	ASSUMES delegate is a UIViewController
-(void)showAchievements:(id<GKAchievementViewControllerDelegate>)delegate {
	if([self isGameCenterAvailable]) {
        GKAchievementViewController* vc = [[GKAchievementViewController alloc] init];
        if (vc != nil) {
            vc.achievementDelegate = delegate;
            [(UIViewController*)delegate presentModalViewController: vc animated: YES];
        }
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"gamecenternotfound", @"gamecenternotfound") delegate: self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)reportAchievementIdentifier:(NSString*)identifier progress:(double)progress {
	if([self isGameCenterAvailable]) {
		GKAchievement* achievement = [[GKAchievement alloc] initWithIdentifier: identifier];
		if (achievement) {
//            if([DeviceUtil osVersionSupported:@"5.0"]) {
//                achievement.showsCompletionBanner = YES;
//            }
			achievement.percentComplete = progress;
			[achievement reportAchievementWithCompletionHandler:^(NSError *error) {
				if (error != nil) {
					DebugLog(@"Error posting achievement to GameCenter %@", [error description]);
				} else {
					[self loadAchievements];
				}

			}];
		}
	}
}

@end
