#import "RebusServer.h"
#import "StringUtil.h"
#import "RebusGlobals.h"

#define SERVER_URL @"isolace-sudoku-js.appspot.com"
#define PURTY_SERVER_URL @"live.therebusshow.com"

@implementation RebusServer

+(NSString*)getWebImageUrlFromPuzzle:(RebusPuzzle*)p {
    NSString* solution = [p solution];
    NSString* md5olution = [StringUtil md5HexDigest:solution];
    NSString* imageUrl = [NSString stringWithFormat:@"http://%@/public/rebus/puzzles/%@.png", SERVER_URL, md5olution];
    DebugLog(imageUrl);

    return imageUrl;
}

//  http://isolace-sudoku-js.appspot.com/rebus/play/puzzleId/67/imageName/a4e7ca9b35e692ad749028253d967ef8/appType/free.paid
+(NSString*)getWebPuzzleUrlFromPuzzle:(RebusPuzzle*)p {
    int puzzleId = [p puzzleId];
    NSString* solution = [p solution];
    NSString* md5olution = [StringUtil md5HexDigest:solution];
    NSString* whichApp = @"paid";
    if([RebusGlobals isFreeApp]) {
        if([RebusGlobals isUnpaid]) {
            whichApp = @"freeUnpaid";
        } else {
            whichApp = @"freePaid";
        }
    }
    NSString* puzzleUrl = [NSString stringWithFormat:@"http://%@/rebus/play/puzzleId/%d/imageName/%@/appType/%@", PURTY_SERVER_URL, puzzleId, md5olution, whichApp];

    return puzzleUrl;
}

@end
