#import "ModalMessageView.h"
#import "UsageTracking.h"

@interface ModalMessageView()
-(void)handleTouchViewTap:(UITapGestureRecognizer*)tapEvent;
-(void)enableTouchViewIfNeeded;
@end

@implementation ModalMessageView

@synthesize delegate;

-(id)initWithDelegate:(id<ModalMessageViewDelegate>)d {
    self = [super initWithFrame:CGRectMake(0, 0, [DeviceUtil deviceWidth], [DeviceUtil deviceHeight])];
    if (self) {
        delegate = d;
        [self setHidden:YES];
        touchView = [[UIView alloc] initWithFrame:self.frame];
        touchView.backgroundColor = [UIColor clearColor];
        [self addSubview:touchView];
    }
    return self;
}

-(void)enableTouchViewIfNeeded {
    if([delegate dismissOnTouch]) {
        isTouchEnabled = YES;
        touchView.userInteractionEnabled = YES;
        [self bringSubviewToFront:touchView];
    } else {
        isTouchEnabled = NO;
        touchView.userInteractionEnabled = NO;
    }
    
}

-(void)show {
    backgroundView = [delegate getBackgroundView];
    if(backgroundView) {
        [self addSubview:backgroundView];
    }
    [self enableTouchViewIfNeeded];
    [self setHidden:NO];
    contentView = [delegate getMessageView];
    [delegate willShow];
    
    contentView.center = self.center;
    [contentView setHidden:YES];
    [self addSubview:contentView];
    self.alpha = 0.0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.alpha = 1.0;
    }completion:^(BOOL finished) {
        [contentView setHidden:NO];
        if(isTouchEnabled) {
            tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouchViewTap:)];
            tapRecognizer.numberOfTapsRequired = 1;
            tapRecognizer.cancelsTouchesInView = NO;
            [self addGestureRecognizer:tapRecognizer];
            [touchView addGestureRecognizer:tapRecognizer];
            [self bringSubviewToFront:touchView];
        }
    }];
    enterTime = [NSDate date];
    [delegate didShow];
}

-(void)hide {
    int elapsedSeconds = -[enterTime timeIntervalSinceNow];
    if(elapsedSeconds < 120) {
        //  skip views of over 2 minutes
        [UsageTracking trackEvent:@"message.time" action:delegate.message label:nil value:elapsedSeconds];
    }
    [delegate willHide];
    [contentView removeFromSuperview];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.alpha = 0.0;
    }completion:^(BOOL finished) {
        if(isTouchEnabled) {
            [touchView removeGestureRecognizer:tapRecognizer];
            tapRecognizer = nil;
        }
        [self setHidden:YES];
        [delegate didHide];
        contentView = nil;
        if(backgroundView) {
            [backgroundView removeFromSuperview];
            backgroundView = nil;
        }
    }];
}

-(void)handleTouchViewTap:(UITapGestureRecognizer*)tapEvent {
    [self hide];
}

@end
