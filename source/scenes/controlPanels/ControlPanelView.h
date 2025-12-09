#import <UIKit/UIKit.h>
#import "SceneView.h"

@interface ControlPanelView : SceneView {
}

@property(nonatomic, readonly, strong) NSString* controlPanelName;

-(id)initWithControlPanelName:(NSString*)name;
-(void)enterControlPanel;
-(void)exitControlPanel;

@end
