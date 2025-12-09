#import <UIKit/UIKit.h>
#import "StageView.h"
#import "StageSignView.h"

#define kStageTransitionCompletedEvent @"kStageTransitionCompletedEvent"

@interface StageManagerView : UIView {
    LayoutManager* layoutManager;
    UIImageView* coverImageView;
    UIImageView* leftCoverImageView;
    UIImageView* rightCoverImageView;
    UIImageView* frameImageView;
    StageSignView* stageSignView;
    BOOL stageSignVisible;
}

@property(nonatomic, strong) StageView* stageView;
@property(nonatomic, strong) StageView* previousStageView;

-(void)setStage:(NSString*)name;
-(void)openCover;
-(void)closeCover;
-(BOOL)isCoverOpen;

@end
