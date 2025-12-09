#import <UIKit/UIKit.h>
#import "SceneTransitionManager.h"
#import "ModalMessageView.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <GameKit/GameKit.h>

@interface SceneViewController : UIViewController<MFMailComposeViewControllerDelegate, GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate> {
    ModalMessageView* sceneAlertView;
}

@property(nonatomic, strong) SceneTransitionManager* sceneTransitionManager;

-(void)sendEmailTo:(NSString*)address withSubject:(NSString*)subject withBody:(NSString*)body withImage:(NSData*)imageData;

@end
