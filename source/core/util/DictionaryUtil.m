#import "DictionaryUtil.h"

@implementation DictionaryUtil

+(BOOL)dict:(NSDictionary*)d containsKey:(id)key {
    return [d objectForKey:key] != nil;
}

@end
