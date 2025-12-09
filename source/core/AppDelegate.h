#import <UIKit/UIKit.h>
#import "Music.h"
#import "Settings.h"
#import "Puzzle.h"
#import "RebusPuzzle.h"
#import "RebusPlayState.h"
#import "LoadingView.h"
#import "FBConnect.h"
#import <StoreKit/StoreKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate, SKPaymentTransactionObserver> {
    SKPayment* payment;
}
    @property (strong, nonatomic) UIWindow *window;
    @property (strong, nonatomic) UINavigationController* navigationController;
    @property (strong, nonatomic) Music* backgroundMusic;
    @property (strong, nonatomic) UIPopoverController* popupController;
    @property (strong, nonatomic) NSArray* puzzles;
    @property (strong, nonatomic) RebusPlayState* rebusPlayState;
    @property (strong, nonatomic) NSMutableArray* scores;
    @property (strong, nonatomic) NSString* currentScene;
    @property (retain, nonatomic) Facebook* facebook;
    @property (strong, nonatomic) LoadingView* loadingView;

-(RebusPuzzle*)getNextPuzzle;
-(RebusPuzzle*)getPuzzleById:(int)i;
-(void)playMusic:(NSString*)fileName ofType:(NSString*)type;
-(void)createGameState;
-(void)tweet:(NSString*)s attachImage:(UIImage*)i;
-(void)logonAndPostToFacebook;
-(void)upgrade;

@end
