#import "StageView.h"

@implementation StageView

-(id)initWithStageName:(NSString*)name {
    stageName = [NSString stringWithFormat:@"stage.%@", name];
    self = [super initWithFrame:CGRectMake(0, 0, [DeviceUtil deviceWidth], [RebusGlobals getStageHeight]) name:stageName];
    if (self) {
    }
    return self;
}

-(void)enterStage {
    //DebugLog(@"enterStage:%@", stageName);
}

-(void)exitStage {
    //DebugLog(@"exitStage:%@", stageName);
}

@end
