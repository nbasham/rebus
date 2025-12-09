#import "Score.h"
#import "DeviceUtil.h"

#define kMissedPenalty 15
#define kHintPenalty 30

@implementation Score

@synthesize score;
@synthesize puzzleId;
@synthesize date;
@synthesize time;
@synthesize numberMissed;
@synthesize hints;
@synthesize version;

//+(NSArray*)sampleScores:(int)count {
//	NSMutableArray* a = [NSMutableArray array];
//	for (int i = 0; i < count; i++) {
//		Score* score = [[Score alloc] init];
//		score.puzzleId = i;
//		score.time = 90 + (arc4random() % 120);
//		if(i % 2 == 0) {
//			score.numberMissed = (arc4random() % 10);
//		} else {
//			score.numberMissed = 0;
//		}
//        score.hints = (arc4random() % 3);
//		score.score = score.time + score.numberMissed*[Score getMissedPenalty] + score.hints*[Score getHintPenalty];
//		[a addObject:score];
//	}
//	return a;
//}

//+(Score*)create:(int)time puzzleId:(int)puzzleId missed:(int)numberMissed hints:(int)numberHints {
//	Score* score = [[Score alloc] init];
//	score.puzzleId = puzzleId;
//	if([DeviceUtil isSimulator] && time < 20) {
//		time += 90 + (arc4random() % 120);
//	}
//	score.score = time + numberMissed*[Score getMissedPenalty] + numberHints*[Score getHintPenalty];
//	score.time = time;
//	score.numberMissed = numberMissed;
//	score.hints = numberHints;
//	return score;
//}

+(NSString*)secondsToMMSS:(int)seconds {
	NSMutableString* s = [NSMutableString string];
    if(seconds < 60) {
		[s appendFormat:@"0:%.2d", seconds];
    } else {
        int min = floor(seconds/60.0);
        int sec = seconds % 60;
		[s appendFormat:@"%d:%.2d", min, sec];
    }
    return s;
}

-(NSString*)getTimeStr {
    return [Score secondsToMMSS:time];
}

-(int)getScorePenalty {
    int penalty = numberMissed * [Score getMissedPenalty] + hints * [Score getHintPenalty];
    return penalty;
}

+(int)getMissedPenalty {
    return kMissedPenalty;
}

+(int)getHintPenalty {
    return kHintPenalty;
}

-(id)init {
    self = [super init];
	if (self) {
        self.date = [NSDate date];
        self.version = 1;
	}
	return self;
}

-(NSString *)description {
	return [NSString stringWithFormat:@"\n\tscore: '%d'\n\tpuzzle id: '%d'\n\tdate: '%@'\n\ttime: '%d'\n\tnumberMissed: '%d'\n\thints: '%d'",
			self.score, self.puzzleId, self.date, self.time, self.numberMissed, self.hints];
}

-(NSComparisonResult)compareByScore:(Score *)otherObject {
	NSTimeInterval diff = self.score - otherObject.score;
	if (diff>0) {
		return NSOrderedDescending;
	}
	if (diff<0) {
		return NSOrderedAscending;
	}
	return NSOrderedSame;
}

-(NSComparisonResult)compareByDate:(Score *)otherObject {
	NSComparisonResult result = [otherObject.date compare:self.date];
	return result;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInt:score forKey:@"score"];
	[encoder encodeInt:puzzleId forKey:@"puzzleId"];
	[encoder encodeObject:date forKey:@"date"];
	[encoder encodeInt:time forKey:@"time"];
	[encoder encodeInt:numberMissed forKey:@"numberMissed"];
	[encoder encodeInt:hints forKey:@"hints"];
	[encoder encodeInt:version forKey:@"version"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
	if (self) {
        if([decoder containsValueForKey:@"score"]) {
            score = [decoder decodeIntForKey:@"score"];
        }
        if([decoder containsValueForKey:@"puzzleId"]) {
            puzzleId = [decoder decodeIntForKey:@"puzzleId"];
        }
        if([decoder containsValueForKey:@"date"]) {
            date = [decoder decodeObjectForKey:@"date"];
        }
        if([decoder containsValueForKey:@"time"]) {
            time = [decoder decodeIntForKey:@"time"];
        } else {
            time = score;
        }
        if([decoder containsValueForKey:@"numberMissed"]) {
            numberMissed = [decoder decodeIntForKey:@"numberMissed"];
        } else {
            numberMissed = 0;
        }
        if([decoder containsValueForKey:@"hints"]) {
            hints = [decoder decodeIntForKey:@"hints"];
        } else {
            hints = 0;
        }
        if([decoder containsValueForKey:@"version"]) {
            version = [decoder decodeIntForKey:@"version"];
        } else {
            version = 0;
        }
	}
	return self;
}

@end
