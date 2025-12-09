#import <Foundation/Foundation.h>

@protocol Achievements <NSObject>

-(void)updateAchievementIfNecessary;
-(double)getAchievementProgress;
-(NSString*)getAchievementInProgressIdentifier;

@end
