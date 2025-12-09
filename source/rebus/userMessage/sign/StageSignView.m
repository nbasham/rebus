#import "StageSignView.h"
#import "AppDelegate.h"
#import "SceneViewController.h"
#import "ThreadUtil.h"
#import "StringUtil.h"
#import "UsageTracking.h"

@interface StageSignView()
-(void)handleTap:(UITapGestureRecognizer*)tapEvent;
@end

#define kDuration 1.0

@implementation StageSignView

@synthesize name;

-(id)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        SceneViewController* vc = (SceneViewController*)appDelegate.navigationController.topViewController;
        vc.sceneTransitionManager.stageManagerView.stageView.userInteractionEnabled = NO;
    }
    return self;
}

-(void)disableControlPanel {
    SceneViewController* vc = (SceneViewController*)appDelegate.navigationController.topViewController;
    vc.sceneTransitionManager.controlPanelManagerView.controlPanelView.userInteractionEnabled = NO;
}

-(void)dismissOnTouch {
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.cancelsTouchesInView = NO;
    SceneViewController* vc = (SceneViewController*)appDelegate.navigationController.topViewController;
    [vc.view addGestureRecognizer:tapRecognizer];
}

-(UIImageView*)addImage:(NSString*)n {
    UIImage* i = [ResourceManager getImage:n module:@"stage.manager" isPortrait:NO];
    assert( i != nil );
    CGRect r = CGRectMake(([DeviceUtil deviceWidth]-i.size.width)/2, 0, i.size.width, i.size.height);
    self.frame = r;
    UIImageView* v = [[UIImageView alloc] initWithImage:i];
    [layoutManager addView:v withKey:n position:NONE];
    return v;
}

-(CGRect)getLargeSignBackgroundViewableRect {
    return [DeviceUtil isPad] ? CGRectMake(111, 122, 808, 263) : CGRectMake(52, 30, 379, 110);
}

-(void)addMessageView {
    UIImage* messageImage = [ResourceManager getImage:name module:@"stage.manager.sign" isPortrait:NO];
    UIImageView* v = [[UIImageView alloc] initWithImage:messageImage];
    [layoutManager addView:v withKey:@"message" position:NONE];
}

-(void)show {
    if(layoutManager != nil) {
        [layoutManager clear];
        layoutManager = nil;
    }
    layoutManager = [[LayoutManager alloc] initWithParent:self moduleName:@"stage.manager.sign"];
    [self beforeShowAnimation];
    [layoutManager layout:NO];
    self.frameBottom = 0;
    [SimpleSoundManager play:@"sign-up"];
    [UIView animateWithDuration:kDuration animations:^{
        self.frameY = 0;
    } completion:^(BOOL finished){
        [self showAnimationComplete];
    }];
    enterTime = [NSDate date];
}

/*
 For convenience, StageSignView disables interaction to the current stage and control panel. In doing
 so, it takes over the touch that should be handled by the stage manager. The cost of this convenience
 is that we have to special case the tap for signs that require the cover to be opened after hiding.
 */
-(void)handleTap:(UITapGestureRecognizer*)tapEvent {
    SceneViewController* vc = (SceneViewController*)appDelegate.navigationController.topViewController;
    BOOL isCoverClosed = ![vc.sceneTransitionManager.stageManagerView isCoverOpen];
    if([name isEqualToString:@"pause"] && isCoverClosed) {
        [self hide];
        runBlockAfterDelay(kDuration, ^{
            [UIView animateWithDuration:kDuration animations:^{
                [vc.sceneTransitionManager.stageManagerView openCover];
            } completion:^(BOOL finished){
            }];
        });
    } else if([name isEqualToString:@"settings"] && isCoverClosed) {
        [self hide];
    } else if([StringUtil contains:@"lesson" inString:name]) {
        [self hide];
    }
}

-(void)hide {
    int elapsedSeconds = -[enterTime timeIntervalSinceNow];
    if(elapsedSeconds < 120) {
        //  skip views of over 2 minutes
        [UsageTracking trackEvent:@"message.time" action:name label:nil value:elapsedSeconds];
    }
    [self beforeHideAnimation];
    [SimpleSoundManager play:@"sign-down"];
    [UIView animateWithDuration:kDuration animations:^{
        self.frameBottom = 0;
    } completion:^(BOOL finished){
        [self hideAnimationComplete];
    }];
}

-(void)showAnimationComplete {
}

-(void)hideAnimationComplete {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSignHiddenEvent object:nil];
    //NSLog(@"StageSignView.hideAnimationComplete");
    [self cleanUp];
}

-(void)cleanUp {
    [layoutManager clear];
    layoutManager = nil;
    SceneViewController* vc = (SceneViewController*)appDelegate.navigationController.topViewController;
    [vc.view removeGestureRecognizer:tapRecognizer];
    tapRecognizer = nil;
    vc.sceneTransitionManager.stageManagerView.stageView.userInteractionEnabled = YES;
    vc.sceneTransitionManager.controlPanelManagerView.controlPanelView.userInteractionEnabled = YES;
}

-(void)beforeShowAnimation {    
}

-(void)beforeHideAnimation {    
}

@end




