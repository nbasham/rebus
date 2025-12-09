#import "StageView.h"
#import "RebusPlayState.h"

@interface PlayStageView : StageView {
    UIImageView* puzzleImageView;
    NSMutableArray* labelStates;
    UITapGestureRecognizer* tapRecognizer;
}

@end
