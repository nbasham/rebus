#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface GameCenter : NSObject {
	NSMutableDictionary* achievements;
	BOOL isAuthenticated;
}

+(GameCenter*)singleton;

@property(nonatomic, assign, readonly) BOOL isAuthenticated;
@property(nonatomic, retain) NSMutableDictionary* achievements;

-(void)authenticateLocalPlayer;
-(BOOL)hasAchievement:(NSString*)identifier;
-(void)postScore:(int)score toCategory:(NSString*)category;
-(void)reportAchievementIdentifier:(NSString*)identifier progress:(double)progress;
-(NSString*)getPlayerId;

//	ASSUMES delegate is a UIViewController
-(void)showScores:(id<GKLeaderboardViewControllerDelegate>)delegate;
-(void)showAchievements:(id<GKAchievementViewControllerDelegate>)delegate;

@end
