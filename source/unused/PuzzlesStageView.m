#import "PuzzlesStageView.h"

@interface PuzzlesStageView()
-(void)timerUpdate:(NSTimer*)timer;
@end

@implementation PuzzlesStageView

-(id)initWithStageName:(NSString*)name {
    self = [super initWithStageName:name];
    if (self) {
        UIImage* i = [UIImage imageNamed:@"panorama.png"];
        imageWidth = i.size.width;
        a = [[UIImageView alloc] initWithImage:i];
        b = [[UIImageView alloc] initWithImage:i];
        [self addSubview:a];
        [self addSubview:b];
        
        i = [UIImage imageNamed:@"spaceship.png"];
        UIImageView* c = [[UIImageView alloc] initWithImage:i];
        [self addSubview:c];
        c.center = self.center;

        aToTheRight = YES;
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

-(void)enterStage {
    [super enterScene];
    stopTimer = NO;
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerUpdate:) userInfo:nil repeats:YES];
}

-(void)exitScene {
    [super exitScene];
    stopTimer = YES;
    a = nil;
    b = nil;
}

@end
