#import "SceneView.h"
#import "HelpView.h"

@interface DecorationView : SceneView {
    UIImageView* knobImageView;
    BOOL coverIsUp;
    UITapGestureRecognizer* tapRecognizer;
    UISwipeGestureRecognizer* swipeRecognizer;
    int y;
    UIButton* helpButton;
}

@property(nonatomic, strong) UIImageView* performanceCover;
@property(nonatomic, strong) UIView* selectionView;

@end
