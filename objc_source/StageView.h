#import <UIKit/UIKit.h>
#import "SceneView.h"

@interface StageView : SceneView {
    NSString* stageName;
}

-(id)initWithStageName:(NSString*)name;
-(void)enterStage;
-(void)exitStage;

@end
