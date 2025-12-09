#import "TimedMessageView.h"
#import "ResourceManager.h"

/*
 Allocation and leak tested for hit case and timer expired case.
 */
@interface TimedMessageView(Private)
    -(void)timerExpired:(NSTimer*)timer;
    -(void)hide;
    -(void)animationFinished;
@end

@implementation TimedMessageView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setAutoresizesSubviews:NO];
        UIImage* i = [ResourceManager getImage:@"timed.message.background" module:@"" isPortrait:NO];
        UIImageView* iv = [[UIImageView alloc] initWithImage:i];
        [self addSubview:iv];
        label = [ResourceManager getLabel:@"timed.message" module:@"" isPortrait:NO data:kNoData];
        [self addSubview:label];
        self.frame = CGRectMake(0, 0, i.size.width, i.size.height);
        label.frame = CGRectMake(0, i.size.height/2 - [label.font pointSize]/2, self.frame.size.width, [label.font pointSize]);
        [self setAlpha:0.0];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    [self hide];
    return nil; // let touch pass through
}

-(void)showMessage:(NSString*)messageKey forSeconds:(int)seconds onView:(UIView*)parentView {
    hidden = NO;
    self.center = parentView.center;
    [parentView bringSubviewToFront:self];
    label.text = [ResourceManager getLocalizedString:messageKey module:nil isPortrait:NO];
    [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(timerExpired:) userInfo:nil repeats:NO];
    [parentView addSubview:self];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self setAlpha:1.0];
    [UIView commitAnimations];
}

-(void)timerExpired:(NSTimer*)timer {
    if([timer isValid]) {
        [timer invalidate];
    }
    [self hide];
}

-(void)hide {
    if(hidden == NO) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.75];
        [self setAlpha:0.0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationFinished)];
        [UIView commitAnimations];
    }
    hidden = YES;
}

-(void)animationFinished {
    [self removeFromSuperview];
}

@end
