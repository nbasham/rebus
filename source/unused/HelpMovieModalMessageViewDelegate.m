#import "HelpMovieModalMessageViewDelegate.h"
#import "PathUtil.h"
#import "AppDelegate.h"

@implementation HelpMovieModalMessageViewDelegate

@synthesize message;

-(UIView*)getMessageView {
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [DeviceUtil deviceWidth], [DeviceUtil deviceHeight])];
    UIImageView* frameView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help.frame.pad.png"]];
    NSString* movieTitleFormat = @"%@.movie";
    NSString* movieTitle = [NSString stringWithFormat:movieTitleFormat, message];
    float scale = 0.75;
    int w = v.frameWidth * scale;
    int h = v.frameHeight * scale;
    int x = (v.frameWidth - w) / 2;
    int y = (v.frameHeight - h) / 2;
    CGRect r = CGRectMake(x, y, w, h);
    player = [[MPMoviePlayerController alloc] initWithContentURL:[PathUtil getUrlFromFileName:movieTitle ofType:@"mov"]];
    player.controlStyle = MPMovieControlStyleNone;
    [player.view setFrame:r];
	player.repeatMode = MPMovieRepeatModeOne;
    [player prepareToPlay];       
    [v addSubview:player.view];
    [v addSubview:frameView];
    return v;
}

-(BOOL)dismissOnTouch {
    return YES;
}

-(UIView*)getBackgroundView {
    UIView* v = nil;
    return v;
}

-(void)willShow {
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.backgroundMusic pause];
}

-(void)didShow {
    [player play];
}

-(void)willHide {
    [player stop];
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.backgroundMusic play];
}

-(void)didHide {
}

@end
