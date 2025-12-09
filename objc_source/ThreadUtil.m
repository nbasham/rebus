#import "ThreadUtil.h"

@implementation ThreadUtil

//  runBlockAfterDelay(0, ^{});
void runBlockAfterDelay(NSTimeInterval delay, void (^block)(void)) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delay),
                   dispatch_get_current_queue(), block);
}

@end
