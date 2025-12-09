#import "KeysView.h"
#import "UsageTracking.h"
#import "AlertUtil.h"
#import "ThreadUtil.h"
#import "StringUtil.h"

#define kKeyboardButtonBase 4000

@interface KeysView(Private)
-(void)guess:(char)c;
-(CGPoint)getKeyOrigin:(char)c;
-(void)pauseButtonTouch;
-(void)backButtonTouch;
-(void)keyboardTouch:(id)sender;
-(char)getKeyboardChar:(id)id;
@end

@implementation KeysView

-(id)initWithFrame:(CGRect)f name:(NSString*)n {
    self = [super initWithFrame:f name:n];
    if (self) {
        [super addBackground];
        
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.showsTouchWhenHighlighted = YES;
        //        backButton.backgroundColor = [UIColor orangeColor];
        //        backButton.alpha = 0.5;
        
        backButton.frame = [DeviceUtil isPad] ? CGRectMake(10, 122, 70, 50) :  CGRectMake(6, 64, 34, 28);
        [backButton addTarget:self action:@selector(backButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        
        UIButton* pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pauseButton.showsTouchWhenHighlighted = YES;
        pauseButton.frame = [DeviceUtil isPad] ? CGRectMake(540, 122, 70, 50) :  CGRectMake(296, 64, 34, 28);
        [pauseButton addTarget:self action:@selector(pauseButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        //        pauseButton.backgroundColor = [UIColor redColor];
        //        pauseButton.alpha = 0.5;
        [self addSubview:pauseButton];
        
        int buttonSize = [DeviceUtil isPad] ? 55 : 30;
        for(int i = 0; i < 26; i++) {
            UIButton* b = [UIButton buttonWithType:UIButtonTypeCustom];
            b.tag = kKeyboardButtonBase + i;
            b.showsTouchWhenHighlighted = YES;
            [b addTarget:self action:@selector(keyboardTouch:) forControlEvents:UIControlEventTouchUpInside];
            char c = 'A' + i;
            CGPoint origin = [self getKeyOrigin:c];
            b.frame = CGRectMake(origin.x, origin.y, buttonSize, buttonSize);
            //            b.backgroundColor = [UIColor yellowColor];
            //            b.alpha = 0.5;
            [self addSubview:b];
        }
    }
    return self;
}

-(void)pauseButtonTouch {
    [SimpleSoundManager play:@"type"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPauseGameRequest object:nil];
    //    [playState setPaused:!playState.paused];
    [UsageTracking trackEvent:@"touch" action:@"pause" label:nil value:-1];
}

-(void)backButtonTouch {
    [SimpleSoundManager play:@"type"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kExitGameRequest object:nil];
    [UsageTracking trackEvent:@"touch" action:@"exit" label:nil value:-1];
}

-(void)keyboardTouch:(id)sender {
    char c = [self getKeyboardChar:sender];
    [appDelegate.rebusPlayState keyboardTouch:c];
    [SimpleSoundManager play:@"type"];
    if([appDelegate.rebusPlayState solved]) {
        runBlockAfterDelay(0.263, ^{
            [SimpleSoundManager play:@"type-solved"];
        });
    }
}

-(char)getKeyboardChar:(id)id {
	UIButton *b = (UIButton *)id;
    char c = 'a' + [b tag] - kKeyboardButtonBase;
    return c;
}

-(CGPoint)getKeyOrigin:(char)c {
    CGPoint p;
    int xOffset = 15;
    int yOffset = 5;
    int width = 31;
    if([StringUtil containsChar:c inString:@"ASDFGHJKL"]) {
        yOffset = 35;
        xOffset = 32;
    } else if([StringUtil containsChar:c inString:@"ZXCVBNM"]) {
        yOffset = 66;
        xOffset = 47;
    }
    int charIndex = 0;
    switch (c) {
        case 'A':
            charIndex = 0;
            p = [DeviceUtil isPad] ? CGPointMake(127, 101) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'B':
            charIndex = 4;
            p = [DeviceUtil isPad] ? CGPointMake(386, 157) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'C':
            charIndex = 2;
            p = [DeviceUtil isPad] ? CGPointMake(271, 157) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'D':
            charIndex = 2;
            p = [DeviceUtil isPad] ? CGPointMake(242, 101) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'E':
            charIndex = 2;
            p = [DeviceUtil isPad] ? CGPointMake(213, 47) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'F':
            charIndex = 3;
            p = [DeviceUtil isPad] ? CGPointMake(300, 101) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'G':
            charIndex = 4;
            p = [DeviceUtil isPad] ? CGPointMake(356, 101) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'H':
            charIndex = 5;
            p = [DeviceUtil isPad] ? CGPointMake(414, 101) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'I':
            charIndex = 7;
            p = [DeviceUtil isPad] ? CGPointMake(501, 47) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'J':
            charIndex = 6;
            p = [DeviceUtil isPad] ? CGPointMake(470, 101) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'K':
            charIndex = 7;
            p = [DeviceUtil isPad] ? CGPointMake(528, 101) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'L':
            charIndex = 8;
            p = [DeviceUtil isPad] ? CGPointMake(585, 101) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'M':
            charIndex = 6;
            p = [DeviceUtil isPad] ? CGPointMake(503, 157) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'N':
            charIndex = 5;
            p = [DeviceUtil isPad] ? CGPointMake(444, 157) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'O':
            charIndex = 8;
            p = [DeviceUtil isPad] ? CGPointMake(558, 47) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'P':
            charIndex = 9;
            p = [DeviceUtil isPad] ? CGPointMake(616, 47) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'Q':
            charIndex = 0;
            p = [DeviceUtil isPad] ? CGPointMake(98, 47) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'R':
            charIndex = 3;
            p = [DeviceUtil isPad] ? CGPointMake(270, 47) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'S':
            charIndex = 1;
            p = [DeviceUtil isPad] ? CGPointMake(183, 101) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'T':
            charIndex = 4;
            p = [DeviceUtil isPad] ? CGPointMake(328, 47) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'U':
            charIndex = 6;
            p = [DeviceUtil isPad] ? CGPointMake(442, 47) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'V':
            charIndex = 3;
            p = [DeviceUtil isPad] ? CGPointMake(328, 157) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'W':
            charIndex = 1;
            p = [DeviceUtil isPad] ? CGPointMake(156, 47) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'X':
            charIndex = 1;
            p = [DeviceUtil isPad] ? CGPointMake(212, 157) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'Y':
            charIndex = 5;
            p = [DeviceUtil isPad] ? CGPointMake(385, 47) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        case 'Z':
            charIndex = 0;
            p = [DeviceUtil isPad] ? CGPointMake(154, 157) : CGPointMake(xOffset + width * charIndex, yOffset);
            break;
        default:
            p = CGPointMake(0, 0);
            DebugLog(@"getKeyOrigin passed out of range char: %c", c);
            break;
    }
    if([DeviceUtil isPad]) {
        p = CGPointMake(p.x - 74, p.y - 38);
    }
    return p;
}

@end
