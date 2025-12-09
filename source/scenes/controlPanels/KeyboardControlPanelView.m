#import "KeyboardControlPanelView.h"

@interface KeyboardControlPanelView()
@end

@implementation KeyboardControlPanelView

-(id)initWithControlPanelName:(NSString*)name {
    self = [super initWithControlPanelName:name];
    if (self) {
        helpView = [[HelpView alloc] initWithFrame:CGRectZero name:@"keyboard.help"];
        [layoutManager addView:helpView withKey:@"keyboard.help" position:XY];
        
        performanceView = [[PerformanceView alloc] initWithFrame:CGRectZero name:@"keyboard.performance"];
        [layoutManager addView:performanceView withKey:@"keyboard.performance" position:XY];
        
        answerView = [[AnswerView alloc] initWithFrame:CGRectZero name:@"keyboard.answer"];
        [layoutManager addView:answerView withKey:@"keyboard.answer" position:XY];
        
        decorationView = [[DecorationView alloc] initWithFrame:CGRectZero name:@"keyboard.decoration"];
        [layoutManager addView:decorationView withKey:@"keyboard.decoration" position:NONE];
        
        keysView = [[KeysView alloc] initWithFrame:CGRectZero name:@"keyboard.keys"];
        [layoutManager addView:keysView withKey:@"keyboard.keys" position:XY];

        decorationView.performanceCover = performanceView.coverImageView;
        answerView.selectionView = decorationView.selectionView;
        decorationView.selectionView.frameY = answerView.frameY;
    }
    return self;
}

-(void)enterScene {
    [super enterScene];
    [helpView enterScene];
    [answerView enterScene];
    [keysView enterScene];
    [performanceView enterScene];
    [decorationView enterScene];
}

-(void)exitScene {
    [super exitScene];
    [helpView exitScene];
    [answerView exitScene];
    [keysView exitScene];
    [performanceView exitScene];
    [decorationView exitScene];
}

@end
