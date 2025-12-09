#import "PerformanceView.h"
#import "RebusScore.h"
#import "MeterView.h"
#import "ThreadUtil.h"

@interface PerformanceView()
-(void)handleScoreEvent:(NSNotification*)notification;
@end

@implementation PerformanceView

@synthesize coverImageView;

-(id)initWithFrame:(CGRect)f name:(NSString*)n {
    self = [super initWithFrame:f name:n];
    if (self) {
        [super addBackground];
        self.clipsToBounds = YES;
        
        imageArray = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            UIImage* numberImage = [ResourceManager getImage:[NSString stringWithFormat:@"%d", i] module:@"keyboard.performance" isPortrait:NO];
            [imageArray addObject:numberImage];
        }

        pointMeterView = [[MeterView alloc] initWithImages:imageArray];
        pointMeterView.mostSignificantEmpty = [ResourceManager getImage:@"most.significant.digit.empty" module:@"keyboard.performance" isPortrait:NO];
        [layoutManager addView:pointMeterView withKey:@"meter.point" position:XY];
        
        [layoutManager createImageViewWithKey:@"glass" position:XY];
        
        UIImage* coverImage = [ResourceManager getImage:@"cover" module:@"keyboard.performance" isPortrait:NO];
        coverImageView = [[UIImageView alloc] initWithImage:coverImage];
        CGPoint p = [ResourceManager getStyleXY:@"meter.point" module:@"keyboard.performance" isPortrait:NO];
        coverImageView.frameY = p.y;
        coverImageView.frameX = p.x;
        [self addSubview:coverImageView];
        hitMinimumScore = NO;
    }
    return self;
}

-(void)enterScene {
    [super enterScene];
    [self handleScoreEvent:nil];    //  start at new or last score
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScoreEvent:) name:kIncorrectAnswerEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScoreEvent:) name:kHintShownEvent object:nil];
}

-(void)exitScene {
    [super exitScene];
}

-(void)handleScoreEvent:(NSNotification*)notification {
    RebusPlayState* rebusPlayState = appDelegate.rebusPlayState;
    int score = [rebusPlayState getCurrentScore];
    if(!hitMinimumScore && score >= kMinScore) {
        runBlockAfterDelay(0.7, ^{
            [pointMeterView update:score];
        });
    }
    if(score == kMinScore) {
        hitMinimumScore = YES;
    }
}
@end
