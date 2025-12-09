#import "PlayState.h"
#import "DataUtil.h"
#import "Products.h"
#import "UsageTracking.h"

#define PLAY_STATE_FILE_NAME @"play.state.plist"

@interface PlayState(Private)
    -(void)incrementElapsedSeconds:(NSTimer*)timer;
@end

@implementation PlayState

@synthesize numberMissed;
@synthesize hints;
@synthesize elapsedSeconds;
@synthesize paused;
@synthesize puzzleId;
@synthesize dirty;

- (id)init {
    self = [super init];
    if (self) {
        [DataUtil deleteFile:PLAY_STATE_FILE_NAME];
        self.numberMissed = 0;
        self.hints = 0;
        self.elapsedSeconds = 0;
        self.paused = YES;
        self.puzzleId = -1;
        self.dirty = NO;
        stopReqest = NO;
    }
    return self;
}

-(void)startTimer {
    paused = NO;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementElapsedSeconds:) userInfo:nil repeats:YES];
}

-(void)stopTimer {
    stopReqest = YES;
}

-(void)incrementElapsedSeconds:(NSTimer*)timer  {
	if(stopReqest) {
		[timer invalidate];
		timer = nil;
		//[timer release]; we don't own it
		return;
	}
	if(!paused) {
		self.elapsedSeconds += 1;
//        [self save];
//        dirty = NO;
	}
}

-(void)setPaused:(BOOL)isPaused {
    paused = isPaused;
}

-(void)answerAllButOne {
    DebugLog(@"Should be subclassed.");
}

-(BOOL)solved {
    DebugLog(@"Should be subclassed.");
    return NO;
}

//-(void)setPuzzle:(Puzzle*)p {
//    self.puzzleId = p.puzzleId;
//}

+(id)loadLastGame {
	if([DataUtil fileExists:PLAY_STATE_FILE_NAME]) {
		PlayState* o = [DataUtil readObjectWithKey:@"state" path:PLAY_STATE_FILE_NAME];
        return o;
	}
    return nil;
}

+(BOOL)exists {
	BOOL b = [DataUtil fileExists:PLAY_STATE_FILE_NAME];
    return b;
}

-(void)save {
	[DataUtil writeObject:self key:@"state" path:PLAY_STATE_FILE_NAME];
}

-(void)clear {
    //DebugLog(@"Deleting puzzle state archive.");
	[DataUtil deleteFile:PLAY_STATE_FILE_NAME];
    
    // do not use self.XXX as this is not an event that should be acted on
    numberMissed = 0;
    hints = 0;
    elapsedSeconds = 0;
    paused = YES;
    puzzleId = -1;
    dirty = NO;
}

-(NSString*)description {
	NSMutableString* s = [NSMutableString string];
	[s appendFormat:@"puzzleId: %4d numberMissed: %4d hints: %4d elapsedSeconds: %4d paused: %d dirty: %d", puzzleId, numberMissed, hints, elapsedSeconds, paused, dirty];
	return s;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInt:elapsedSeconds-1 forKey:@"elapsedSeconds"];
	[encoder encodeBool:paused forKey:@"paused"];
	[encoder encodeInt:numberMissed forKey:@"numberMissed"];
	[encoder encodeInt:hints forKey:@"hints"];
	[encoder encodeInt:puzzleId forKey:@"puzzleId"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
	if (self) {
		self.elapsedSeconds = [decoder decodeIntForKey:@"elapsedSeconds"];
		self.paused = [decoder decodeBoolForKey:@"paused"];
		self.numberMissed = [decoder decodeIntForKey:@"numberMissed"];
		self.hints = [decoder decodeIntForKey:@"hints"];
		self.puzzleId = [decoder decodeIntForKey:@"puzzleId"];
        dirty = NO;
        stopReqest = NO;
	}
	return self;
}

@end
