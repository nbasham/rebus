#import "ControlPanelManagerView.h"

@implementation ControlPanelManagerView

@synthesize controlPanelView;
@synthesize previousControlPanelView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        layoutManager = [[LayoutManager alloc] initWithParent:self moduleName:@"control.panel.manager"];
//        backgroundImageView = [layoutManager createBackgroundImageViewWithKey:@"background" parent:self];
    }
    return self;
}

-(void)setControlPanel:(NSString*)name {
    [layoutManager clear];
    layoutManager = [[LayoutManager alloc] initWithParent:self moduleName:@"control.panel.manager"];
    backgroundImageView = [layoutManager createBackgroundImageViewWithKey:@"background" parent:self];
    previousControlPanelView = controlPanelView;
    NSString* capSceneName = [name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[name substringToIndex:1] capitalizedString]];
    NSString* controlPanelClassName = [NSString stringWithFormat:@"%@ControlPanelView", capSceneName];
    Class controlPanelClass = NSClassFromString(controlPanelClassName);
    assert(controlPanelClass != nil);
    controlPanelView = [[controlPanelClass alloc] initWithControlPanelName:name];
    [layoutManager addView:controlPanelView withKey:name position:NONE];
    [controlPanelView enterControlPanel];
    [UIView transitionWithView:self
                    duration:1.0
                    options:UIViewAnimationOptionTransitionFlipFromLeft /*| UIViewAnimationOptionShowHideTransitionViews*/
                    animations:^ {
                    }
                    completion:^(BOOL finished){
                        [previousControlPanelView removeFromSuperview];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kControlPanelTransitionCompletedEvent object:nil];
                    }];
}

@end
