#import "ClassUtil.h"
#import "Products.h"

@implementation ClassUtil

+(Class)getMostSpecificClassOfType:(NSString*)type forModule:(NSString*)moduleKey {
    Class specificClass;
    if(type != nil && moduleKey != nil) {
        NSString* capModuleKey = [moduleKey stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[moduleKey substringToIndex:1] capitalizedString]];
        NSString* className = [NSString stringWithFormat:@"%@%@", capModuleKey, type];
        NSString* capAppName = [Products productKeyToClassNamePrefix];
        NSString* appClassName = [NSString stringWithFormat:@"%@%@", capAppName, className];
        Class appClass = NSClassFromString(appClassName);
        BOOL appOverrodeClass = appClass != nil;
        if(appOverrodeClass) {  //  e.g. QuotefallsPlayViewController
            return appClass;
        } else {                //  e.g. PlayViewController
            return NSClassFromString(className);
        }
    } else {
        DebugLog(@"Must pass type and key args.");
    }
    return specificClass;
}

@end
