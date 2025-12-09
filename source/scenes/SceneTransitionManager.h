#import <Foundation/Foundation.h>
#import "ControlPanelManagerView.h"
#import "StageManagerView.h"

@interface SceneTransitionManager : NSObject {
    NSString* lastSceneName;
    NSDictionary* sceneDirectory;
    BOOL stageTransitionCompleted;
    BOOL controlPanelTransitionCompleted;
}

@property(nonatomic, strong) StageManagerView* stageManagerView;
@property(nonatomic, strong) ControlPanelManagerView* controlPanelManagerView;

-(id)initWithControlPanelManager:(ControlPanelManagerView*)cpmv stageManagerView:(StageManagerView*)smv;
-(void)setScene:(NSString*)sceneName;

@end
