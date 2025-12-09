#import "PathUtil.h"

@implementation PathUtil

+(NSURL*)getUrlFromFileName:(NSString*)fileName ofType:(NSString*)type {
    BOOL debug = NO;
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSArray* a = [path componentsSeparatedByString:@"/"];
    if(debug) {
        for (NSString* s in a) {
            DebugLog(s);
        }
    }
    NSURL* url = [NSURL fileURLWithPath:path];
    if(debug) {
        a = [url pathComponents];
        for (NSString* s in a) {
            DebugLog(s);
        }
    }
    return url;
}

@end
