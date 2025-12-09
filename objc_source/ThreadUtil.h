#import <Foundation/Foundation.h>

@interface ThreadUtil : NSObject

void runBlockAfterDelay(NSTimeInterval delay, void (^block)(void));

@end
