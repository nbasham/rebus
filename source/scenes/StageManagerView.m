#import "StageManagerView.h"
#import "AppDelegate.h"
#import "ClassUtil.h"
#import "ThreadUtil.h"
#import "StringUtil.h"
#import "LessonStageSignView.h"

@interface StageManagerView()
-(void)doStageAnimation:(NSString*)name;
-(void)closeCoverThenDoStageAnimation:(NSString*)name;
-(BOOL)isSignScene:(NSString*)name;
-(void)doSignAnimation:(NSString*)name;
-(void)closeCoverThenDoSignAnimation:(NSString*)name;
-(void)createStageViewFromName:(NSString*)name;
-(void)handleShowSignEvent:(NSNotification*)notification;
-(void)handleHideSignEvent:(NSNotification*)notification;
-(void)handleOpenCoverEvent:(NSNotification*)notification;
@end

@implementation StageManagerView

#define kCoverOpensUpAndDown NO
#define kDuration 1.0

@synthesize stageView;
@synthesize previousStageView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        layoutManager = [[LayoutManager alloc] initWithParent:self moduleName:@"stage.manager"];
        self.backgroundColor = [UIColor brownColor];
        [layoutManager createBackgroundImageViewWithKey:@"background" parent:self];
        if(kCoverOpensUpAndDown) {
            coverImageView = [layoutManager createImageViewWithKey:@"cover" position:NONE];
        }  else {
            leftCoverImageView = [layoutManager createImageViewWithKey:@"cover.left" position:NONE];
            rightCoverImageView = [layoutManager createImageViewWithKey:@"cover.right" position:NONE];
            leftCoverImageView.frameX = 0;
            rightCoverImageView.frameRight = self.frameRight;
        }

        frameImageView = [layoutManager createImageViewWithKey:@"frame" position:NONE];
        previousStageView = nil;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShowSignEvent:) name:kShowSignEvent object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHideSignEvent:) name:kHideSignEvent object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenCoverEvent:) name:kOpenCoverEvent object:nil];
    }
    return self;
}

-(void)handleOpenCoverEvent:(NSNotification*)notification {
    [UIView animateWithDuration:kDuration animations:^{
        [self openCover];
    } completion:^(BOOL finished){
    }];
}

-(void)handleShowSignEvent:(NSNotification*)notification {
//    if(stageSignView != nil) {
//        [stageSignView cleanUp];
//        stageSignView = nil;
//    }
    NSString* key = notification.object;
    BOOL isLesson = [StringUtil contains:@"lesson" inString:key];
    Class c;
    if(isLesson) {
        c = [ClassUtil getMostSpecificClassOfType:@"StageSignView" forModule:@"lesson"];
    } else {
        c = [ClassUtil getMostSpecificClassOfType:@"StageSignView" forModule:key];
    }
    stageSignView = (StageSignView*)[[c alloc] init];
    stageSignView.name = key;
    if(isLesson) {
        NSArray* a = [key componentsSeparatedByString:@"."];
        int lessonIndex = [[a lastObject] intValue];
        ((LessonStageSignView*)stageSignView).lessonIndex = lessonIndex;
    }
    [layoutManager insertView:stageSignView aboveViewWithKey:@"cover.right"];
    [stageSignView show];
}

-(void)handleHideSignEvent:(NSNotification*)notification {
    [stageSignView hide];
    [layoutManager removeView:stageSignView];
    stageSignView = nil;
}

-(void)createStageViewFromName:(NSString*)name {
    if(![self isSignScene:name]) {
        previousStageView = stageView;
        NSString* capSceneName = [name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[name substringToIndex:1] capitalizedString]];
        NSString* stageClassName = [NSString stringWithFormat:@"%@StageView", capSceneName];
        Class stageClass = NSClassFromString(stageClassName);
        assert(stageClass != nil);
        [layoutManager removeView:previousStageView];
        stageView = [[stageClass alloc] initWithStageName:name];
        stageView.alpha = 0.0;
        [layoutManager insertView:stageView aboveViewWithKey:@"background"];
    }
}

-(void)doSignAnimation:(NSString*)name {
    BOOL isCoverOpen = [self isCoverOpen];
    if(isCoverOpen) {
        [self closeCoverThenDoSignAnimation:name];
    } else {
        float delay = 0;
        if(stageSignVisible) {
            delay = 0.75;
        }
        runBlockAfterDelay(delay, ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kShowSignEvent object:name];
        });
    }
    stageSignVisible = YES;
}

-(void)closeCoverThenDoSignAnimation:(NSString*)name {
    [UIView animateWithDuration:kDuration animations:^{
        previousStageView.alpha = 0;
        [self closeCover];
    } completion:^(BOOL finished){
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowSignEvent object:name];
    }];
}

-(BOOL)isSignScene:(NSString*)name {
    BOOL isSignScene = [@"about" isEqualToString:name] ||
        [@"menu" isEqualToString:name] ||
        [@"settings" isEqualToString:name];
    return isSignScene;
}

-(void)setStage:(NSString*)name {
    static BOOL firstTime = YES;
    if(stageSignVisible) {
        [self handleHideSignEvent:nil];
    }
    [self createStageViewFromName:name];
    if (firstTime) {
        //[self closeCover];
        [self doSignAnimation:name];
        [[NSNotificationCenter defaultCenter] postNotificationName:kStageTransitionCompletedEvent object:nil];
    } else {
        BOOL isCoverOpen = [self isCoverOpen];
        if([self isSignScene:name]) {
            [self doSignAnimation:name];
        } else {
            stageView.alpha = 0;
            [UIView animateWithDuration:kDuration animations:^{
                previousStageView.alpha = 0;
            } completion:^(BOOL finished){
            }];
            stageSignVisible = NO;
            if(isCoverOpen) {
                [self closeCoverThenDoStageAnimation:name];
            } else {
                [self doStageAnimation:name];
            }
        }
    }
    firstTime = NO;
}

-(void)closeCoverThenDoStageAnimation:(NSString*)name {
    [UIView animateWithDuration:kDuration animations:^{
        //previousStageView.alpha = 0;
        [self closeCover];
    } completion:^(BOOL finished){
        [self doStageAnimation:name];
    }];
}

-(void)doStageAnimation:(NSString*)name {
    __block BOOL removeOnComplete = NO;
    stageView.alpha = 0;
    [UIView animateWithDuration:kDuration animations:^{
        if([@"menu" isEqualToString:name]) {
            [self closeCover];
            removeOnComplete = YES;
        } else if([@"play" isEqualToString:name]) {
            AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate createGameState];
            [previousStageView removeFromSuperview];
            stageView.alpha = 1;
        } else {
            stageView.alpha = 1;
            [self openCover];
            [previousStageView removeFromSuperview];
        }
        [stageView enterStage]; // this must come after [appDelegate createGameState]
    } completion:^(BOOL finished){
        if(removeOnComplete) {
            [previousStageView removeFromSuperview];
        }
        [layoutManager removeView:previousStageView];
        [[NSNotificationCenter defaultCenter] postNotificationName:kStageTransitionCompletedEvent object:nil];
    }];
}

-(BOOL)isCoverOpen {
    BOOL isCoverOpen;
    if(kCoverOpensUpAndDown) {
        isCoverOpen = coverImageView.frameBottom == 0;
    }  else {
        isCoverOpen = leftCoverImageView.frameRight == 0;
    }
    return isCoverOpen;
}

-(void)openCover {
    [SimpleSoundManager play:@"curtain"];
    if(kCoverOpensUpAndDown) {
        coverImageView.frameBottom = 0;
    }  else {
        leftCoverImageView.frameRight = 0;
        rightCoverImageView.frameX = self.frameRight;
    }
}

-(void)closeCover {
    [SimpleSoundManager play:@"curtain"];
    if(kCoverOpensUpAndDown) {
        coverImageView.frame = self.frame;
    }  else {
        leftCoverImageView.frameX = 0;
        rightCoverImageView.frameRight = self.frameRight;
    }
}

@end
