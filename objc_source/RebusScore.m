#import "RebusScore.h"
#import "AppDelegate.h"

@implementation RebusScore

+(RebusScore*)create:(RebusPlayState*)ps {
	RebusScore* score = [[RebusScore alloc] init];
	score.puzzleId = ps.puzzleId;
	score.numberMissed = ps.numberMissed;
	score.hints = ps.hints;
	score.time = ps.elapsedSeconds;
	score.score = [ps getCurrentScore];
	return score;
}

+(RebusScore*)createSample:(int)pid {
	RebusScore* score = [[RebusScore alloc] init];
	score.puzzleId = pid;
	score.numberMissed = (arc4random() % 10);
	score.hints = (arc4random() % 2);
	score.time = 90 + (arc4random() % 120);
    int s = kMaxScore - score.hints*kScoreHintPenalty - score.numberMissed*kScoreIncorrectPenalty;
    score.score = MAX(kMinScore, s);
	return score;
}

+(int)getTotalScore {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSArray* scores = appDelegate.scores;
    int total = 0;
    for(RebusScore* score in scores) {
        int s = score.score;
        if(s != kSkippedScore) {
            total += s;
        }
    }
    return total;
}

@end
