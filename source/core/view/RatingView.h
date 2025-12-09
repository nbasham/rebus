#import <UIKit/UIKit.h>

#define kRatingEvent @"kRatingEvent"


@protocol RatingViewDelegate <NSObject>

@optional -(void)ratingChoiceMade:(float)value;

@end

@interface RatingView : UIView {
    NSMutableArray* viewList;
    UIImage* on;
    UIImage* off;
    UIImage* half;
    id<RatingViewDelegate> delegate;
    int buttonWidth;
    int buttonHeight;
}

@property(nonatomic, assign) BOOL allowHalves;
@property(nonatomic, assign) float value;
//@property(nonatomic) NSString* eventType;

-(id)initWithDelegate:(id<RatingViewDelegate>)d;
-(NSString*)getStringValue;

@end
