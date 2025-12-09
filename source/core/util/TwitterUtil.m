#import "TwitterUtil.h"
#import <Twitter/TWTweetComposeViewController.h>
#import "AlertUtil.h"

@implementation TwitterUtil

+(BOOL)canTweet {
    if([TwitterUtil isTwitterSupported]) {
        if ([TWTweetComposeViewController canSendTweet]) {
            return YES;
        }
    }
    return NO;
}

+(BOOL)isTwitterSupported {
    Class twitterClass = NSClassFromString(@"TWTweetComposeViewController");
    if(twitterClass) {
        return YES;
    }
    return NO;
}

+(void)showTweetController:(UIViewController*)parent initialText:(NSString*)s attachImage:(UIImage*)i url:(NSString *)url {
    if ([TwitterUtil isTwitterSupported]) {
        TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
        [tweetViewController setInitialText:s];
        if (i != nil) {
            [tweetViewController addImage:i];
        }
        [tweetViewController addURL:[NSURL URLWithString:url]];
        [parent presentViewController:tweetViewController animated:YES completion:nil];
    } else {
        [AlertUtil showLocalizedOKAlert:@"twitter.requirement"];
    }
}

@end
