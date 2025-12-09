#import "SolvedControlPanelView.h"
#import "AlertUtil.h"
#import "RebusScore.h"
#import "RebusAchievements.h"
#import "NumberView.h"
#import "PrintUtil.h"
#import "SceneViewController.h"
#import "UsageTracking.h"
#import "RebusGlobals.h"

@interface SolvedControlPanelView()
-(void)handleEmailTouch:(UIButton*)button;
-(void)handlePrintTouch:(UIButton*)button;
-(void)handleTwitterTouch:(UIButton*)button;
-(void)handleFacebookTouch:(UIButton*)button;
-(void)handleNextGameTouch:(UIButton*)button;
-(void)handleMainMenuTouch:(UIButton*)button;
-(void)upgradeButtonTouch;
-(void)trackShare:(NSString*)shareMethod;
@end

@implementation SolvedControlPanelView

-(id)initWithControlPanelName:(NSString*)name {
    self = [super initWithControlPanelName:name];
    if (self) {
        [self addBackground];
        UIImage* goodJobImage = [ResourceManager getImage:@"zero.penalty" module:@"solved" isPortrait:NO];
        
        UIImage* numberImage;
        NSMutableArray* timeNumberImageArray = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            numberImage = [ResourceManager getImage:[NSString stringWithFormat:@"%d", i] module:@"solved.time" isPortrait:NO];
            [timeNumberImageArray addObject:numberImage];
        }
        numberImage = [ResourceManager getImage:@"time.colon" module:@"solved" isPortrait:NO];
        [timeNumberImageArray addObject:numberImage];
        
        NSMutableArray* redNumberImageArray = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            numberImage = [ResourceManager getImage:[NSString stringWithFormat:@"red.%d", i] module:@"solved" isPortrait:NO];
            [redNumberImageArray addObject:numberImage];
        }
        numberImage = [ResourceManager getImage:@"red.comma" module:@"solved" isPortrait:NO];
        [redNumberImageArray addObject:numberImage];
        
        NSMutableArray* blackNumberImageArray = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            numberImage = [ResourceManager getImage:[NSString stringWithFormat:@"black.%d", i] module:@"solved" isPortrait:NO];
            [blackNumberImageArray addObject:numberImage];
        }
        
        UIButton* b;
        
        b = [ResourceManager getImageButton:@"main.menu" module:@"solved" isPortrait:NO hasDownState:YES];
        [b addTarget:self action:@selector(handleMainMenuTouch:) forControlEvents:UIControlEventTouchUpInside];
        [layoutManager addView:b withKey:@"main.menu" position:XY];
        
        b = [ResourceManager getImageButton:@"next.game" module:@"solved" isPortrait:NO hasDownState:YES];
        [b addTarget:self action:@selector(handleNextGameTouch:) forControlEvents:UIControlEventTouchUpInside];
        [layoutManager addView:b withKey:@"next.game" position:XY];
        
        b = [ResourceManager getImageButton:@"email" module:@"solved" isPortrait:NO hasDownState:YES];
        [b addTarget:self action:@selector(handleEmailTouch:) forControlEvents:UIControlEventTouchUpInside];
        [layoutManager addView:b withKey:@"email" position:XY];
        
        b = [ResourceManager getImageButton:@"print" module:@"solved" isPortrait:NO hasDownState:YES];
        [b addTarget:self action:@selector(handlePrintTouch:) forControlEvents:UIControlEventTouchUpInside];
        [layoutManager addView:b withKey:@"print" position:XY];
        
        b = [ResourceManager getImageButton:@"twitter" module:@"solved" isPortrait:NO hasDownState:YES];
        [b addTarget:self action:@selector(handleTwitterTouch:) forControlEvents:UIControlEventTouchUpInside];
        [layoutManager addView:b withKey:@"twitter" position:XY];
        
        b = [ResourceManager getImageButton:@"facebook" module:@"solved" isPortrait:NO hasDownState:YES];
        [b addTarget:self action:@selector(handleFacebookTouch:) forControlEvents:UIControlEventTouchUpInside];
        [layoutManager addView:b withKey:@"facebook" position:XY];
        
        int achievementIndex = [RebusAchievements getCurrentAchievementIndex];
        UIImage* i = [ResourceManager getImage:[NSString stringWithFormat:@"badge.%d", achievementIndex] module:nil isPortrait:NO];
        //UIImage* i = [ResourceManager getImage:[NSString stringWithFormat:@"solved.achievement.%d", achievementIndex] module:nil isPortrait:NO];
        assert(i != nil);
        UIImageView* v = [[UIImageView alloc] initWithImage:i];
        float scale = [[ResourceManager getStyle:@"achievement.scale" module:@"solved" isPortrait:NO] floatValue];
        v.frameWidth = i.size.width * scale;
        v.frameHeight = i.size.height * scale;
        [layoutManager addView:v withKey:@"achievement" position:XY];

        float achievementAlpha = [[ResourceManager getStyle:@"achievement.score.alpha" module:@"solved" isPortrait:NO] floatValue];
        int total = [RebusScore getTotalScore];
        NumberView* achievementScore = [[NumberView alloc] initWithImages:redNumberImageArray value:total format:NUMBER_PUNCTUATION];
        achievementScore.center = self.center;
        achievementScore.frameY = [[ResourceManager getStyle:@"achievement.score.y" module:@"solved" isPortrait:NO] intValue];
        achievementScore.alpha = achievementAlpha;
        [self addSubview:achievementScore];

        RebusScore* score = [[appDelegate scores] lastObject];

        int col1X = [[ResourceManager getStyle:@"score.column1.x" module:@"solved" isPortrait:NO] intValue];
        int col2X = [[ResourceManager getStyle:@"score.column2.x" module:@"solved" isPortrait:NO] intValue];
        int row1Y = [[ResourceManager getStyle:@"score.row1.y" module:@"solved" isPortrait:NO] intValue];
        int row2Y = [[ResourceManager getStyle:@"score.row2.y" module:@"solved" isPortrait:NO] intValue];
        int totalY = [[ResourceManager getStyle:@"total.y" module:@"solved" isPortrait:NO] intValue];
        float scoreAlpha = [[ResourceManager getStyle:@"score.alpha" module:@"solved" isPortrait:NO] floatValue];
        float achievementScoreAlpha = [[ResourceManager getStyle:@"achievement.score.alpha" module:@"solved" isPortrait:NO] floatValue];

        NumberView* totalScore = [[NumberView alloc] initWithImages:redNumberImageArray value:score.score format:NUMBER_PUNCTUATION];
        totalScore.frameRight = col2X;
        totalScore.frameY = totalY;
        totalScore.alpha = achievementScoreAlpha;
        [self addSubview:totalScore];
        
        NumberView* hintsUsed = [[NumberView alloc] initWithImages:blackNumberImageArray value:score.hints format:NUMBER_PUNCTUATION];
        hintsUsed.frameRight = col1X;
        hintsUsed.frameY = row1Y;
        hintsUsed.alpha = scoreAlpha;
        [self addSubview:hintsUsed];
        
        NumberView* incorrectUsed = [[NumberView alloc] initWithImages:blackNumberImageArray value:score.numberMissed format:NUMBER_PUNCTUATION];
        incorrectUsed.frameRight = col1X;
        incorrectUsed.frameY = row2Y;
        incorrectUsed.alpha = scoreAlpha;
        [self addSubview:incorrectUsed];
        
        if(score.hints == 0) {
            UIImageView* v = [[UIImageView alloc] initWithImage:goodJobImage];
            v.frameRight = col2X;
            v.frameY = row1Y;
            [layoutManager addView:v withKey:@"achievement.hints" position:NONE]; 
        } else {
            NumberView* hintsPenalty = [[NumberView alloc] initWithImages:blackNumberImageArray value:score.hints*kScoreHintPenalty format:NUMBER_PUNCTUATION];
            hintsPenalty.frameRight = col2X;
            hintsPenalty.frameY = row1Y;
            hintsPenalty.alpha = scoreAlpha;
            [self addSubview:hintsPenalty];
        }
        
        if(score.numberMissed == 0) {
            UIImageView* v = [[UIImageView alloc] initWithImage:goodJobImage];
            v.frameRight = col2X;
            v.frameY = row2Y;
            [layoutManager addView:v withKey:@"achievement.incorrect" position:NONE]; 
        } else {
            NumberView* incorrectPenalty = [[NumberView alloc] initWithImages:blackNumberImageArray value:score.numberMissed*kScoreIncorrectPenalty format:NUMBER_PUNCTUATION];
            incorrectPenalty.frameRight = col2X;
            incorrectPenalty.frameY = row2Y;
            incorrectPenalty.alpha = scoreAlpha;
            [self addSubview:incorrectPenalty];
        }
        
        NumberView* time = [[NumberView alloc] initWithImages:timeNumberImageArray value:score.time format:TIME_PUNCTUATION];
        time.alpha = scoreAlpha;
        [layoutManager addView:time withKey:@"time" position:XY];
        
        UILabel* solutionLabel = [ResourceManager getLabel:@"solution.label" module:@"solved" isPortrait:NO data:kNoData];
        solutionLabel.text = appDelegate.rebusPlayState.puzzle.solution;
        if([DeviceUtil isPhone] && ![DeviceUtil osVersionSupported:@"5.0"]) {
            solutionLabel.text = [appDelegate.rebusPlayState.puzzle.solution uppercaseString];
        }
        solutionLabel.frame = [ResourceManager getStyleRect:@"solution.label" module:@"solved" isPortrait:NO];
        [self addSubview:solutionLabel];
        
        if([RebusGlobals isUnpaid]) {
            UIButton* b = [ResourceManager getImageButton:nil module:nil isPortrait:NO hasDownState:YES];
            [b addTarget:self action:@selector(upgradeButtonTouch) forControlEvents:UIControlEventTouchUpInside];
            [layoutManager addView:b withKey:@"solved.update.button" position:RECT];
//            b.backgroundColor = [UIColor greenColor];
//            b.alpha = 0.5;
        } else {
            ratingView = [[RatingView alloc] init];
            [layoutManager addView:ratingView withKey:@"rating" position:XY];
        }
        
        [redNumberImageArray removeAllObjects];
        redNumberImageArray = nil;
        [timeNumberImageArray removeAllObjects];
        timeNumberImageArray = nil;
        [blackNumberImageArray removeAllObjects];
        blackNumberImageArray = nil;
    }
    return self;
}

-(UIImageView*)addBackground {
    NSString* key = [NSString stringWithFormat:@"%@background", [RebusGlobals isUnpaid] ? @"upgrade." : @""];
    UIImageView* backgroundImageView = [layoutManager createBackgroundImageViewWithKey:key parent:self];
    self.frame = backgroundImageView.frame;
    backgroundImageView.userInteractionEnabled = NO;
    return backgroundImageView;
}

-(void)enterScene {
    if([Settings getSoundOn]) {
        clapping = [[Music alloc] initWithFileName:@"clapping" ofType:@"mp3"];
        [clapping playOnce];
    }
//    [SimpleSoundManager play:@"clapping"];
//    ratingValue = 0;
}

-(void)exitScene {
    [super exitScene];
    appStoreRatingRequest = nil;
    [clapping stop];
    clapping = nil;
    if(![RebusGlobals isUnpaid]) {
        if(ratingView.value > 0.49) {
            NSString* formattedPuzzleIdAndName = [NSString stringWithFormat:@"%06d %@", appDelegate.rebusPlayState.puzzleId, [appDelegate.rebusPlayState.puzzle solution]];
            NSString* formattedRatingValueString = [ratingView getStringValue];
            [UsageTracking trackEvent:@"rating" action:formattedPuzzleIdAndName label:formattedRatingValueString value:ratingView.value];
        }
    }
}

-(void)enterControlPanel {
    appStoreRatingRequest = [[AppStoreRatingRequest alloc] init];
    [appStoreRatingRequest showIfAppropriate];
}

-(void)trackShare:(NSString*)shareMethod {
    NSString* formattedPuzzleIdAndName = [NSString stringWithFormat:@"%06d %@", appDelegate.rebusPlayState.puzzle.puzzleId, [appDelegate.rebusPlayState.puzzle solution]];
    [UsageTracking trackEvent:@"share" action:shareMethod label:formattedPuzzleIdAndName value:-1];
}

-(void)handleEmailTouch:(UIButton*)button {
	[SimpleSoundManager playButton];
    UIImage* puzzleImage = [appDelegate.rebusPlayState.puzzle getImage];
    NSData* imageData = [NSData dataWithData:UIImagePNGRepresentation(puzzleImage)];
    SceneViewController* vc = (SceneViewController*)appDelegate.navigationController.topViewController;
    NSString* subject = [ResourceManager getLocalizedString:@"email.subject" module:@"solved" isPortrait:NO];
    NSString* body = [ResourceManager getLocalizedString:@"email.body" module:@"solved" isPortrait:NO];
    [vc sendEmailTo:nil withSubject:subject withBody:body withImage:imageData];
    [self trackShare:@"email"];
}

-(void)handlePrintTouch:(UIButton*)button {
	[SimpleSoundManager playButton];
    UIImage* puzzleImage = [appDelegate.rebusPlayState.puzzle getImage];
    UIView* v = [layoutManager getViewByName:@"print"];
    [PrintUtil printImage:puzzleImage fromRect:v.frame inView:self];
    [self trackShare:@"print"];
}

-(void)handleTwitterTouch:(UIButton*)button {
	[SimpleSoundManager playButton];
    NSString* message = [NSString stringWithFormat:@"Here's a fun puzzle from %@!", [RebusGlobals getProductName]];
    [appDelegate tweet:message attachImage:[appDelegate.rebusPlayState.puzzle getImage]];
    [self trackShare:@"twitter"];
}

-(void)handleFacebookTouch:(UIButton*)button {
	[SimpleSoundManager playButton];
    [appDelegate logonAndPostToFacebook];
    [self trackShare:@"facebook"];
}

-(void)handleNextGameTouch:(UIButton*)button {
	[SimpleSoundManager playButton];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowSceneEvent object:kPlayScene];
    [UsageTracking trackEvent:@"touch" action:@"solved.next.game" label:nil value:-1];
}

-(void)handleMainMenuTouch:(UIButton*)button {
	[SimpleSoundManager playButton];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowSceneEvent object:kMenuScene];
    [UsageTracking trackEvent:@"touch" action:@"solved.main.menu" label:nil value:-1];
}

-(void)upgradeButtonTouch {
	[SimpleSoundManager playButton];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowSceneEvent object:kScoresScene];
    [UsageTracking trackEvent:@"touch" action:@"solved.upgrade" label:nil value:[appDelegate.scores count]];
}


@end
