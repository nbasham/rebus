#import <Foundation/Foundation.h>

@interface Score : NSObject<NSCoding> {
	int score;
	int puzzleId;
	int time;
	int numberMissed;
	int hints;
	NSDate* date;
	int version;
}

@property (nonatomic, assign) int score;
@property (nonatomic, assign) int puzzleId;
@property (nonatomic, assign) int time;
@property (nonatomic, assign) int numberMissed;
@property (nonatomic, assign) int hints;
@property (nonatomic, assign) int version;
@property (nonatomic, strong) NSDate* date;

//+(NSArray*)sampleScores:(int)count;
//+(Score*)create:(int)time puzzleId:(int)puzzleId missed:(int)numberMissed hints:(int)numberHints;
+(NSString*)secondsToMMSS:(int)seconds;
+(int)getMissedPenalty;
+(int)getHintPenalty;
-(NSComparisonResult)compareByScore:(Score *)otherObject;
-(NSComparisonResult)compareByDate:(Score *)otherObject;
-(int)getScorePenalty;
-(NSString*)getTimeStr;

@end
