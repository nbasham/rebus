#import "ControlPanelView.h"

@implementation ControlPanelView

@synthesize controlPanelName;

-(id)initWithControlPanelName:(NSString*)name {
    controlPanelName = [NSString stringWithFormat:@"control.panel.%@", name];
    self = [super initWithFrame:CGRectMake(0, 0, [DeviceUtil deviceWidth], [RebusGlobals getControlPanelHeight]) name:controlPanelName];
    if (self) {
    }
    return self;
}

-(void)enterControlPanel {
    //DebugLog(@"enterControlPanel:%@", controlPanelName);
}

-(void)exitControlPanel {
    //DebugLog(@"exitControlPanel:%@", controlPanelName);
}

@end
