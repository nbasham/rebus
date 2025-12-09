#import <UIKit/UIKit.h>
#import "LayoutManager.h"
#import "AppDelegate.h"

@interface StageSignView : UIView {
    LayoutManager* layoutManager;
    UITapGestureRecognizer* tapRecognizer;
    AppDelegate* appDelegate;
    NSDate* enterTime;
}

@property(nonatomic, strong) NSString* name;

-(void)cleanUp;
-(void)show;
-(void)hide;
-(void)beforeShowAnimation;
-(void)beforeHideAnimation;
-(void)showAnimationComplete;
-(void)hideAnimationComplete;
-(void)addMessageView;
-(CGRect)getLargeSignBackgroundViewableRect;
-(void)dismissOnTouch;
-(void)disableControlPanel;
-(UIImageView*)addImage:(NSString*)n;

@end
