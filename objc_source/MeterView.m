#import "MeterView.h"
#import "ThreadUtil.h"
#import "AlertUtil.h"

#define kSpecialCaseEmptyHighestOrderDigit -1

@interface MeterView()
-(void)animateDigit:(UIImageView*)imageView currentValue:(int)cv lastValue:(int)lv delay:(int)delay;
-(void)checkArrayIntegrity:(NSArray*)a atIndex:(int)index description:(NSString*)s;
@end

@implementation MeterView

@synthesize mostSignificantEmpty;

//  - should be initWithMagnitude for generalized meter with N digits
-(id)initWithImages:(NSArray*)a {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        imageArray = a;
        UIImage* sampleImage = [imageArray lastObject];
        imageHeight = self.frameHeight = sampleImage.size.height;
        self.frameWidth = sampleImage.size.width * 3;
        self.clipsToBounds = YES;
        lastMeterValue = 100;
        imageViewA = [[UIImageView alloc] initWithImage:[imageArray objectAtIndex:1]];
        imageViewB = [[UIImageView alloc] initWithImage:[imageArray objectAtIndex:0]];
        imageViewC = [[UIImageView alloc] initWithImage:[imageArray objectAtIndex:0]];
        [self addSubview:imageViewA];
        [self addSubview:imageViewB];
        [self addSubview:imageViewC];
        imageViewB.frameX = sampleImage.size.width - 1;
        imageViewC.frameX = imageViewB.frameX + sampleImage.size.width - 1;
        mostSignificantEmpty = nil;
        mostSignificantDigitSet = NO;
    }
    return self;
}

-(void)update:(int)meterValue {
    int a = MIN(9, meterValue / 100);
    int b = (meterValue / 10) % 10;
    int c = meterValue % 10;
    int lastA = MIN(9, lastMeterValue / 100);
    int lastB = (lastMeterValue / 10) % 10;
    int lastC = lastMeterValue % 10;

    if(a != 1 && !mostSignificantDigitSet) {
        if(mostSignificantEmpty != nil) {
            [self animateDigit:imageViewA currentValue:kSpecialCaseEmptyHighestOrderDigit lastValue:lastA delay:0];
            mostSignificantDigitSet = YES;
        } else {
            [UIView animateWithDuration:0.75 animations:^{
                imageViewA.frameY = imageHeight;
            }completion:^(BOOL finished){
                [imageViewA setHidden:YES];
            }];
        }
    } else if(a != lastA) {
        [self animateDigit:imageViewA currentValue:a lastValue:lastA delay:0];
    }
    
    if(b != lastB) {
        [self animateDigit:imageViewB currentValue:b lastValue:lastB delay:0];
    }
    
    if(c != lastC) {
        [self animateDigit:imageViewC currentValue:c lastValue:lastC delay:0];
    }
    lastMeterValue = meterValue;
}

-(void)checkArrayIntegrity:(NSArray*)a atIndex:(int)index description:(NSString*)s {
    NSString* errStr = nil;
    if(a == nil) {
        errStr = [NSString stringWithFormat:@"[%@] array is nil", s];
    } else if (a.count == 0) {
        errStr = [NSString stringWithFormat:@"[%@] array size is 0", s];
    } else if (index >= a.count) {
        errStr = [NSString stringWithFormat:@"[%@] index %d is >= to array size %d", s, index, a.count];
    } else if (index < 0) {
        errStr = [NSString stringWithFormat:@"[%@] index %d is less than 0", s, index];
    }
    if(errStr != nil) {
        [AlertUtil showOKAlert:errStr];
    }
}

-(void)animateDigit:(UIImageView*)imageView currentValue:(int)cv lastValue:(int)lv delay:(int)delay {
//    if(cv == lv) {
//        return;
//    }
    [self checkArrayIntegrity:imageArray atIndex:lv description:@"animateDigit last value"];
    __block UIImageView* lastImageView = [[UIImageView alloc] initWithImage:[imageArray objectAtIndex:lv]];
    lastImageView.frameX = imageView.frameX;
    lastImageView.frameY = 0;
    [self addSubview:lastImageView];
    
    if(cv == kSpecialCaseEmptyHighestOrderDigit) {
        [imageView setImage:mostSignificantEmpty];
    } else {
        [self checkArrayIntegrity:imageArray atIndex:lv description:@"animateDigit current value"];
        [imageView setImage:[imageArray objectAtIndex:cv]];
    }
    imageView.frameBottom = 0;
    
    int diff = abs(lv - cv);
    //DebugLog(@"last = %d curr = %d diff = %d", lv, cv, diff);
    float duration = 0.0;
    NSString* soundName = nil;
    switch (diff) {
        case 1:
        case 9: //  0 - 9
            duration += 0.179;
            soundName = @"digitMove1";
            break;
        case 2:
            duration += 0.358;
            soundName = @"digitMove2";
            break;
        case 3: //  e.g. 80 - 25
            duration += 0.537;
            soundName = @"digitMove3";
            break;
        case 5:
            duration += 0.896;
            soundName = @"digitMove5";
            break;
    }
    if(soundName != nil && cv != kSpecialCaseEmptyHighestOrderDigit) {
        [SimpleSoundManager play:soundName];
    }
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        imageView.frameY = 0;
        lastImageView.frameY = imageHeight;
    }completion:^(BOOL finished){
        [lastImageView removeFromSuperview];
        lastImageView = nil;
        imageView.frameY = 0;
    }];
}

@end
