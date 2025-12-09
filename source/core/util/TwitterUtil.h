#import <Foundation/Foundation.h>

@interface TwitterUtil : NSObject

+(BOOL)canTweet;
+(BOOL)isTwitterSupported;
+(void)showTweetController:(UIViewController*)parent initialText:(NSString*)s attachImage:(UIImage*)i url:(NSString*)url;

@end
