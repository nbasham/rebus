#import <UIKit/UIKit.h>
#import "ModalMessageViewDelegate.h"

@interface ModalMessageView : UIView {
    UITapGestureRecognizer* tapRecognizer;
    UIView* contentView;
    UIView* touchView;
    UIView* backgroundView;
    BOOL isTouchEnabled;
    NSDate* enterTime;
}

@property(nonatomic, strong) id<ModalMessageViewDelegate> delegate;

-(id)initWithDelegate:(id<ModalMessageViewDelegate>)delegate;
-(void)show;
-(void)hide;

@end
