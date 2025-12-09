#import "AppDelegate.h"
#import "ClassUtil.h"
#import "SceneViewController.h"
#import "Music.h"
#import "Puzzle.h"
#import "Products.h"
#import "RebusScore.h"
#import "TwitterUtil.h"
#import "RebusTools.h"
#import "RebusPuzzle.h"
#import "Achievements.h"
#import "GameCenter.h"
#import "UsageTracking.h"
#import "StringUtil.h"
#import "RebusGlobals.h"
#import "UIDeviceHardware.h"
#import "RebusServer.h"
#import "LoadingView.h"
#import "ThreadUtil.h"
#import "AlertUtil.h"
#import "RebusGlobals.h"

@interface AppDelegate()
-(void)loadScores;
-(void)loadRebusPuzzles;
-(int)submitScoresToGameCenter;
-(void)handlePuzzleSolvedEvent:(NSNotification*)notification;
-(void)postToFacebook;
+(void)firstTime;
-(int)getMaxPuzzleCount;
-(void)authenticatedGameCenterPlayer:(NSNotification*)notification;

-(void)completeTransaction:(SKPaymentTransaction*)transaction;
-(void)restoreTransaction:(SKPaymentTransaction*)transaction;
-(void)failedTransaction:(SKPaymentTransaction*)transaction;
-(void)hideLoadingView;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController;
@synthesize backgroundMusic;
@synthesize popupController;
@synthesize puzzles;
@synthesize rebusPlayState;
@synthesize scores;
@synthesize currentScene;
@synthesize facebook;
@synthesize loadingView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [UsageTracking initAnalytics];
    //[RebusTools createServerPuzzle:197 solution:@"The Bare Essentials"];
    //[RebusTools createServerPuzzles];
    //[RebusTools createPuzzleFileList];
    //[RebusTools remove:@"@2x" fromFilesInDir:@"/Users/nbasham/Documents/dev/farm/rawPuzzles"];
    //[RebusTools addPhoneToName:@"/Users/nbasham/Library/Mail Downloads/performance 57%"];
    //[RebusTools remove:@".pad" fromFilesInDir:@"/Users/nbasham/Library/Mail Downloads/performance 57%"];
    [self loadScores];
    [self loadRebusPuzzles];
    SceneViewController* rootController = [[SceneViewController alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:rootController selector:@selector(handleMemoryWarningEvent:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
	navigationController = [[UINavigationController alloc] initWithRootViewController:rootController];
    navigationController.navigationBarHidden = YES;
	[self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePuzzleSolvedEvent:) name:kPuzzleSolvedEvent object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowSceneEvent object:kMenuScene];
    
    BOOL addTestScores = NO;
    if(addTestScores) {
        for (int i = 0; i < 25; i++) {
            RebusPuzzle* p = [puzzles objectAtIndex:i];
            int pid = p.puzzleId;
            RebusScore* s = [RebusScore createSample:pid];
            [scores addObject:s];
        }
        [DataUtil writeArray:scores fileName:@"scores.plist"];
    }

    if([RebusGlobals isUnpaid]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    } else {
        [[GameCenter singleton] authenticateLocalPlayer];
    }
    
    NSString* facebookAppId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"facebookAppId"];
    facebook = [[Facebook alloc] initWithAppId:facebookAppId andDelegate:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }

    [AppDelegate firstTime];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticatedGameCenterPlayer:) name:@"authenticatedGameCenterPlayer" object:nil];

    return YES;
}

+(void)firstTime {
    BOOL isFirstTime = [DataUtil isKeyUndefinedThenDefine:@"firstTimeInApp"];
    if(isFirstTime) {
        NSString* device = [UIDeviceHardware deviceName];
        NSString* systemVersion = [[UIDevice currentDevice] systemVersion];
        [UsageTracking trackEvent:@"device.name" action:device label:nil value:-1];
        [UsageTracking trackEvent:@"ios.version" action:systemVersion label:nil value:-1];
    }
}

-(void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [self postToFacebook];
}

- (void)fbDidNotLogin:(BOOL)cancelled {    
}

- (void)fbDidLogout {
}

- (void)fbDidExtendToken:(NSString*)accessToken expiresAt:(NSDate*)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)fbSessionInvalidated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

-(void)logonAndPostToFacebook {
    if (![facebook isSessionValid]) {
        [facebook authorize:[NSArray arrayWithObject:@"user_status"]];
    } else {
        [self postToFacebook];
    }
}

/*
 https://developers.facebook.com/docs/reference/dialogs/feed/
 The 'title' field no longer appears to be supported by Facebook
 */
-(void)postToFacebook {
    NSString* imageLink = [RebusServer getWebImageUrlFromPuzzle:rebusPlayState.puzzle];
    NSString* pageLink = [RebusServer getWebPuzzleUrlFromPuzzle:rebusPlayState.puzzle];
    NSString* facebookAppId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"facebookAppId"];
    NSString* productName = [RebusGlobals getProductName];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   facebookAppId, @"app_id",
                                   imageLink, @"picture",
                                   pageLink, @"link",
                                   productName, @"name",
                                   @" ", @"caption",
                                   @"Can you solve it? Give it a try!", @"description",
                                   nil];
    [facebook dialog:@"feed" andParams:params andDelegate:nil];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL wasHandled = [facebook handleOpenURL:url];
    NSLog(@"openURL was handled = %d", wasHandled);
    return wasHandled; 
}

-(void)playMusic:(NSString*)fileName ofType:(NSString*)type {
    static NSString* lastPath = nil;
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    if(path != nil) {
        if(![path isEqualToString:lastPath]) {
            [backgroundMusic stop];
            backgroundMusic = nil;
            backgroundMusic = [[Music alloc] initWithFileName:fileName ofType:type];
            [backgroundMusic setAugmentedVolume];
            [backgroundMusic play];
            lastPath = path;
        }
    }
}

-(void)loadScores {
    NSArray* a = [DataUtil readArrayFromFile:@"scores.plist"];
    if(a == nil) {
        scores = [[NSMutableArray alloc] init];
    } else {
        scores = [a mutableCopy];
    }
}

-(void)createGameState {
    if(self.rebusPlayState != nil) {
        self.rebusPlayState.puzzle = nil;
        [self.rebusPlayState.answerStates removeAllObjects];
        self.rebusPlayState.answerStates = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self.rebusPlayState];
        [self.rebusPlayState stopTimer];
        self.rebusPlayState = nil;
    }
    self.rebusPlayState = nil;
    if([PlayState exists]) {
        self.rebusPlayState = [PlayState loadLastGame];
    } else {
        self.rebusPlayState = [[RebusPlayState alloc] init];
        RebusPuzzle* p = [self getNextPuzzle];
        [self.rebusPlayState setPuzzle:p];
    }
}

-(void)handlePuzzleSolvedEvent:(NSNotification*)notification {
    RebusScore* score = [notification object];
    [scores addObject:score];
    if(![RebusGlobals isUnpaid]) {
        [self submitScoresToGameCenter];
    }
    id<Achievements> achievements = [[NSClassFromString([Products productKeyToClassName:@"Achievements"]) alloc] init];
    [achievements updateAchievementIfNecessary];
	[DataUtil writeArray:scores fileName:@"scores.plist"];
}

-(int)submitScoresToGameCenter {
    int numCategoriesSubmitted = 0;
    int scoreCategoryIndex = scores.count / 25;
    if(scoreCategoryIndex > 0) {
        for (int i = 0; i < scoreCategoryIndex; i++) {
            NSString* freeCategoryModifier = [RebusGlobals isFreeApp] ? @"free." : @"";
            NSString* scoreCategory = [NSString stringWithFormat:@"rebus.%@score.category.%d", freeCategoryModifier, i];
            if([DataUtil keyUndefined:scoreCategory]) {
                [DataUtil setString:scoreCategory withKey:scoreCategory];
                int start = i * 25;
                int end = start + 25;
                int total = 0;
                for (int j = start; j < end; j++) {
                    RebusScore* score = [scores objectAtIndex:j];
                    if(score.score == kSkippedScore) {
                        continue;
                    }
                    total += score.score;
                }
                [[GameCenter singleton] postScore:total toCategory:scoreCategory];
                DebugLog(@"GameCenter postScore '%@' total %d", scoreCategory, total);
                numCategoriesSubmitted++;
            }
        }
    }
    return numCategoriesSubmitted;
}

-(void)loadRebusPuzzles {
    puzzles = [[NSMutableArray alloc] init];
    NSArray* a = [DataUtil fileLines:@"puzzleList.txt"];
    for (NSString* puzzleData in a) {
        NSArray* chunks = [puzzleData componentsSeparatedByString: @"\t"];
        if([chunks count] != 2) {
            DebugLog(@"File puzzleList.txt error: %@", puzzleData);
        }
        int puzzleId = [[chunks objectAtIndex:0] intValue];
        if(puzzleId == -1) {
            break; // till all puzzles are completed
        }
        NSString* solution = [chunks lastObject];
        RebusPuzzle* puzzle = [[RebusPuzzle alloc] initWithId:puzzleId solution:solution];
        [(NSMutableArray*)puzzles addObject:puzzle];
    }
//    for (RebusPuzzle* p in puzzles) {
//        DebugLog(@"%d\t%@", p.puzzleId, p.solution);
//    }
}

-(int)getMaxPuzzleCount {
    if([RebusGlobals isUnpaid]) {
        return kFreePuzzleCount + 1;
    }
    return puzzles.count;
}

-(RebusPuzzle*)getNextPuzzle {
//	return [puzzles objectAtIndex:196];
    int puzzleIndex = [DataUtil getIntWithKey:kCurrentPuzzleIndexKey withDefault:-1] + 1;
    if(puzzleIndex >= [self getMaxPuzzleCount]) {
        puzzleIndex = 0;
    }
    [DataUtil setInt:puzzleIndex withKey:kCurrentPuzzleIndexKey];
	return [puzzles objectAtIndex:puzzleIndex];
}

-(RebusPuzzle*)getPuzzleById:(int)i {
    for(RebusPuzzle* p in puzzles) {
		if(i == p.puzzleId) {
            return p;
        }
	}
	DebugLog(@"Unable to find puzzle with id: %d", i);
    return nil;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    DebugLog(@"applicationWillResignActive");
    //  TODO pause game here
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DebugLog(@"applicationDidEnterBackground");
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DebugLog(@"applicationWillEnterForeground");
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //[[self facebook] extendAccessTokenIfNeeded];
    DebugLog(@"applicationDidBecomeActive");
    //[navigationController.topViewController.view setHidden:NO];
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    DebugLog(@"applicationWillTerminate");
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

-(void)tweet:(NSString*)s attachImage:(UIImage*)i {
    NSString* url = [RebusServer getWebPuzzleUrlFromPuzzle:rebusPlayState.puzzle];
    [TwitterUtil showTweetController:navigationController.topViewController initialText:s attachImage:i url:url];
}

//  IAP http://developer.apple.com/library/mac/#documentation/NetworkingInternet/Conceptual/StoreKitGuide/AddingaStoretoYourApplication/AddingaStoretoYourApplication.html#//apple_ref/doc/uid/TP40008267-CH101-SW1

-(void)upgrade {
    if(loadingView == nil) {
        loadingView = [[LoadingView alloc] initWithFrame:navigationController.topViewController.view.frame];
        [navigationController.topViewController.view addSubview:loadingView];
    }
    [loadingView showWithMessage:@"contacting.app.store"];
	if([DeviceUtil isSimulator]/* && ![SKPaymentQueue canMakePayments]*/) {
        runBlockAfterDelay(1.5, ^{
            [self completeTransaction:nil];
        });
	} else {
		payment = [SKPayment paymentWithProductIdentifier:kFreeAppUpgradeKey];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
}

-(void)paymentQueue:(SKPaymentQueue*)queue updatedTransactions:(NSArray*)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

-(void)paymentQueue:(SKPaymentQueue*)queue restoreCompletedTransactionsFailedWithError:(NSError*)error {
    [self hideLoadingView];
    [AlertUtil showOKAlert:[error description]];
}

-(void)completeTransaction:(SKPaymentTransaction*)transaction {
    if(transaction == nil) {
        [DataUtil setString:kUserPayedForAppKey withKey:kUserPayedForAppKey];
    } else {
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
        DebugLog(@"completeTransaction product id: %@ transaction id: %@", transaction.payment.productIdentifier, transaction.transactionIdentifier);
        [DataUtil setString:transaction.transactionIdentifier withKey:kUserPayedForAppKey];
    }
    [self hideLoadingView];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowSceneEvent object:kMenuScene];
    [rebusPlayState clear];
    [DataUtil setInt:kFreePuzzleCount withKey:kCurrentPuzzleIndexKey];
    runBlockAfterDelay(10.0, ^{
        [[GameCenter singleton] authenticateLocalPlayer];
    });
    [UsageTracking trackEvent:@"in.app.purchase" action:nil label:nil value:scores.count];
}

//  one time occurrence, after paying and Game Center authentication, submit existing scores to Game Center
-(void)authenticatedGameCenterPlayer:(NSNotification*)notification {
    if([RebusGlobals didUserJustUpdate:@"xxxauthenticatedGameCenterPlayerxxx"]) {
        int numSubmitted = [self submitScoresToGameCenter];
        DebugLog(@"After IAP, %d leaderboard categories were submitted to Game Center.", numSubmitted);
        id<Achievements> achievements = [[NSClassFromString([Products productKeyToClassName:@"Achievements"]) alloc] init];
        [achievements updateAchievementIfNecessary];
    }
}

-(void)restoreTransaction:(SKPaymentTransaction*)transaction {
	[self completeTransaction:transaction];
}

-(void)failedTransaction:(SKPaymentTransaction*)transaction {
    if (transaction.error.code != SKErrorPaymentCancelled) {
        DebugLog(@"%@", [transaction.error description]);
        [AlertUtil showOKAlert:[transaction.error description]];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [self hideLoadingView];
}

-(void)hideLoadingView {
    if(loadingView != nil) {
        [loadingView hide];
        loadingView = nil;
    }
}

@end
