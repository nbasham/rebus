#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LayoutManager.h"

@interface SceneView : UIView {
    AppDelegate* appDelegate;
    LayoutManager* layoutManager;
}

@property(nonatomic, strong) NSString* name;

-(id)initWithFrame:(CGRect)r name:(NSString*)n;
-(UIImageView*)addBackground;
-(void)enterScene;
-(void)exitScene;

@end
