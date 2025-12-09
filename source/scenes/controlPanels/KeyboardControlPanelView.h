#import "ControlPanelView.h"
#import "RebusPlayState.h"
#import "KeysView.h"
#import "HelpView.h"
#import "AnswerView.h"
#import "PerformanceView.h"
#import "DecorationView.h"

@interface KeyboardControlPanelView : ControlPanelView {
    RebusPlayState* rebusPlayState;
    HelpView* helpView;
    AnswerView* answerView;
    KeysView* keysView;
    PerformanceView* performanceView;
    DecorationView* decorationView;
}

@end
