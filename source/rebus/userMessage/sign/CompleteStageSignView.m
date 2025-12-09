#import "CompleteStageSignView.h"
#import "AppDelegate.h"
#import "RebusPlayState.h"
#import "ThreadUtil.h"
#import "UsageTracking.h"

@interface CompleteStageSignView()
-(void)upgradeHandler;
@end

@implementation CompleteStageSignView

- (id)init {
    self = [super init];
    if (self) {
        self.name = @"complete";
    }
    return self;
}

-(void)hideAnimationComplete {
    [super hideAnimationComplete];
}

-(void)beforeShowAnimation {
    [super beforeShowAnimation];
    [super addImage:@"sign"];
    [super disableControlPanel];
    
    UIImage* i = [ResourceManager getImage:self.name module:@"stage.manager.sign" isPortrait:NO];
    assert( i != nil );
    UIImageView* v = [[UIImageView alloc] initWithImage:i];
    [layoutManager addView:v withKey:self.name position:NONE];
    
    UIButton* o;
    
    o = [ResourceManager getImageButton:nil module:nil isPortrait:NO hasDownState:YES];
    [o addTarget:self action:@selector(upgradeHandler) forControlEvents:UIControlEventTouchUpInside];
    [layoutManager addView:o withKey:@"upgrade.now.button" position:RECT];
    
    o = [ResourceManager getImageButton:nil module:nil isPortrait:NO hasDownState:YES];
    [o addTarget:self action:@selector(laterHandler) forControlEvents:UIControlEventTouchUpInside];
    [layoutManager addView:o withKey:@"upgrade.later.button" position:RECT];
}

-(void)laterHandler {
	[SimpleSoundManager playButton];
    [[NSNotificationCenter defaultCenter] postNotificationName:kHideSignEvent object:nil];
    [UsageTracking trackEvent:@"upgrade" action:@"complete" label:nil value:[appDelegate.scores count]];
}

-(void)upgradeHandler {
	[SimpleSoundManager playButton];
    [UsageTracking trackEvent:@"touch" action:@"complete.sign.later" label:nil value:-1];
    [[NSNotificationCenter defaultCenter] postNotificationName:kHideSignEvent object:nil];
    runBlockAfterDelay(0.75, ^{
        [appDelegate upgrade];
    });
}

@end
