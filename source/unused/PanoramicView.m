#import "PanoramicView.h"

@interface PanoramicView()
-(void)timerUpdate:(NSTimer*)timer;
@end

@implementation PanoramicView

-(id)initWithPanoramicImageNamed:(NSString*)name updateInterval:(float)updateInterval {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        UIImage* i = [UIImage imageNamed:name];
        imageWidth = i.size.width;
        a = [[UIImageView alloc] initWithImage:i];
        b = [[UIImageView alloc] initWithImage:i];
        [self addSubview:a];
        [self addSubview:b];
        aToTheRight = YES;
        interval = updateInterval;
    }
    return self;
}

-(void)timerUpdate:(NSTimer*)timer  {
	if(stopTimer) {
		[timer invalidate];
		timer = nil;
		return;
	}
    if(aToTheRight) {
        a.frameX += 2;
        if(a.frameX > imageWidth) {
            a.frameRight = b.frameX - 1;
            aToTheRight = NO;
        } else {
            b.frameRight = a.frameX + 1;
        }
    } else {
        b.frameX += 2;
        if(b.frameX > imageWidth) {
            b.frameRight = a.frameX - 1;
            aToTheRight = YES;
        } else {
            a.frameRight = b.frameX + 1;
        }
    }
}

-(void)start {
    stopTimer = NO;
    [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerUpdate:) userInfo:nil repeats:YES];
}

-(void)stop {
    stopTimer = YES;
    a = nil;
    b = nil;
}

@end
