#import <UIKit/UIKit.h>

@interface PanoramicView : UIView {
    UIImageView* a;
    UIImageView* b;
	BOOL stopTimer;
    BOOL aToTheRight;
    int imageWidth;
    float interval;
}

-(id)initWithPanoramicImageNamed:(NSString*)name updateInterval:(float)updateInterval;
-(void)start;
-(void)stop;

@end
