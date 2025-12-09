#import <UIKit/UIKit.h>
#import "RebusPuzzle.h"

@interface RebusServer : NSObject

+(NSString*)getWebImageUrlFromPuzzle:(RebusPuzzle*)p;
+(NSString*)getWebPuzzleUrlFromPuzzle:(RebusPuzzle*)p;

@end
