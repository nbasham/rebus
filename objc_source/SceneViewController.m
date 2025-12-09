#import "SceneViewController.h"
#import "ControlPanelManagerView.h"
#import "StageManagerView.h"
#import "ThreadUtil.h"
#import "RebusPlayState.h"
#import "StringUtil.h"
#import "HelpTopicModalMessageViewDelegate.h"

@interface SceneViewController()
-(void)handleShowAlertEvent:(NSNotification*)notification;
-(void)handleHideAlertEvent:(NSNotification*)notification;
-(void)pauseGame;
-(void)exitGame;
@end

@implementation SceneViewController

@synthesize sceneTransitionManager;

-(id)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        UIImage* woodImage = [ResourceManager getImage:@"background" module:@"control.panel.manager" isPortrait:NO];
        UIImageView* woodImageView = [[UIImageView alloc] initWithImage:woodImage];
        woodImageView.frameY = [DeviceUtil deviceHeight] - [RebusGlobals getControlPanelHeight];
        [self.view addSubview:woodImageView];
        
        StageManagerView* stageManagerView = [[StageManagerView alloc] initWithFrame:CGRectMake(0, 0, [DeviceUtil deviceWidth], [RebusGlobals getStageHeight])];
        [self.view addSubview:stageManagerView];
        int y = [DeviceUtil deviceHeight] - [RebusGlobals getControlPanelHeight];
        ControlPanelManagerView* controlPanelManagerView = [[ControlPanelManagerView alloc] initWithFrame:CGRectMake(0, y, [DeviceUtil deviceWidth], [RebusGlobals getControlPanelHeight])];
        [self.view addSubview:controlPanelManagerView];

        sceneTransitionManager = [[SceneTransitionManager alloc] initWithControlPanelManager:controlPanelManagerView stageManagerView:stageManagerView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShowAlertEvent:) name:kShowAlertEvent object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHideAlertEvent:) name:kHideAlertEvent object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGame) name:kExitGameRequest object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseGame) name:kPauseGameRequest object:nil];
    }
    return self;
}


-(void)pauseGame {
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        [sceneTransitionManager.stageManagerView closeCover];
    }completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowSignEvent object:@"pause"];
    }];
}

-(void)exitGame {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    RebusPlayState* rebusPlayState = appDelegate.rebusPlayState;
    if(rebusPlayState.dirty) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowSignEvent object:@"saveGame"];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowSceneEvent object:kMenuScene];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void)handleMemoryWarningEvent:(NSNotification*)notification {
}

/*
 SceneViewController gets a show message event that includes a message description. It instantiates a modal message
 with a delegate based on the message description. SceneViewController gets a hide message event and cleans up.
 SceneViewController holds a reference to the modal message, this reference is nil when a message is not being viewed.
 */
-(void)handleShowAlertEvent:(NSNotification*)notification {
    NSString* message = notification.object;
    id<ModalMessageViewDelegate> delegate;
    if ([message isEqualToString:@"help.topic"]) {
        delegate = [[HelpTopicModalMessageViewDelegate alloc] init];
    }
    
    delegate.message = message;
    sceneAlertView = [[ModalMessageView alloc] initWithDelegate:delegate];
    [self.view addSubview:sceneAlertView];
    [self.view bringSubviewToFront:sceneAlertView];
    [sceneAlertView show];
}

-(void)handleHideAlertEvent:(NSNotification*)notification {
    [sceneAlertView hide];
    [sceneAlertView removeFromSuperview];
    sceneAlertView = nil;
}

-(void)sendEmailTo:(NSString*)address withSubject:(NSString*)subject withBody:(NSString*)body withImage:(NSData*)imageData {
    @try {
        MFMailComposeViewController* picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = (id<MFMailComposeViewControllerDelegate>)self;
        [picker setSubject:subject];
        [picker setMessageBody:body isHTML:YES];
        if(address != nil) {
            NSArray* toRecipients = [NSArray arrayWithObject:address];
            [picker setToRecipients:toRecipients];
        }
        if(imageData != nil) {
            [picker addAttachmentData:imageData mimeType:@"image/png" fileName:subject];
        }
        [self presentModalViewController:picker animated:YES];
    }
    @catch (NSException* e) {
        DebugLog(@"sendEmailTo failed");
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissModalViewControllerAnimated:YES];
    DebugLog(@"email error %@", [error description]);
    switch (result) {
        case MFMailComposeResultCancelled:
            DebugLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            DebugLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            DebugLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            DebugLog(@"Result: failed");
            break;
        default:
            DebugLog(@"Result: not sent");
            break;
    }
}

-(void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController*)viewController {
	[self dismissModalViewControllerAnimated:YES];
}

-(void)achievementViewControllerDidFinish:(GKAchievementViewController*)viewController {
	[self dismissModalViewControllerAnimated:YES];
}

@end
