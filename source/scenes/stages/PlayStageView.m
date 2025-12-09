#import "PlayStageView.h"
#import "TimedMessageView.h"
#import "ThreadUtil.h"
#import "SceneViewController.h"

@interface PlayStageView()
typedef enum { UNDEFINED_LABEL_STATE, VISIBLE_LABEL_STATE, HIDDEN_LABEL_STATE } LABEL_STATE;
-(void)handleTap:(UITapGestureRecognizer*)tapEvent;
-(void)showHint:(int)hintIndex;
-(NSString*)getSignId:(int)scoreCount;
-(void)handleSignHidden;
//+(UIImage*)whiteToTransparent:(NSString*)imageName;
@end

@implementation PlayStageView

-(id)initWithStageName:(NSString*)name {
    self = [super initWithStageName:name];
    if (self) {
        [super addBackground];
        puzzleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 489)];
        [layoutManager addView:puzzleImageView withKey:@"image.view" position:NONE];

        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapRecognizer];
        
        labelStates = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)exitStage {
    [super exitStage];
    [layoutManager clear];
    layoutManager = nil;
    puzzleImageView = nil;
    [labelStates removeAllObjects];
    labelStates = nil;
    SceneViewController* vc = (SceneViewController*)appDelegate.navigationController.topViewController;
    [vc.view removeGestureRecognizer:tapRecognizer];
    tapRecognizer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSignHiddenEvent object:nil];
}

-(void)exitScene {
    [super exitScene];
}

-(void)enterStage {
    [super enterStage];
    RebusPlayState* rebusPlayState = appDelegate.rebusPlayState;
    [puzzleImageView setImage:[rebusPlayState.puzzle getImage]];

    UIColor* shadowColor = [ResourceManager getStyleColor:@"color" withAttribute:nil module:@"stage.play.shadow" isPortrait:NO];
    puzzleImageView.layer.shadowColor = shadowColor.CGColor;
    int offsetHorizontal = [[ResourceManager getStyle:@"offset.horizontal" module:@"stage.play.shadow" isPortrait:NO] intValue];
    int offsetVertical = [[ResourceManager getStyle:@"offset.vertical" module:@"stage.play.shadow" isPortrait:NO] intValue];
    puzzleImageView.layer.shadowOffset = CGSizeMake(offsetHorizontal, offsetVertical);
    NSString* opacityStr = [ResourceManager getStyle:@"opacity" module:@"stage.play.shadow" isPortrait:NO];
    float opacity = [opacityStr floatValue];
    puzzleImageView.layer.shadowOpacity = opacity;
    NSString* radiusStr = [ResourceManager getStyle:@"radius" module:@"stage.play.shadow" isPortrait:NO];
    float radius = [radiusStr floatValue];
    puzzleImageView.layer.shadowRadius = radius;

    puzzleImageView.clipsToBounds = NO;
    puzzleImageView.frame = CGRectMake(self.center.x, self.center.y, 1, 1);
    
    [labelStates removeAllObjects];
    int i = 0;
    for (NSValue* hotspotValue in [rebusPlayState.puzzle getHotspots]) {
        if([rebusPlayState wasHintUsed:i]) {
            [labelStates addObject:[NSNumber numberWithInt:VISIBLE_LABEL_STATE]];
            [self showHint:i];
        } else {
            [labelStates addObject:[NSNumber numberWithInt:UNDEFINED_LABEL_STATE]];
        }
        i++;
    }
//        Display when signs are shown.
//    for (int i = 0; i < 50; i++) {
//        NSString* signId = [self getSignId:i];
//        if(signId == nil) {
//            signId = @"";
//        }
//        RebusPuzzle* p = [appDelegate.puzzles objectAtIndex:i];
//        NSLog(@"\t%2d\t%2d\t%@", i, p.puzzleId, signId);
//    }
}

-(void)enterScene {
    [[NSNotificationCenter defaultCenter] postNotificationName:kOpenCoverEvent object:nil];
    runBlockAfterDelay(0.25, ^{
        [UIView animateWithDuration:1.5 delay:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
            BOOL scaleToPadAspectRatio = NO;
            if(scaleToPadAspectRatio) {
                int x = [DeviceUtil isPad] ? 0 : 94;
                int y = [DeviceUtil isPad] ? 0 : 30;
                int w = [DeviceUtil isPad] ? 1024 : 302;
                int h = [DeviceUtil isPad] ? 489 : 144;
                puzzleImageView.frame = CGRectMake(x, y, w, h);
            } else {
                puzzleImageView.frame = CGRectMake(0, 0, [DeviceUtil deviceWidth], [RebusGlobals getStageHeight]);
            }
        }completion:^(BOOL finished) {
//            if (![DataUtil getBoolWithKey:@"inSolvedScene" withDefault:NO]) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:kShowSignEvent object:@"complete"];
//                return;
//            }
            NSString* signId = [self getSignId:[appDelegate.scores count]];
            if(signId == nil) {
                RebusPlayState* rebusPlayState = appDelegate.rebusPlayState;
                [rebusPlayState startTimer];
            } else {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSignHidden) name:kSignHiddenEvent object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kShowSignEvent object:signId];
            }
        }];
    });
}

-(void)handleSignHidden {
    BOOL isPlayScene = ![DataUtil getBoolWithKey:@"inSolvedScene" withDefault:NO];
    if(isPlayScene) {
        RebusPlayState* rebusPlayState = appDelegate.rebusPlayState;
        [rebusPlayState startTimer];
    }
}

/*
 0	lesson.1
 1	
 2	
 3	lesson.2
 4	
 5	
 6	lesson.3
 7	
 8	
 9	
 10	
 11	
 12	
 13	
 14	
 15	
 16	
 17	
 18	
 19	complete
 20	
 21	
 22	
 23	
 24	
 25	upgrade
 26	
 27	
 28	
 29	
 30	upgrade
 31	
 32	
 33	
 34	
 35	upgrade
 */
-(NSString*)getSignId:(int)scoreCount {
    NSString* signId = nil;

    BOOL isFirstTime = [DataUtil isKeyUndefinedThenDefine:@"lesson.1"];
    BOOL isPlayScene = ![DataUtil getBoolWithKey:@"inSolvedScene" withDefault:NO];
    BOOL showLesson2 = [DataUtil keyUndefined:@"lesson.2"];
    BOOL showLesson3 = [DataUtil keyUndefined:@"lesson.3"];
    BOOL showLastLitePuzzle = [DataUtil keyUndefined:@"lite.complete"];
    BOOL isUnpaid = [RebusGlobals isUnpaid];
    int puzzleId = appDelegate.rebusPlayState.puzzle.puzzleId;
    RebusPuzzle* p = [appDelegate.puzzles objectAtIndex:kFreePuzzleCount - 1];
    int lastFreePuzzleId = p.puzzleId;
    if(isFirstTime) {
        signId = @"lesson.1";
    } else if (lastFreePuzzleId == puzzleId && isPlayScene && isUnpaid && showLastLitePuzzle) {
        signId = @"complete";
        [DataUtil setString:@"lite.complete" withKey:@"lite.complete"];
    } else if (scoreCount == 3 && isPlayScene && showLesson2) {
        signId = @"lesson.2";
        [DataUtil setString:@"lesson.2" withKey:@"lesson.2"];
    } else if (scoreCount == 6 && isPlayScene && showLesson3) {
        signId = @"lesson.3";
        [DataUtil setString:@"lesson.3" withKey:@"lesson.3"];
//    } else if (scoreCount == 10 && isPlayScene && isUnpaid) {
//        signId = @"upgrade";
    } else if (scoreCount > 21 && scoreCount % 5 == 0 && isPlayScene && isUnpaid) {
        signId = @"upgrade";
    }

    return signId;
}

-(void)showHint:(int)hintIndex {
    UIImage* hintLabel = [ResourceManager getImage:@"hint.label" module:nil isPortrait:NO];
    UIImage* resizableHintLabel = [hintLabel stretchableImageWithLeftCapWidth:33 topCapHeight:16];
    UIImageView* hintLabelImage = [[UIImageView alloc] initWithImage:resizableHintLabel];
    RebusPlayState* rebusPlayState = appDelegate.rebusPlayState;
    NSString* text = [[rebusPlayState.puzzle getHints] objectAtIndex:hintIndex];
    UILabel* label = [ResourceManager getLabel:@"hint.label" module:@"stage.play" isPortrait:NO data:kNoData];
    [label setText:text];
    int labelHeight = [[ResourceManager getStyle:@"hint.label.height" module:@"stage.play" isPortrait:NO] intValue];
    CGRect hotspotRect = [[[rebusPlayState.puzzle getHotspots] objectAtIndex:hintIndex] CGRectValue];
    BOOL verticalCenter = [[ResourceManager getStyle:@"hint.label.position" module:@"stage.play" isPortrait:NO] intValue] == 0;
    int y = hotspotRect.origin.y + (hotspotRect.size.height - labelHeight)/2;
    if(!verticalCenter) {
        y = hotspotRect.origin.y + hotspotRect.size.height - labelHeight;
    }
    int labelOffset = [DeviceUtil isPad] ? 4 : 3;
    CGRect containerRect = CGRectMake(hotspotRect.origin.x, y, hotspotRect.size.width, labelHeight + labelOffset);
    label.frame = CGRectMake(0, 0, hotspotRect.size.width, labelHeight);
    hintLabelImage.frame = label.frame;
    label.frameY += labelOffset;
    label.frame = CGRectInset(label.frame, 17, 0);
    UIView* labelContainer = [[UIView alloc] initWithFrame:containerRect];
    [labelContainer addSubview:hintLabelImage];
    [labelContainer addSubview:label];
    [self addSubview:labelContainer];
    labelContainer.alpha = 0;
    labelContainer.tag = 3000 + hintIndex;
    [UIView animateWithDuration:0.75 animations:^{
        labelContainer.alpha = 1.0;
    }];
//    DebugLog(@"%@ layout x: %2.0f y: %2.0f w: %2.0f h: %2.0f", @"hint", label.frame.origin.x, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
}
                       
-(void)handleTap:(UITapGestureRecognizer*)tapEvent {
    CGPoint p = [tapEvent locationInView:self];
    //[GeometryUtil logPoint:p];
    int hintIndex = -1;
    BOOL hotspotWasTouched = NO;
    RebusPlayState* rebusPlayState = appDelegate.rebusPlayState;
    for (NSValue* hotspotValue in [rebusPlayState.puzzle getHotspots]) {
        hintIndex++;
        //[GeometryUtil logRect:[hotspotValue CGRectValue] withMessage:@""];
        if(CGRectContainsPoint([hotspotValue CGRectValue], p)) {
            hotspotWasTouched = YES;
            break;
        }
    }
    if(!hotspotWasTouched) {
        return;
    }
    LABEL_STATE state = [[labelStates objectAtIndex:hintIndex] intValue];
    switch (state) {
        case VISIBLE_LABEL_STATE: {
            [SimpleSoundManager play:@"hint-hide"];
            UIView* label = [self viewWithTag:3000 + hintIndex];
            [UIView animateWithDuration:0.75 animations:^{
                label.alpha = 0;
            }];
            [labelStates replaceObjectAtIndex:hintIndex withObject:[NSNumber numberWithInt:HIDDEN_LABEL_STATE]];
            break;
        }
        case HIDDEN_LABEL_STATE: {
            UILabel* label = (UILabel*)[self viewWithTag:3000 + hintIndex];
            [SimpleSoundManager play:@"hint"];
            [UIView animateWithDuration:0.75 animations:^{
                label.alpha = 1.0;
            }];
            [labelStates replaceObjectAtIndex:hintIndex withObject:[NSNumber numberWithInt:VISIBLE_LABEL_STATE]];
            break;
        }
        case UNDEFINED_LABEL_STATE:
        default: {
            [SimpleSoundManager play:@"hint"];
            [labelStates replaceObjectAtIndex:hintIndex withObject:[NSNumber numberWithInt:VISIBLE_LABEL_STATE]];
            [rebusPlayState useHint:hintIndex];
            [self showHint:hintIndex];
            break;
        }
    }
}

//+(UIImage*)whiteToTransparent:(NSString*)imageName {
//    UIImage * image = [UIImage imageNamed:imageName];
//    const float colorMasking[6] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
//    image = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(image.CGImage, colorMasking)];
//    return image;
//}

@end
