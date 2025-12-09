#import <UIKit/UIKit.h>
#import "SignDelegate.h"
#import "LayoutManager.h"

@interface SignView : UIView {
    UIImageView* signImageView;
    UIImageView* signMessageImageView;
    LayoutManager* layoutManager;
}

-(void)show:(NSString*)signName delegate:(id<SignDelegate>)delegate;
-(void)hide;

@end
