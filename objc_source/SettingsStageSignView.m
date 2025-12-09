#import "SettingsStageSignView.h"
#import "AppDelegate.h"

@interface SettingsStageSignView()
-(void)handleSoundOnOff:(UIButton*)sender;
-(void)movieVolumeChanged:(UISlider*)sender;
-(void)handleIncorrectOnOff:(UIButton*)sender;
-(void)handleTrackingOnOff:(UIButton*)sender;
@end

@implementation SettingsStageSignView

- (id)init {
    self = [super init];
    if (self) {
        self.name = @"settings";
    }
    return self;
}

-(void)hideAnimationComplete {
    [super hideAnimationComplete];
    //NSLog(@"SettingsStageSignView.hideAnimationComplete");
}

-(void)beforeShowAnimation {
    [super beforeShowAnimation];
    [super addImage:@"sign.settings"];
    
    UIButton* soundOnOff;
    UISlider *musicVolume;
    UIButton* incorrectOnOff;
    UIButton* trackingOnOff;

    soundOnOff = [ResourceManager getImageButton:@"onoff" module:@"settings" isPortrait:NO hasDownState:YES];
    [soundOnOff setSelected:[Settings getSoundOn]];
    soundOnOff.alpha = 0.9;
    [layoutManager addView:soundOnOff withKey:@"sound.button" position:XY];
    [soundOnOff addTarget:self action:@selector(handleSoundOnOff:) forControlEvents:UIControlEventTouchUpInside];
    
    musicVolume = [[UISlider alloc] initWithFrame:CGRectZero];
    [layoutManager addView:musicVolume withKey:@"music.volume.button" position:RECT];
    [musicVolume addTarget:self action:@selector(movieVolumeChanged:) forControlEvents:UIControlEventValueChanged];
    musicVolume.value = [Settings getMusicVolume];
    
    incorrectOnOff = [ResourceManager getImageButton:@"onoff" module:@"settings" isPortrait:NO hasDownState:YES];
    [incorrectOnOff setSelected:[Settings getShowIncorrect]];
    incorrectOnOff.alpha = 0.9;
    [layoutManager addView:incorrectOnOff withKey:@"incorrect.button" position:XY];
    [incorrectOnOff addTarget:self action:@selector(handleIncorrectOnOff:) forControlEvents:UIControlEventTouchUpInside];
    
    trackingOnOff = [ResourceManager getImageButton:@"onoff" module:@"settings" isPortrait:NO hasDownState:YES];
    [trackingOnOff setSelected:[Settings getUsageTracking]];
    trackingOnOff.alpha = 0.9;
    [layoutManager addView:trackingOnOff withKey:@"tracking.button" position:XY];
    [trackingOnOff addTarget:self action:@selector(handleTrackingOnOff:) forControlEvents:UIControlEventTouchUpInside];
    
    BOOL replaceSliderImages = NO;
    if(replaceSliderImages) {
        UIImage *minImage = [UIImage imageNamed:@"slider_min.png"];
        UIImage *maxImage = [UIImage imageNamed:@"slider_max.png"];
        UIImage *tumbImage= [UIImage imageNamed:@"slider_thumb.png"];
        
        minImage=[minImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
        maxImage=[maxImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
        
        [musicVolume setMinimumTrackImage:minImage forState:UIControlStateNormal];
        [musicVolume setMaximumTrackImage:maxImage forState:UIControlStateNormal];
        [musicVolume setThumbImage:tumbImage forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
    }

    if([DeviceUtil osVersionSupported:@"5.0"]) {
        UIColor* tintColor = [ResourceManager getStyleColor:@"music.volume" withAttribute:@"color" module:@"stage.manager.sign" isPortrait:NO];
        //UIColor* tintColor = [UIColor brownColor];
        musicVolume.minimumTrackTintColor = tintColor;
        musicVolume.maximumTrackTintColor = tintColor;
        UIColor* thumbTintColor = [ResourceManager getStyleColor:@"music.volume.thumb" withAttribute:@"color" module:@"stage.manager.sign" isPortrait:NO];
        musicVolume.thumbTintColor = thumbTintColor;
    }
    soundOnOff = nil;
    musicVolume = nil;
    incorrectOnOff = nil;
    trackingOnOff = nil;
}

-(void)handleTrackingOnOff:(UIButton*)sender {
    [sender setSelected:!sender.selected];
    [DataUtil setBool:sender.isSelected withKey:@"tracking.on"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tracking.on" object:nil];
    [SimpleSoundManager play:@"checkbox"];
}

-(void)handleSoundOnOff:(UIButton*)sender {
    [sender setSelected:!sender.selected];
    [DataUtil setBool:sender.isSelected withKey:@"sound.on"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sound.on" object:nil];
    [SimpleSoundManager play:@"checkbox"];
}

-(void)handleIncorrectOnOff:(UIButton*)sender {
    [sender setSelected:!sender.selected];
    [DataUtil setBool:sender.isSelected withKey:@"show.incorrect"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show.incorrect" object:nil];
    [SimpleSoundManager play:@"checkbox"];
}

-(void)movieVolumeChanged:(UISlider*)sender {
    [DataUtil setFloat:sender.value withKey:@"music.volume"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"music.volume" object:nil];
    [appDelegate.backgroundMusic setAugmentedVolume];
}

@end
