#import "SceneView.h"

@interface AnswerView : SceneView {
    NSMutableArray* answerButtons;
    int selectorY;
    int selectorXOffset;
}

@property(nonatomic, strong) UIView* selectionView;  //  set in docoration layer

@end
