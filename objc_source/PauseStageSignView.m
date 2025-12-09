#import "PauseStageSignView.h"

@implementation PauseStageSignView

- (id)init {
    self = [super init];
    if (self) {
        self.name = @"pause";
    }
    return self;
}

-(void)beforeShowAnimation {
    [super beforeShowAnimation];
    [appDelegate.rebusPlayState setPaused:YES];
    [super addImage:@"sign.pause"];
    [super dismissOnTouch];
    [super disableControlPanel];
}

-(void)hideAnimationComplete {
    [super hideAnimationComplete];
    //NSLog(@"PauseStageSignView.hideAnimationComplete");
    [appDelegate.rebusPlayState setPaused:NO];
}

-(void)hide {
    [SimpleSoundManager playButton];
    [super hide];
}

@end
