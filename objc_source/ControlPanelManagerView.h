#import <UIKit/UIKit.h>
#import "ControlPanelView.h"

#define kControlPanelTransitionCompletedEvent @"kControlPanelTransitionCompletedEvent"

@interface ControlPanelManagerView : UIView {
    LayoutManager* layoutManager;
    UIImageView* backgroundImageView;
}

@property(nonatomic, strong) ControlPanelView* controlPanelView;
@property(nonatomic, strong) ControlPanelView* previousControlPanelView;

-(void)setControlPanel:(NSString*)name;

@end
