#import "SceneView.h"
#import "RebusPlayState.h"
#import "MeterView.h"

@interface PerformanceView : SceneView {
    NSMutableArray* imageArray;
    MeterView* pointMeterView;
    BOOL hitMinimumScore;
}

@property(nonatomic, strong) UIImageView* coverImageView;

@end
