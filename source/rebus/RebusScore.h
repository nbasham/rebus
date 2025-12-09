#import <Foundation/Foundation.h>
#import "Score.h"
#import "RebusPlayState.h"

#define kSkippedScore -1

@interface RebusScore : Score

+(RebusScore*)create:(RebusPlayState*)ps;
+(RebusScore*)createSample:(int)pid;
+(int)getTotalScore;

@end
