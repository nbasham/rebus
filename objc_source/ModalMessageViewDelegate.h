#import <Foundation/Foundation.h>

@protocol ModalMessageViewDelegate <NSObject>

@property(nonatomic, strong) NSString* message;

-(UIView*)getMessageView;
@optional -(void)willShow;
@optional -(void)didShow;
@optional -(void)willHide;
@optional -(void)didHide;
@optional -(BOOL)dismissOnTouch;
@optional -(UIView*)getBackgroundView;

@end
