#import "HintsView.h"

#define degreesToRadians(deg) (deg / 180.0 * M_PI)
#define kSweepAngle 124
#define kStartAngle 360 - kSweepAngle/2.0

@interface HintsView()
-(void)timerUpdate:(NSTimer*)timer;
-(void)handleHintShownEvent:(NSNotification*)notification;
-(void)hintTimerComplete;
@end

@implementation HintsView

-(id)initWithName:(NSString*)name {
    self = [super initWithName:name];
    if (self) {
        availableBackgroundImage = [ResourceManager getImage:@"gauge.face.available" module:@"keyboard.hints" isPortrait:NO];
        unavailableBackgroundImage = [ResourceManager getImage:@"gauge.face" module:@"keyboard.hints" isPortrait:NO];
        [backgroundImageView setImage:unavailableBackgroundImage];
        
        availableTextImage = [ResourceManager getImage:@"gauge.text.available" module:@"keyboard.hints" isPortrait:NO];
        unavailableTextImage = [ResourceManager getImage:@"gauge.text" module:@"keyboard.hints" isPortrait:NO];
        textImageView = [layoutManager createImageViewWithKey:@"keyboard.hints.gauge.text" position:XY];

        UIImage* secondHandImage = [ResourceManager getImage:@"hand" module:@"keyboard.hints" isPortrait:NO];
        secondHandImageView = [[UIImageView alloc] initWithImage:secondHandImage];
        double secondsAngle = kStartAngle;
        secondHandImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, degreesToRadians(secondsAngle));
        [self addSubview:secondHandImageView];
        frameImageView = [layoutManager createImageViewWithKey:@"keyboard.hints.frame" position:NONE];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHintShownEvent:) name:kHintShownEvent object:nil];
    }
    return self;
}

-(void)enterScene {
    [super enterScene];
    stopTimer = NO;
    loading = YES;
    hintAvailabilityTime = 0;
    int hintTime = [[ResourceManager getStyle:@"interval" module:@"keyboard.hints" isPortrait:NO] intValue];
    float animationDuration = hintTime / (kSweepAngle * 1.0);
    [NSTimer scheduledTimerWithTimeInterval:animationDuration target:self selector:@selector(timerUpdate:) userInfo:nil repeats:YES];
}

-(void)exitScene {
    [super exitScene];
    stopTimer = YES;
}

-(void)timerUpdate:(NSTimer*)timer  {
	if(stopTimer) {
		[timer invalidate];
		timer = nil;
		return;
	}
    if(loading) {
        hintAvailabilityTime++;
        
        int degreesPerSecond = 1;
        int angle = (hintAvailabilityTime % 360) * degreesPerSecond;
        if(angle < kSweepAngle) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            double secondsAngle = angle + kStartAngle;
            secondHandImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, degreesToRadians(secondsAngle));
            [UIView commitAnimations];
        } else {
            [self hintTimerComplete];
            [textImageView setImage:availableTextImage];
            [backgroundImageView setImage:availableBackgroundImage];
        }
    }
}

-(void)hintTimerComplete {
    loading = NO;
//    RebusPlayState* rebusPlayState = appDelegate.rebusPlayState;
//    rebusPlayState.hintAvailable = YES;
}

-(void)handleHintShownEvent:(NSNotification*)notification {
    //  check if all hints used
    [self stopTimer];
    //RebusPlayState* rebusPlayState = appDelegate.rebusPlayState;
    //if(![rebusPlayState allHintsUsed]) {
        loading = YES;
        hintAvailabilityTime = 0;
        [textImageView setImage:unavailableTextImage];
        [backgroundImageView setImage:unavailableBackgroundImage];
    //}
}

-(void)startTimer {
    loading = YES;
    hintAvailabilityTime = 0;
}

-(void)stopTimer {
    loading = NO;
}

@end
