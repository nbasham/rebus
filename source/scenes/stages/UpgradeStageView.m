#import "UpgradeStageView.h"
#import "UsageTracking.h"

@interface UpgradeStageView()
-(void)upgradeButtonTouch;
@end

@implementation UpgradeStageView

-(id)initWithStageName:(NSString*)name {
    self = [super initWithStageName:name];
    if (self) {
        [super addBackground];
        
        UIButton* b;
        
        b = [ResourceManager getImageButton:nil module:nil isPortrait:NO hasDownState:YES];
        [b addTarget:self action:@selector(upgradeButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        [layoutManager addView:b withKey:@"rebus" position:RECT];
//        b.backgroundColor = [UIColor greenColor];
//        b.alpha = 0.5;
    }
    return self;
}

-(void)upgradeButtonTouch {
	[SimpleSoundManager playButton];
    [appDelegate upgrade];
    [UsageTracking trackEvent:@"upgrade" action:@"stage" label:nil value:[appDelegate.scores count]];
}

@end
