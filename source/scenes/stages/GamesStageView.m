#import "GamesStageView.h"
#import "Products.h"
#import "UsageTracking.h"

@interface GamesStageView()
-(void)helpCryptogramButtonTouch;
-(void)helpCryptoFamilesButtonTouch;
-(void)helpQuotefallsButtonTouch;
-(void)helpSudokuButtonTouch;
@end

@implementation GamesStageView

-(id)initWithStageName:(NSString*)name {
    self = [super initWithStageName:name];
    if (self) {
        [super addBackground];
//        float speed  = [[ResourceManager getStyle:@"background.speed" module:@"stage.games" isPortrait:NO] floatValue];
//        panoramicView = [[PanoramicView alloc] initWithPanoramicImageNamed:@"panorama.png" updateInterval:speed];
//        [layoutManager addView:panoramicView withKey:@"panorama" position:NONE];
        
        [layoutManager createImageViewWithKey:@"icons" position:NONE];
        
        UIButton* b;
        
        b = [ResourceManager getImageButton:nil module:nil isPortrait:NO hasDownState:YES];
        [b addTarget:self action:@selector(helpCryptogramButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        [layoutManager addView:b withKey:@"cryptogram" position:RECT];
//        b.backgroundColor = [UIColor greenColor];
//        b.alpha = 0.5;
        
        b = [ResourceManager getImageButton:nil module:nil isPortrait:NO hasDownState:YES];
        [b addTarget:self action:@selector(helpCryptoFamilesButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        [layoutManager addView:b withKey:@"crypto-families" position:RECT];
//        b.backgroundColor = [UIColor greenColor];
//        b.alpha = 0.5;
        
        b = [ResourceManager getImageButton:nil module:nil isPortrait:NO hasDownState:YES];
        [b addTarget:self action:@selector(helpQuotefallsButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        [layoutManager addView:b withKey:@"quotefalls" position:RECT];
//        b.backgroundColor = [UIColor greenColor];
//        b.alpha = 0.5;
        
        b = [ResourceManager getImageButton:nil module:nil isPortrait:NO hasDownState:YES];
        [b addTarget:self action:@selector(helpSudokuButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        [layoutManager addView:b withKey:@"sudoku" position:RECT];
//        b.backgroundColor = [UIColor greenColor];
//        b.alpha = 0.5;
    }
    return self;
}

-(void)enterStage {
    [super enterScene];
//    [panoramicView start];
}

-(void)exitScene {
    [super exitScene];
//    [panoramicView stop];
}

-(void)helpCryptogramButtonTouch {
	[SimpleSoundManager playButton];
    [Products launchAppStoreForProduct:@"cryptogram"];
    [UsageTracking trackEvent:@"games" action:@"iTunes" label:@"cryptogram" value:-1];
}

-(void)helpCryptoFamilesButtonTouch {
	[SimpleSoundManager playButton];
    [Products launchAppStoreForProduct:@"crypto-families"];
    [UsageTracking trackEvent:@"games" action:@"iTunes" label:@"crypto-families" value:-1];
}

-(void)helpQuotefallsButtonTouch {
	[SimpleSoundManager playButton];
    [Products launchAppStoreForProduct:@"quotefalls"];
    [UsageTracking trackEvent:@"games" action:@"iTunes" label:@"quotefalls" value:-1];
}

-(void)helpSudokuButtonTouch {
	[SimpleSoundManager playButton];
    [Products launchAppStoreForProduct:@"sudoku"];
    [UsageTracking trackEvent:@"games" action:@"iTunes" label:@"sudoku" value:-1];
}


//@synthesize player;
//NSURL*@synthesize url;

//-(void)enterScene {
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"help.answer.movie" ofType:@"m4v"];
//    NSURL* url = [NSURL fileURLWithPath:path];
//    self.player = [[MPMoviePlayerController alloc] initWithContentURL:url];
//    self.player.view.frame = CGRectMake(249, 130, 527, 404);
//    self.player.controlStyle = MPMovieControlStyleNone;
//    self.player.scalingMode = MPMovieScalingModeNone;
//    [self addSubview:self.player.view];
//    [self.player prepareToPlay];       
//    [self.player play];       
//}

@end
