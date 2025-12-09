#import <UIKit/UIKit.h>

#define kRequestLoadingViewEvent @"kRequestLoadingViewEvent"

@interface LoadingView : UIView {
	UIActivityIndicatorView* loadingSpinner;
    UILabel* messageLabel;
}

-(void)show;
-(void)showWithMessage:(NSString*)messagemessageKey;
-(void)hide;

@end
