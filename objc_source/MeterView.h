#import <UIKit/UIKit.h>

@interface MeterView : UIView {
    UIImageView* imageViewA;
    UIImageView* imageViewB;
    UIImageView* imageViewC;
    NSArray* imageArray;
	BOOL stopTimer;
    int lastMeterValue;
    int imageHeight;
    BOOL mostSignificantDigitSet;
}

@property(nonatomic, strong) UIImage* mostSignificantEmpty;

-(id)initWithImages:(NSArray*)a;
-(void)update:(int)meterValue;

@end
