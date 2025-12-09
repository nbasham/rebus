#import "RatingView.h"

#define NUM_BUTTONS 5

@interface RatingView(Private)
    -(void)handleuttonTouch:(UIButton*)b forEvent:(UIEvent*)event;
    -(void)updateStars;
@end

@implementation RatingView

@synthesize allowHalves;
@synthesize value;
//@synthesize eventType;

-(id)init {
    self = [self initWithDelegate:nil];
    return self;
}

-(id)initWithDelegate:(id<RatingViewDelegate>)d {
    on = [ResourceManager getImage:@"rating.star.on" module:nil isPortrait:NO];
    buttonWidth = on.size.width;
    buttonHeight = on.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, buttonWidth*NUM_BUTTONS, buttonHeight)];
    if (self) {
        delegate = d;
        allowHalves = YES;
//        eventType = kRatingEvent;
        self.backgroundColor = [UIColor clearColor];
        viewList = [[NSMutableArray alloc] initWithCapacity:NUM_BUTTONS];
        off = [ResourceManager getImage:@"rating.star.off" module:nil isPortrait:NO];
        half = [ResourceManager getImage:@"rating.star.half" module:nil isPortrait:NO];
        for (int i = 0; i < NUM_BUTTONS; i++) {
            UIImageView* o = [[UIImageView alloc] initWithImage:off];
            o.frameOrigin = CGPointMake(i*buttonWidth, 0);
            o.userInteractionEnabled = NO;
            [self addSubview:o];
            [viewList addObject:o];
        }
        value = 0.0;
    }
    return self;
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch* touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    float f = touchPoint.x / (buttonWidth * 1.0);
    [self setValue:f];
//    [[NSNotificationCenter defaultCenter] postNotificationName:eventType object:[NSNumber numberWithFloat:value]];
}

-(void)updateStars {
    int index = (int)value;
    for (int i = 0; i < NUM_BUTTONS; i++) {
        UIImageView* o = [viewList objectAtIndex:i];
        if(i < index) {
            o.image = on;
        } else if(i == index) {
            if(value - index > 0.001) {
                o.image = half;
            } else {
                o.image = off;
            }
        } else {
            o.image = off;
        }
    }
}

-(NSString*)getStringValue {
    if(allowHalves) {
        return [NSString stringWithFormat:@"%1.1f", value];
    } else {
        return [NSString stringWithFormat:@"%d", (int)value];
    }
}

-(void)setValue:(float)v {
    int intVal = (int)v;
    if(allowHalves) {
        if((v - intVal) >= 0.5) {
            value = intVal + 1;
        } else {
            value = intVal + 0.5;
        }
    } else {
        value = intVal + 1;
    }
    [self updateStars];
    if(delegate != nil) {
        [delegate ratingChoiceMade:value];
    }
    DebugLog(@"%@", [self getStringValue]);
}

@end
