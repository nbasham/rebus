#import <Foundation/Foundation.h>

#define kPadToPhoneXRatio 0.46875
#define kPadToPhoneYRatio 0.41666666666667
#define kFreePuzzleCount 20
#define kMaxPuzzleLength 25
#define kMaxScore 100
#define kMinScore 10
#define kAcheivementLevels 12
#define kScoreHintPenalty 25
#define kScoreIncorrectPenalty 5
#define kUserPayedForAppKey     @"kUserPayedForAppKey"
#define kCurrentPuzzleIndexKey  @"kCurrentPuzzleIndexKey"
#define kFreeAppUpgradeKey      @"rebus.app.updgrade"

/*          SCENES          */
#define kPlayScene @"play"
#define kSettingsScene @"settings"
#define kSolvedScene @"solved"
#define kMenuScene @"menu"
#define kPuzzleScene @"puzzles"
#define kGamesScene @"games"
#define kHelpScene @"help"
#define kScoresScene @"scores"
#define kAboutScene @"about"

/*          CONTROL PANELS          */
#define kKeyboardControlPanel @"keyboard"
#define kSolvedControlPanel @"solved"
#define kMenuControlPanel @"menu"

/*          STAGES          */
#define kPlayStage @"play"
#define kSettingsStage @"settings"
#define kMeunStage @"menu"
#define kPuzzleStage @"puzzle"
#define kGamesStage @"games"
#define kHelpStage @"help"
#define kScoresStage @"scores"
#define kAboutStage @"about"

/*          EVENTS          */
#define kAppWillResignAppEvent @"kAppWillResignAppEvent"

#define kShowSceneEvent @"show.scene.event"
#define kShowAlertEvent @"show.alert.event"
#define kHideAlertEvent @"hide.alert.event"
#define kShowSignEvent @"show.sign.event"
#define kHideSignEvent @"hide.sign.event"
#define kExitGameRequest @"exit.game.request.event"
#define kPauseGameRequest @"pause.game.request.event"
#define kOpenCoverEvent @"open.cover.event"

#define kIncorrectAnswerEvent @"kIncorrectAnswerEvent"
#define kCorrectAnswerEvent @"kCorrectAnswerEvent"
#define kUpdateSelectionEvent @"kUpdateSelectionEvent"
#define kAnswerTouchEvent @"kAnswerTouchEvent"
#define kShowHintAtIndexPlayEvent @"kShowHintAtIndexPlayEvent"
#define kHintShownEvent @"kHintShownEvent"
#define kPuzzleSolvedEvent @"kPuzzleSolvedEvent"
#define kSignHiddenEvent @"kSignHiddenEvent"

@interface RebusGlobals : NSObject

+(BOOL)isUnpaid;
+(BOOL)isFreeApp;
+(NSString*)getProductName;
+(int)getControlPanelHeight;
+(int)getStageHeight;
+(BOOL)didUserJustUpdate:(NSString*)tokenKey;

@end
