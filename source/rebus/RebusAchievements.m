#import "RebusAchievements.h"
#import "RebusScore.h"
#import "AppDelegate.h"
#import "GameCenter.h"

@interface RebusAchievements()
+(NSString*)getAchievementIdentifierForLevel:(int)level;
@end

@implementation RebusAchievements

//-(void)updateAchievementIfNecessary {
//    BOOL isAuthenticated = [GameCenter singleton].isAuthenticated;
//	if(isAuthenticated) {
//        int currentLevel = [RebusAchievements getCurrentAchievementIndex] + 1;
//        NSString* identifier = [RebusAchievements getAchievementIdentifierForLevel:currentLevel];
//        BOOL achievementsCompleted = identifier == nil;
//        if(!achievementsCompleted) {
//            double progress = [self getAchievementProgress];
//            [[GameCenter singleton] reportAchievementIdentifier:identifier progress:progress];
//        }
//        [super updateAchievementIfNecessary];
//    }
//}

-(NSString*)getAchievementInProgressIdentifier {
    int currentLevel = [RebusAchievements getCurrentAchievementIndex] + 1;
    NSString* identifier = [RebusAchievements getAchievementIdentifierForLevel:currentLevel];
    return identifier;
}

-(void)expectedAchievements:(NSMutableArray*)achievements scores:(NSArray*)scores {
    int total = [RebusScore getTotalScore];
	if(total >= 0) {
		[achievements addObject:[RebusGlobals isFreeApp] ? @"free.fledgling" : @"fledgling"];
	}
	if(total >= 1000) {
		[achievements addObject:[RebusGlobals isFreeApp] ? @"free.novice" : @"novice"];
	}
	if(total >= 2000) {
		[achievements addObject:[RebusGlobals isFreeApp] ? @"free.apprentice" : @"apprentice"];
	}
	if(total >= 3000) {
		[achievements addObject:[RebusGlobals isFreeApp] ? @"free.journeyman" : @"journeyman"];
	}
	if(total >= 4000) {
		[achievements addObject:[RebusGlobals isFreeApp] ? @"free.scholar" : @"scholar"];
	}
	if(total >= 5000) {
		[achievements addObject:[RebusGlobals isFreeApp] ? @"free.professor" : @"professor"];
	}
	if(total >= 6000) {
		[achievements addObject:[RebusGlobals isFreeApp] ? @"free.sage" : @"sage"];
	}
	if(total >= 7000) {
		[achievements addObject:[RebusGlobals isFreeApp] ? @"free.savant" : @"savant"];
	}
	if(total >= 8000) {
		[achievements addObject:[RebusGlobals isFreeApp] ? @"free.prodigy" : @"prodigy"];
	}
	if(total >= 9000) {
		[achievements addObject:[RebusGlobals isFreeApp] ? @"free.virtuoso" : @"virtuoso"];
	}
	if(total >= 10000) {
		[achievements addObject:[RebusGlobals isFreeApp] ? @"free.maestro" : @"maestro"];
	}
	if(total >= 11000) {
		[achievements addObject:[RebusGlobals isFreeApp] ? @"free.titan" : @"titan"];
	}
}

-(double)getAchievementProgress {
    int total = [RebusScore getTotalScore];
    double progress = total % 1000;
    double percentage = progress / 10.0;
    return percentage;
}

+(NSString*)getAchievementIdentifierForLevel:(int)level {
    NSString* identifier;
    switch (level) {
        case 0:
            identifier = @"fledgling";
            break;
        case 1:
            identifier = @"novice";
            break;
        case 2:
            identifier = @"apprentice";
            break;
        case 3:
            identifier = @"journeyman";
            break;
        case 4:
            identifier = @"scholar";
            break;
        case 5:
            identifier = @"professor";
            break;
        case 6:
            identifier = @"sage";
            break;
        case 7:
            identifier = @"savant";
            break;
        case 8:
            identifier = @"prodigy";
            break;
        case 9:
            identifier = @"virtuoso";
            break;
        case 10:
            identifier = @"maestro";
            break;
        case 11:
            identifier = @"titan";
            break;
        default:
            identifier = nil;
            break;
    }
    if([RebusGlobals isFreeApp] && identifier != nil) {
        identifier = [NSString stringWithFormat:@"free.%@", identifier];
    }
    return identifier;
}

+(int)getCurrentAchievementIndex {
    int total = [RebusScore getTotalScore];
    int index = total / 1000;
    if(index >= kAcheivementLevels) {
        index = kAcheivementLevels - 1;
    }
    return index;
}

@end
