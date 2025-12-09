#import "ScoresStageView.h"
#import "ScoreDetailView.h"
#import "RebusScore.h"
#import "RebusAchievements.h"
#import "NumberView.h"
#import "GameCenter.h"

@interface ScoresStageView()
-(void)showAchievements;
-(void)showLeaderboards;
-(void)setLabelFontsOnView:(UIView*)parent;
@end

@implementation ScoresStageView

-(id)initWithStageName:(NSString*)name {
    self = [super initWithStageName:name];
    if (self) {
        NSString* nibName = [NSString stringWithFormat:@"ScoreDetailView.%@", [DeviceUtil isPad] ? @"pad" : @"phone"];
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];        
        ScoreDetailView* o = [nibViews objectAtIndex:0];
        [self setLabelFontsOnView:o];
        [layoutManager addView:o withKey:@"details" position:NONE];
        int achievementIndex = [RebusAchievements getCurrentAchievementIndex];
        UIImage* badgeImage = [ResourceManager getImage:[NSString stringWithFormat:@"badge.%d", achievementIndex] module:nil isPortrait:NO];
        UIImageView* badgeImageView = [[UIImageView alloc] initWithImage:badgeImage];
        float scale = [[ResourceManager getStyle:@"achievement.scale" module:@"scores" isPortrait:NO] floatValue];
        badgeImageView.frameWidth = badgeImage.size.width * scale;
        badgeImageView.frameHeight = badgeImage.size.height * scale;
        [layoutManager addView:badgeImageView withKey:@"badge" position:XY];
        int count = appDelegate.scores.count;
        BOOL noGamesPlayed = count == 0;
        int total = [RebusScore getTotalScore];
        if(noGamesPlayed) {
            o.average.text = @"0";
            o.fastest.text = @"0";
            o.slowest.text = @"0";
            o.last.text = @"0";
            o.count.text = @"0";
        } else {
            int fastest = 0;
            int last = 0;
            int slowest = 101;
            int solvedCount = 0;
            for(RebusScore* score in appDelegate.scores) {
                int s = score.score;
                if(score.score == kSkippedScore) {
                    continue;
                }
                solvedCount++;
                if(s > fastest) {
                    fastest = s;
                }
                if(s < slowest) {
                    slowest = s;
                }
                last = score.score;
            }
            int average = 0;
            if(solvedCount != 0) {
                average = total / solvedCount;
            }
            if(slowest == 101) {
                slowest = 0;
            }
            o.average.text = [NSString stringWithFormat:@"%d", average];
            o.fastest.text = [NSString stringWithFormat:@"%d", fastest];
            o.count.text = [NSString stringWithFormat:@"%d", solvedCount];
            o.slowest.text = [NSString stringWithFormat:@"%d", slowest];
            o.last.text = [NSString stringWithFormat:@"%d", last];

        }
        NSMutableArray* redNumberImageArray = [NSMutableArray array];
        UIImage* numberImage;
        for (int i = 0; i < 10; i++) {
            numberImage = [ResourceManager getImage:[NSString stringWithFormat:@"red.%d", i] module:@"solved" isPortrait:NO];
            [redNumberImageArray addObject:numberImage];
        }
        numberImage = [ResourceManager getImage:@"red.comma" module:@"solved" isPortrait:NO];
        [redNumberImageArray addObject:numberImage];
        
        float totalNumberScale = [DeviceUtil isPad] ? 0.84 : 0.9;
        NumberView* totalScore = [[NumberView alloc] initWithImages:redNumberImageArray value:total format:NUMBER_PUNCTUATION scale:totalNumberScale];
        [layoutManager addView:totalScore withKey:@"badge.total" position:CENTER];

        [redNumberImageArray removeAllObjects];
        redNumberImageArray = nil;
        
        UIButton* b;
        
        b = [ResourceManager getImageButton:@"achievement.button" module:@"stage.scores" isPortrait:NO hasDownState:YES];
        [b addTarget:self action:@selector(showAchievements) forControlEvents:UIControlEventTouchUpInside];
        [layoutManager addView:b withKey:@"achievement.button" position:XY];
        
        b = [ResourceManager getImageButton:@"leaderboard.button" module:@"stage.scores" isPortrait:NO hasDownState:YES];
        [b addTarget:self action:@selector(showLeaderboards) forControlEvents:UIControlEventTouchUpInside];
        [layoutManager addView:b withKey:@"leaderboard.button" position:XY];

        if([DeviceUtil isPad]) {
            UIImage* currentAchievementImage = [ResourceManager getImage:@"current.achievement" module:@"stage.scores" isPortrait:NO];
            UIImageView* currentAchievementImageView = [[UIImageView alloc] initWithImage:currentAchievementImage];
            [layoutManager addView:currentAchievementImageView withKey:@"current.achievement" position:NONE];
            
            CGPoint p = [ResourceManager getStyleXY:@"current.achievement" module:@"stage.scores" isPortrait:NO];
            
            int achievementWidth = [[ResourceManager getStyle:@"current.achievement.width" module:@"stage.scores" isPortrait:NO] intValue];
            int achievementXOffset = (achievementIndex > 5) ? ((achievementIndex-6) * achievementWidth) : (achievementIndex * achievementWidth);
            if(achievementIndex == 5 || achievementIndex == 11) {
                achievementXOffset -= 2;
            }
            currentAchievementImageView.frameX = p.x + achievementXOffset;
            
            currentAchievementImageView.frameY = p.y;
            if(achievementIndex > 5) {
                int achievementHeight = [[ResourceManager getStyle:@"current.achievement.height" module:@"stage.scores" isPortrait:NO] intValue];
                currentAchievementImageView.frameY += achievementHeight;
            }
        }
    }
    return self;
}

-(void)setLabelFontsOnView:(UIView*)parent {
    NSArray* a = [parent subviews];
    for (UIView* v in a) {
        if([v isKindOfClass:[UILabel class]]) {
            UILabel* l = (UILabel*)v;
            UIFont* font = l.font;
            NSString* name = @"Copperplate";
            if([DeviceUtil isPhone] && ![DeviceUtil osVersionSupported:@"5.0"]) {
                name = [ResourceManager getStyle:@"font.not" withAttribute:@"found" module:nil isPortrait:NO];
            }
            l.font = [UIFont fontWithName:name size:font.pointSize];
        }
    }
}

-(void)showAchievements {
	[SimpleSoundManager playButton];
    id<GKAchievementViewControllerDelegate> vc = (id<GKAchievementViewControllerDelegate>)appDelegate.navigationController.topViewController;
    [[GameCenter singleton] showAchievements:vc];
}

-(void)showLeaderboards {
	[SimpleSoundManager playButton];
    id<GKLeaderboardViewControllerDelegate> vc = (id<GKLeaderboardViewControllerDelegate>)appDelegate.navigationController.topViewController;
    [[GameCenter singleton] showScores:vc];
}

-(void)exitStage {
    [super exitScene];
    //DebugLog(@"exitStage:%@", stageName);
}

@end
