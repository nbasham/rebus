#import "DecorationView.h"

@interface DecorationView()
-(void)handleTap:(UITapGestureRecognizer*)tapEvent;
-(void)setCover;
-(void)helpButtonTouch;
@end

@implementation DecorationView

@synthesize performanceCover;
@synthesize selectionView;

-(id)initWithFrame:(CGRect)f name:(NSString*)n {
    self = [super initWithFrame:f name:n];
    if (self) {
        [super addBackground];
        self.clipsToBounds = YES;
        
        UIImage* knobImage = [ResourceManager getImage:@"knob" module:@"keyboard.performance" isPortrait:NO];
        knobImageView = [[UIImageView alloc] initWithImage:knobImage];
        knobImageView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        coverIsUp = [Settings getShowTimer];
        NSString* knobStyle = coverIsUp ? @"knob.up" : @"knob.down";
        knobImageView.center = [ResourceManager getStyleXY:knobStyle module:@"keyboard.performance" isPortrait:NO];
        [self addSubview:knobImageView];
        
        helpButton = [ResourceManager getImageButton:@"button" module:@"keyboard.help" isPortrait:NO hasDownState:YES];
        [helpButton addTarget:self action:@selector(helpButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        [layoutManager addView:helpButton withKey:@"keyboard.help.button" position:XY];

        UIImage* selectionImage = [ResourceManager getImage:@"selection" module:@"answer" isPortrait:NO];
        selectionView = [[UIImageView alloc] initWithImage:selectionImage];
        [layoutManager addView:selectionView withKey:@"answer.selection" position:NONE];
    }
    return self;
}

-(void)helpButtonTouch {
	[SimpleSoundManager playButton];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowAlertEvent object:@"help.topic"];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(CGRectContainsPoint(knobImageView.frame, point)) {
        return YES;
    } else if(CGRectContainsPoint(helpButton.frame, point)) {
        return YES;
    }
    return NO;
}

-(void)enterScene {
    [super enterScene];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.cancelsTouchesInView = NO;
    [knobImageView addGestureRecognizer:tapRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    swipeRecognizer.cancelsTouchesInView = NO;
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight];
    [knobImageView addGestureRecognizer:swipeRecognizer];

    [self setCover];
}

-(void)exitScene {
    [super exitScene];
    [knobImageView removeGestureRecognizer:[knobImageView.gestureRecognizers lastObject]];
}

-(void)handleTap:(UITapGestureRecognizer*)tapEvent {

    int debug = [[ResourceManager getStyle:@"debug.score.cover.triggers.next.puzzle" module:nil isPortrait:NO] intValue];
    //  REMOVE THIS
    if(debug == 1) {
        RebusPlayState* rebusPlayState = appDelegate.rebusPlayState;
        [rebusPlayState skip];
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowSceneEvent object:@"debugPlayScene"];
        return;
    }
    
    [SimpleSoundManager play:@"score-cover"];
    coverIsUp = !coverIsUp;
    [DataUtil setBool:coverIsUp withKey:@"show.timer"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show.timer" object:nil];
    [UIView animateWithDuration:0.75 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if(coverIsUp) {
            knobImageView.center = [ResourceManager getStyleXY:@"knob.up" module:@"keyboard.performance" isPortrait:NO];
            performanceCover.frameBottom = y;
        } else {
            knobImageView.center = [ResourceManager getStyleXY:@"knob.down" module:@"keyboard.performance" isPortrait:NO];
            performanceCover.frameY = y;
        }
    }completion:nil];
}

-(void)setCover {
    CGPoint p = [ResourceManager getStyleXY:@"meter.cover" module:@"keyboard.performance" isPortrait:NO];
    performanceCover.frameX = p.x;
    y = p.y;
    if(coverIsUp) {
        knobImageView.center = [ResourceManager getStyleXY:@"knob.up" module:@"keyboard.performance" isPortrait:NO];
        performanceCover.frameBottom = y;
    } else {
        knobImageView.center = [ResourceManager getStyleXY:@"knob.down" module:@"keyboard.performance" isPortrait:NO];
        performanceCover.frameY = y;
    }
}

@end
