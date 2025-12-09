#import <Foundation/Foundation.h>
#import "PlayState.h"
#import "Puzzle.h"

//#define kPuzzleSolved @"kPuzzleSolved"
//#define kPuzzleGuess @"kPuzzleGuess"
//#define kRenderPuzzle @"kRenderPuzzle"

@interface PlayState : NSObject<NSCoding> {
	int numberMissed;
	int hints;
    int elapsedSeconds;
    BOOL paused;
	int puzzleId;
	BOOL dirty;
	BOOL stopReqest;
}

@property (nonatomic, assign) int numberMissed;
@property (nonatomic, assign) int hints;
@property (nonatomic, assign) int elapsedSeconds;
@property (nonatomic, assign, getter=isPaused) BOOL paused;
@property (nonatomic, assign) int puzzleId;
@property (nonatomic, assign) BOOL dirty;

//-(void)setPuzzle:(Puzzle*)p;
-(BOOL)solved;
-(void)answerAllButOne;
-(void)startTimer;
-(void)stopTimer;

+(id)loadLastGame;
+(BOOL)exists;
-(void)save;
-(void)clear;

@end
