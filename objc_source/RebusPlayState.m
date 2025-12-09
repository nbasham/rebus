#import "RebusPlayState.h"
#import "RebusPuzzle.h"
#import "RebusScore.h"
#import "ThreadUtil.h"
#import "AppDelegate.h"
#import "UsageTracking.h"
#import "RebusGlobals.h"

@interface RebusPlayState()
-(void)handleAnswerTouchEvent:(NSNotification*)notification;
@end

@implementation RebusPlayState

@synthesize puzzle;
@synthesize answerStates;
@synthesize selectedColumn;
//@synthesize hintAvailable;

- (id)init {
    self = [super init];
    if (self) {
        usedHints = [NSMutableArray array];
        selectedColumn = kNoSelection;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAnswerTouchEvent:) name:kAnswerTouchEvent object:nil];
    }
    return self;
}

-(void)handleKeyboardCharacterPlayEvent:(NSNotification*)notification {
    NSString* s = [[notification object] lowercaseString];
    [self keyboardTouch:[s characterAtIndex:0]];
}

-(void)handleAnswerTouchEvent:(NSNotification*)notification {
    NSNumber* o = [notification object];
    int touchedIndex = [o intValue];
    if(touchedIndex != selectedColumn) {
        selectedColumn = touchedIndex;
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateSelectionEvent object:nil];
    }
}

-(int)getCurrentScore {
    int score = kMaxScore - hints*kScoreHintPenalty - numberMissed*kScoreIncorrectPenalty;
    return MAX(kMinScore, score);
}

-(BOOL)wasHintUsed:(int)index {
    NSNumber* n = [usedHints objectAtIndex:index];
    return [n intValue] == 1;
}

-(void)useHint:(int)index {
	dirty = YES;
    hints++;
    [usedHints replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:1]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kHintShownEvent object:nil];
}

-(RebusAnswerPlayState*)getViewStateAtIndex:(int)i {
    RebusAnswerPlayState* o = [answerStates objectAtIndex:i];
    return o;
}

-(void)setPuzzle:(RebusPuzzle*)p {
    puzzleId = p.puzzleId;
    puzzle = p;
    int numHintsPossible = [puzzle getNumHints];
    for (int i = 0; i < numHintsPossible; i++) {
        [usedHints addObject:[NSNumber numberWithInt:0]];
    }

    solution = p.solution;
	selectedColumn = 0;
    int solutionLen = [p.solution length];
    NSString* lowercaseSolution = [p.solution lowercaseString];
    [answerStates removeAllObjects];
    answerStates = [[NSMutableArray alloc] initWithCapacity:solutionLen];
    for (int i = 0; i < solutionLen; i++) {
        char c = [lowercaseSolution characterAtIndex:i];
        RebusAnswerPlayState* o = [[RebusAnswerPlayState alloc] initWithCharacter:c];
        [answerStates addObject:o];
    }
}

// update selectedColumn to next unanswered position, wrap if necessary
-(void)incSelection {
    int newSelection = selectedColumn;
    int solutionLen = [solution length];
    for (int i = 0; i < solutionLen; i++) {
        newSelection++;
        if(newSelection >= solutionLen) {
            newSelection = 0;
        }
        RebusAnswerPlayState* o = [self getViewStateAtIndex:newSelection];
        if(o.state == ANSWERED && ![o isCorrect]) {
            selectedColumn = newSelection;
            return;
        } else if(o.state == UNANSWERED) {
            selectedColumn = newSelection;
            //[[NSNotificationCenter defaultCenter] postNotificationName:kUpdateSelectionEvent object:nil];
            return;
        }
    }
}

-(BOOL)keyboardTouch:(char)c {
	dirty = YES;
    RebusAnswerPlayState* o = [self getViewStateAtIndex:selectedColumn];
    [o updateValue:c];
    BOOL isCorrect = [o isCorrect];
    BOOL showIncorrectGuess = [Settings getShowIncorrect];
    if(isCorrect || !showIncorrectGuess) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCorrectAnswerEvent object:nil];
        [self incSelection]; // must call after posting notification, as listeners may use selectedColumn
        if([self solved]) {
            [self handlePuzzleSolved];
        }
    } else {
        self.numberMissed++;
        [[NSNotificationCenter defaultCenter] postNotificationName:kIncorrectAnswerEvent object:nil];
    }
    return isCorrect;
}

-(BOOL)solved {
	for(RebusAnswerPlayState* o in answerStates) {
		if(![o isCorrect]) {
			return NO;
		}
	}
	return YES;
}

-(void)handlePuzzleSolved {
    [self stopTimer];
	dirty = NO;
    RebusScore* score = [RebusScore create:self];
    int puzzleIndex = [DataUtil getIntWithKey:kCurrentPuzzleIndexKey withDefault:-1] + 1;
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString* formattedPuzzleIdAndName = [NSString stringWithFormat:@"%06d %@", appDelegate.rebusPlayState.puzzleId, [appDelegate.rebusPlayState.puzzle solution]];
    if(puzzleIndex <= appDelegate.puzzles.count) {
        [UsageTracking trackEvent:@"score" action:formattedPuzzleIdAndName label:[NSString stringWithFormat:@"%d", score.time] value:score.score];
    } else {
        [UsageTracking trackEvent:@"repeat.score" action:formattedPuzzleIdAndName label:[NSString stringWithFormat:@"%d", score.time] value:score.score];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kPuzzleSolvedEvent object:score];
    runBlockAfterDelay(0.8, ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowSceneEvent object:kSolvedScene];
    });
    [self clear];
}

-(void)skip {
    [self stopTimer];
	dirty = NO;
    RebusScore* score = [RebusScore create:self];
    score.score = kSkippedScore;
    [[NSNotificationCenter defaultCenter] postNotificationName:kPuzzleSolvedEvent object:score];
    [self clear];
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
	[encoder encodeInt:selectedColumn forKey:@"selectedColumn"];
	[encoder encodeObject:answerStates forKey:@"answerStates"];
	[encoder encodeObject:solution forKey:@"solution"];
	[encoder encodeObject:usedHints forKey:@"usedHints"];
	//  puzzleId done in super
}

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
	if (self) {
        AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        puzzle = [appDelegate getPuzzleById:puzzleId];
		selectedColumn = [decoder decodeIntForKey:@"selectedColumn"];
		answerStates = [decoder decodeObjectForKey:@"answerStates"];
		solution = [decoder decodeObjectForKey:@"solution"];
		usedHints = [decoder decodeObjectForKey:@"usedHints"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAnswerTouchEvent:) name:kAnswerTouchEvent object:nil];
 	}
	return self;
}

@end
