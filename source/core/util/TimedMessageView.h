#import <UIKit/UIKit.h>

@interface TimedMessageView : UIView {
    @private UILabel* label;
    BOOL hidden;
}

-(void)showMessage:(NSString*)messageKey forSeconds:(int)seconds onView:(UIView*)parentView;

@end
