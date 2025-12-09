#import "PlayState.h"
#import "RebusAnswerPlayState.h"
#import "RebusPuzzle.h"

#define kNoSelection -1

@interface RebusPlayState : PlayState {
    NSString* solution;
    NSMutableArray* usedHints;
}

@property(nonatomic, strong) RebusPuzzle* puzzle;
@property(nonatomic, strong) NSMutableArray* answerStates;
@property(nonatomic, assign) int selectedColumn;

-(RebusAnswerPlayState*)getViewStateAtIndex:(int)i;
-(BOOL)keyboardTouch:(char)c;
-(void)incSelection;
-(BOOL)wasHintUsed:(int)index;
-(void)useHint:(int)index;
-(int)getCurrentScore;
-(void)skip;
-(void)handlePuzzleSolved;

@end
