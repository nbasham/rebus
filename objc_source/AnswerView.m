#import "AnswerView.h"
#import "RebusAnswerPlayState.h"
#import "AnswerCell.h"
#import "AlertUtil.h"

@interface AnswerView()
-(void)handleCorrectAnswerEvent:(NSNotification*)notification;
-(void)handleIncorrectAnswerEvent:(NSNotification*)notification;
-(void)handleUpdateSelectionEvent:(NSNotification*)notification;
-(void)update:(BOOL)isCorrect;
-(void)positionCells;
@end

@implementation AnswerView

@synthesize selectionView;  //  set in docoration layer

-(id)initWithFrame:(CGRect)f name:(NSString*)n {
    self = [super initWithFrame:f name:n];
    if (self) {
        [super addBackground];
        selectorXOffset = [[ResourceManager getStyle:@"selector.x.offset" module:@"keyboard.answer" isPortrait:NO] intValue];
        selectorY = [[ResourceManager getStyle:@"selector.top" module:@"keyboard.answer" isPortrait:NO] intValue];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCorrectAnswerEvent:) name:kCorrectAnswerEvent object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleIncorrectAnswerEvent:) name:kIncorrectAnswerEvent object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateSelectionEvent:) name:kUpdateSelectionEvent object:nil];
    }
    return self;
}

-(void)enterScene {
    [super enterScene];
    int solutionLen = [appDelegate.rebusPlayState.puzzle.solution length];
    answerButtons = [[NSMutableArray alloc] initWithCapacity:solutionLen];
    for (int i = 0; i < solutionLen; i++) {
        AnswerCell* o = [[AnswerCell alloc] initWithIndex:i];
        o.tag = i;
        [self addSubview:o];
        [answerButtons addObject:o];
        
        //  update existing values
        RebusAnswerPlayState* ps = [appDelegate.rebusPlayState getViewStateAtIndex:i];
        if([ps getValue] != '_' && [ps getValue] != ' ') {
            [o setChar:[ps getValue] isCorrect:[ps isCorrect]];
        }
    }
    [self positionCells];
//    NSMutableString* s = [NSMutableString string];
//    [s appendString:@"\n"];
//    [s appendFormat:@"solution: '%@' len: '%d'\n", appDelegate.rebusPlayState.puzzle.solution, solutionLen];
//    [s appendFormat:@"answerButtons len: '%d'\n", answerButtons.count];
//    for (int i = 0; i < solutionLen; i++) {
//        AnswerCell* o = [answerButtons objectAtIndex:i];
//        [s appendFormat:@"%@\n", [o description]];
//    }
}

-(void)exitScene {
//    NSLog(@"----- AnswerView exitScene -----");
    [super exitScene];
    for (AnswerCell* o in answerButtons) {
        [o clear];
    }
    [answerButtons removeAllObjects];
    answerButtons = nil;
}

-(void)positionCells {
    int solutionLen = [appDelegate.rebusPlayState.puzzle.solution length];
    int solutionWidth = 0;
    int distanceBetweenLetters = [[ResourceManager getStyle:@"distance.between.letters" module:@"keyboard.answer" isPortrait:NO] intValue];
    int spaceWidth = [[ResourceManager getStyle:@"space.width" module:@"keyboard.answer" isPortrait:NO] intValue];
    if(solutionLen > 24) {
        spaceWidth = [DeviceUtil isPad] ? 21 : 8;
    }
    for (int i = 0; i < solutionLen; i++) {
        RebusAnswerPlayState* ps = [appDelegate.rebusPlayState getViewStateAtIndex:i];
        if([ps getValue] == ' ') {
            solutionWidth += spaceWidth;
        } else {
            AnswerCell* o = [answerButtons objectAtIndex:i];
            solutionWidth += o.frameWidth;
        }
        if(i < (solutionLen - 1)) {
            solutionWidth += distanceBetweenLetters;
        }
    }

    int decorationWidth = [[ResourceManager getStyle:@"decoration.width" module:@"keyboard.answer" isPortrait:NO] intValue];
    int artOffCenterCompensation = [[ResourceManager getStyle:@"decoration.fudge" module:@"keyboard.answer" isPortrait:NO] intValue];
    int startPoint = (decorationWidth - solutionWidth) / 2 - artOffCenterCompensation;
    int x = startPoint;
    int selectedX = 0;
    
    for (int i = 0; i < solutionLen; i++) {
        RebusAnswerPlayState* ps = [appDelegate.rebusPlayState getViewStateAtIndex:i];
        AnswerCell* o = [answerButtons objectAtIndex:i];
        o.frameX = x;
        if(appDelegate.rebusPlayState.selectedColumn == i) {
            selectedX = x;
        }
        if([ps getValue] == ' ') {
            x += spaceWidth;
        } else {
            x += o.frame.size.width + distanceBetweenLetters;
        }
    }
    selectionView.frameY = selectorY;
    selectionView.frameX = selectedX + selectorXOffset;
}

-(void)handleCorrectAnswerEvent:(NSNotification*)notification {
    [self update:YES];
}

-(void)handleIncorrectAnswerEvent:(NSNotification*)notification {
    [self update:NO];
}

-(void)update:(BOOL)isCorrect {
    RebusPlayState* playState = appDelegate.rebusPlayState;
    int selectedColumn = playState.selectedColumn;
    RebusAnswerPlayState* aps = [playState getViewStateAtIndex:selectedColumn];
    int solutionLen = [playState.puzzle.solution length];
    for (int i = 0; i < solutionLen; i++) {
        RebusAnswerPlayState* ps = [playState getViewStateAtIndex:i];
        if(ps == aps) {
            AnswerCell* o = [answerButtons objectAtIndex:i];
            [o setChar:[aps getValue] isCorrect:isCorrect];
            break;
        }
    }
}

-(void)handleUpdateSelectionEvent:(NSNotification*)notification {
    int selectedColumn = appDelegate.rebusPlayState.selectedColumn;
    if(selectedColumn < answerButtons.count) {
        UIButton* o = [answerButtons objectAtIndex:selectedColumn];
        [SimpleSoundManager play:@"slide"];
        [UIView animateWithDuration:0.251 delay:0 options:UIViewAnimationOptionCurveEaseInOut 
                         animations:^{
                             if(o == nil) {
                                 [AlertUtil showOKAlert:@"o invalid in block"];
                             }
                             selectionView.frameX = o.frameX + selectorXOffset;
                         } completion:nil];
    } else {
        NSLog(@"solution: '%@'\n", appDelegate.rebusPlayState.puzzle.solution);
    }
}

@end
