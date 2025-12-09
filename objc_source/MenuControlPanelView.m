#import "MenuControlPanelView.h"
#import "RebusGlobals.h"

@interface MenuControlPanelView()
-(UIButton*)createMenuButton:(NSString*)key tag:(int)tag;
-(void)handleButtonTouch:(UIButton*)button;
@end

@implementation MenuControlPanelView

-(id)initWithControlPanelName:(NSString*)name {
    self = [super initWithControlPanelName:name];
    if (self) {
        [self addBackground];
        NSArray* menuItems = [[NSArray alloc] initWithArray:[ResourceManager getStyleArray:@"modules" module:name isPortrait:NO]];
        int tagId = 100;
        for(NSString* key in menuItems) {
            if([@"scores" isEqualToString:key] && [RebusGlobals isUnpaid]) {
                [self createMenuButton:@"upgrade" tag:tagId++];
            } else {
                [self createMenuButton:key tag:tagId++];
            }
        }
    }
    return self;
}

-(UIButton*)createMenuButton:(NSString*)key tag:(int)tag {
    NSString* buttonName = [NSString stringWithFormat:@"%@.button", key];
    UIButton* b = [ResourceManager getImageButton:buttonName module:@"menu" isPortrait:NO hasDownState:YES];
    [b addTarget:self action:@selector(handleButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [layoutManager addView:b withKey:[NSString stringWithFormat:@"%@.%@button", self.name, key] position:XY];
	b.showsTouchWhenHighlighted = NO;
	b.adjustsImageWhenHighlighted = NO;
    b.tag = tag++;
    return b;
}

-(void)handleButtonTouch:(UIButton*)button {
    NSString* destination;
    switch (button.tag) {
        case 100:
            destination = kPlayScene;
            [SimpleSoundManager play:@"enter"];
            break;
        case 101:
            destination = kScoresScene;
            [SimpleSoundManager playButton];
            break;
        case 102:
            destination = kSettingsScene;
            [SimpleSoundManager playButton];
            break;
        case 103:
            destination = kAboutScene;
            [SimpleSoundManager playButton];
            break;
        case 104:
            destination = kGamesScene;
            [SimpleSoundManager playButton];
            break;
        default:
            DebugLog(@"No valid destination specified.");
            break;
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:kShowAlertEvent object:@"help.answer"];        
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowSceneEvent object:destination];
}

@end
