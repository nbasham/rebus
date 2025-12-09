#import "SaveGameStageSignView.h"
#import "AppDelegate.h"
#import "RebusPlayState.h"
#import "ThreadUtil.h"

@interface SaveGameStageSignView()
-(void)exitGameSkipToNextGameResponse;
-(void)exitGameResumeGameResponse;
@end

@implementation SaveGameStageSignView

- (id)init {
    self = [super init];
    if (self) {
        self.name = @"saveGame";
    }
    return self;
}

-(void)hideAnimationComplete {
    [super hideAnimationComplete];
    //NSLog(@"SaveGameStageSignView.hideAnimationComplete");
}

-(void)beforeShowAnimation {
    [super beforeShowAnimation];
    [super addImage:@"sign"];
    [super disableControlPanel];

	UITextView* text;
    
    CGRect r = [self getLargeSignBackgroundViewableRect];
    r = [DeviceUtil isPad] ? CGRectInset(r, 90, 40) : CGRectInset(r, 40, 20);
    text = [ResourceManager getMultiLineLabel:@"label" module:@"stage.manager.sign.save" isPortrait:NO data:kNoData];
    text.text = [ResourceManager getLocalizedString:@"text" module:@"stage.manager.sign.save" isPortrait:NO];
    text.frame = r;
    text.backgroundColor = [UIColor clearColor];
    [layoutManager addView:text withKey:@"stage.manager.sign.save.label" x:r.origin.x y:r.origin.y];
    
    UIButton* o;
    
    o = [ResourceManager getImageButton:@"button" module:@"stage.manager.sign" isPortrait:NO hasDownState:YES];
    [ResourceManager applyStylesToButton:o name:@"button" module:@"stage.manager.sign" isPortrait:NO data:@"save.skip.button"];
    [o addTarget:self action:@selector(exitGameSkipToNextGameResponse) forControlEvents:UIControlEventTouchUpInside];
    [layoutManager addView:o withKey:@"button.skip" position:XY];
    
    o = [ResourceManager getImageButton:@"button" module:@"stage.manager.sign" isPortrait:NO hasDownState:YES];
    [ResourceManager applyStylesToButton:o name:@"button" module:@"stage.manager.sign" isPortrait:NO data:@"save.resume.button"];
    [o addTarget:self action:@selector(exitGameResumeGameResponse) forControlEvents:UIControlEventTouchUpInside];
    [layoutManager addView:o withKey:@"button.resume" position:XY];
}

-(void)exitGameResumeGameResponse {
	[SimpleSoundManager playButton];
    RebusPlayState* rebusPlayState = appDelegate.rebusPlayState;
    [rebusPlayState save];
    [[NSNotificationCenter defaultCenter] postNotificationName:kHideSignEvent object:nil];
    runBlockAfterDelay(0.75, ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowSceneEvent object:kMenuScene];
    });
}

-(void)exitGameSkipToNextGameResponse {
	[SimpleSoundManager playButton];
    RebusPlayState* rebusPlayState = appDelegate.rebusPlayState;
    [rebusPlayState skip];
    [[NSNotificationCenter defaultCenter] postNotificationName:kHideSignEvent object:nil];
    runBlockAfterDelay(0.75, ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowSceneEvent object:kMenuScene];
    });
}

@end
