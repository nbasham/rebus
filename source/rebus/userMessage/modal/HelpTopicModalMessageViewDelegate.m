#import "HelpTopicModalMessageViewDelegate.h"
#import "AlertUtil.h"
#import "AppDelegate.h"
#import "RebusPlayState.h"

@interface HelpTopicModalMessageViewDelegate()
//-(void)handleHelpTopicTap:(UITapGestureRecognizer*)tapEvent;
@end

@implementation HelpTopicModalMessageViewDelegate

@synthesize message;

-(UIView*)getMessageView {
    UIImage* i = [ResourceManager getImage:[RebusGlobals isUnpaid] ? @"topic.upgrade" : @"topic" module:@"help" isPortrait:NO];
    messageView = [[UIImageView alloc] initWithImage:i];
    messageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer* helpTopicTapRecognizer;
//    helpTopicTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHelpTopicTap:)];
//    helpTopicTapRecognizer.numberOfTapsRequired = 1;
//    helpTopicTapRecognizer.cancelsTouchesInView = NO;
//    [messageView addGestureRecognizer:helpTopicTapRecognizer];
    return messageView;
}

-(BOOL)dismissOnTouch {
    return YES;
}

-(UIView*)getBackgroundView {
    UIView* v = nil;
    return v;
}

-(void)willShow {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    RebusPlayState* rebusPlayState = appDelegate.rebusPlayState;
    [rebusPlayState setPaused:YES];
}

-(void)didShow {
}

-(void)willHide {
}

-(void)didHide {
    messageView = nil;
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    RebusPlayState* rebusPlayState = appDelegate.rebusPlayState;
    [rebusPlayState startTimer];
}

//-(void)handleHelpTopicTap:(UITapGestureRecognizer*)tapEvent {
//    //  REMOVE THIS
//    BOOL debug = YES;
//    
//    if(debug) {
//        [AlertUtil showOKAlert:@"Not implemented yet."];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kHideAlertEvent object:nil];
//    } else {
//        CGPoint p = [tapEvent locationInView:messageView];
//        __block NSString* helpSubject;
//        if(p.y < [RebusGlobals getStageHeight]) {
//            helpSubject = @"help.play";
//        } else if(p.y < ([RebusGlobals getStageHeight] + 108)) {
//            helpSubject = @"help.answer";
//        } else if (p.x < 206) {
//            helpSubject = @"help.points";
//        } else if (p.x < 814) {
//            helpSubject = @"help.keyboard";
//        } else {
//            helpSubject = @"help.help";
//        }
//        //DebugLog(@"Subject %@ from x: %4.0f y: %4.0f", helpSubject, p.x, p.y);
//        [[NSNotificationCenter defaultCenter] postNotificationName:kHideAlertEvent object:nil];
//        if(![@"help.help" isEqualToString:helpSubject]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kShowAlertEvent object:helpSubject];        
//        }
//    }
//}

@end
