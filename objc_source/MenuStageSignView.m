#import "MenuStageSignView.h"
#import "RebusGlobals.h"

@implementation MenuStageSignView

- (id)init {
    self = [super init];
    if (self) {
        self.name = @"menu";
    }
    return self;
}

-(void)beforeShowAnimation {
    [super beforeShowAnimation];
    if([RebusGlobals didUserJustUpdate:@"xxxshowmenuugradesignxxx"]) {
        [super addImage:@"sign.menu.upgrade"];
    } else {
        [super addImage:@"sign.menu"];
    }
    [super dismissOnTouch];
}

-(void)showAnimationComplete {
    [super showAnimationComplete];
    if([RebusGlobals didUserJustUpdate:@"xxxplaymenuugradesoundxxx"]) {
        [SimpleSoundManager play:@"iap"];
    }
}

-(void)hideAnimationComplete {
    [super hideAnimationComplete];
    //NSLog(@"MenuStageSignView.hideAnimationComplete");
}

@end
