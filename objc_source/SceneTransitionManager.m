#import "SceneTransitionManager.h"
#import "UsageTracking.h"
#import "AppDelegate.h"
#import "ThreadUtil.h"
#import "RebusGlobals.h"

@interface SceneTransitionManager()
-(void)setScene:(NSString*)name;
-(void)handleNavigationEvent:(NSNotification*)notification;
-(BOOL)stageDidChange:(NSString*)s;
-(BOOL)controlPanelDidChange:(NSString*)s;
-(NSString*)getPreviousStageName;
-(NSString*)getPreviousControlPanelName;
-(NSString*)getStageNameFromSceneName:(NSString*)sceneName;
-(NSString*)getControlPanelNameFromSceneName:(NSString*)sceneName;
-(void)handleStageTransitionCompletedEvent;
-(void)handleControlPanelTransitionCompletedEvent;
-(void)checkIfTransitionCompleted;
@end

@implementation SceneTransitionManager

@synthesize stageManagerView;
@synthesize controlPanelManagerView;

-(id)initWithControlPanelManager:(ControlPanelManagerView*)cpmv stageManagerView:(StageManagerView*)smv {
    self = [super init];
    if (self) {
        controlPanelManagerView = cpmv;
        stageManagerView = smv;
        NSString* path = [[NSBundle mainBundle] pathForResource: @"rebus.scenes" ofType:@"plist"];
        sceneDirectory = [NSDictionary dictionaryWithContentsOfFile:path];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNavigationEvent:) name:kShowSceneEvent object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStageTransitionCompletedEvent) name:kStageTransitionCompletedEvent object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleControlPanelTransitionCompletedEvent) name:kControlPanelTransitionCompletedEvent object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
 EVENT ORDER
 
 enterStage             nextStage
 enterControlPanel      nextControlPanel
 exitStage              previousStage
 exitControlPanel       previousControlPanel
 exitScene              previousStage
 exitScene              previousControlPanel
 enterScene             nextStage
 enterScene             nextControlPanel
 */
-(void)setScene:(NSString*)sceneName {
    if(lastSceneName == sceneName) {
        return;
    }

    stageManagerView.stageView.userInteractionEnabled = NO;
    controlPanelManagerView.controlPanelView.userInteractionEnabled = NO;

    //  REMOVE THIS
    BOOL debugFakeNextPuzzle = NO;
    if([sceneName isEqualToString:@"debugPlayScene"]) {
        sceneName = kPlayScene;
        debugFakeNextPuzzle = YES;
    }
    
    //  a hint so play stage knows if it's part of play or solved
    if([sceneName isEqualToString:@"solved"]) {
        [DataUtil setBool:YES withKey:@"inSolvedScene"];
    } else {
        [DataUtil setBool:NO withKey:@"inSolvedScene"];
    }
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.currentScene = sceneName;
    if([RebusGlobals isUnpaid] && [sceneName isEqualToString:@"scores"]) {
        [UsageTracking trackPageView:@"upgrade"];
    } else {
        [UsageTracking trackPageView:sceneName];
    }
    BOOL firstTime = lastSceneName == nil;
    NSString* stageName = [self getStageNameFromSceneName:sceneName];
    if (firstTime) {
        [stageManagerView setStage:stageName];
    } else if([self stageDidChange:stageName] || debugFakeNextPuzzle) {
        [stageManagerView setStage:stageName];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kStageTransitionCompletedEvent object:nil];
    }
    NSString* controlPanelName = [self getControlPanelNameFromSceneName:sceneName];
    if (firstTime) {
        [controlPanelManagerView setControlPanel:controlPanelName];
    } else if([self controlPanelDidChange:controlPanelName] || debugFakeNextPuzzle) {
        [controlPanelManagerView setControlPanel:controlPanelName];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kControlPanelTransitionCompletedEvent object:nil];
    }
    lastSceneName = sceneName;
    __block ControlPanelView* pcp = controlPanelManagerView.previousControlPanelView;
    __block StageView* ps = stageManagerView.previousStageView;
    runBlockAfterDelay(2.0, ^{
        [ps exitStage];
        [pcp exitControlPanel];
        [ps exitScene];
        [pcp exitScene];
        stageManagerView.previousStageView = nil;
        ps = nil;
        controlPanelManagerView.previousControlPanelView = nil;
        pcp = nil;
        stageManagerView.stageView.userInteractionEnabled = YES;
        controlPanelManagerView.controlPanelView.userInteractionEnabled = YES;
        [appDelegate playMusic:sceneName ofType:@"mp3"];
    });
}

-(void)handleStageTransitionCompletedEvent {
    stageTransitionCompleted = YES;
    [self checkIfTransitionCompleted];
}

-(void)handleControlPanelTransitionCompletedEvent {
    controlPanelTransitionCompleted = YES;
    [self checkIfTransitionCompleted];
}

-(void)checkIfTransitionCompleted {
    //NSLog(@"checkIfTransitionCompleted lsn=%@ stage=%d cp=%d", lastSceneName, stageTransitionCompleted, controlPanelTransitionCompleted);
    if(stageTransitionCompleted && controlPanelTransitionCompleted) {
        stageTransitionCompleted = NO;
        controlPanelTransitionCompleted = NO;
        
//        NSLog(@"%@.checkIfTransitionCompleted", controlPanelManagerView.previousControlPanelView.controlPanelName);
//        [stageManagerView.previousStageView exitStage];
//        [controlPanelManagerView.previousControlPanelView exitControlPanel];
//        [stageManagerView.previousStageView exitScene];
//        [controlPanelManagerView.previousControlPanelView exitScene];

        [stageManagerView.stageView enterScene];
        [controlPanelManagerView.controlPanelView enterScene];
        
//        stageManagerView.previousStageView = nil;
//        controlPanelManagerView.previousControlPanelView = nil;
//        NSLog(@"checkIfTransitionCompleted end");
    }
}

-(BOOL)stageDidChange:(NSString*)s {
//    DebugLog(@"Stage name: %@ Previous stage name: %@", [self getStageNameFromSceneName:s], [self getPreviousControlPanelName]);
    if([[self getStageNameFromSceneName:s] isEqualToString:kPlayStage] && [[self getPreviousControlPanelName] isEqualToString:kSolvedControlPanel]) {
        //  special to refresh play stage when coming directly from solved scene 
        return YES;
    }
    BOOL b = [[self getStageNameFromSceneName:s] isEqualToString:[self getPreviousStageName]];
    return !b;
}

-(BOOL)controlPanelDidChange:(NSString*)s {
    if([RebusGlobals didUserJustUpdate:@"xxxreloadcontrolpanelxxx"]) {
        return YES;
    }
    BOOL b = [[self getControlPanelNameFromSceneName:s] isEqualToString:[self getPreviousControlPanelName]];
    return !b;
}

-(NSString*)getPreviousStageName {
    return [self getStageNameFromSceneName:lastSceneName];
}

-(NSString*)getPreviousControlPanelName {
    return [self getControlPanelNameFromSceneName:lastSceneName];
}

-(NSString*)getStageNameFromSceneName:(NSString*)sceneName {
    if(sceneName != nil) {
        NSDictionary* scene = [sceneDirectory objectForKey:sceneName];
        NSString* stageName = [scene objectForKey:@"stage"];
        if([@"scores" isEqualToString:stageName] && [RebusGlobals isUnpaid]) {
            return @"upgrade";
        } else {
            return stageName;
        }
    }
    return nil;
}

-(NSString*)getControlPanelNameFromSceneName:(NSString*)sceneName {
    if(sceneName != nil) {
        NSDictionary* scene = [sceneDirectory objectForKey:sceneName];
        NSString* controlPanelNameName = [scene objectForKey:@"control.panel"];
        return controlPanelNameName;
    }
    return nil;
}

-(void)handleNavigationEvent:(NSNotification*)notification {
    NSString* eventType = [notification name];
    if ([kShowSceneEvent isEqualToString:eventType]) {
        NSString* sceneName = [notification object];
        [self setScene:sceneName];
    }
}

@end
