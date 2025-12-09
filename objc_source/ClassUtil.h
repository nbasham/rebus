#import <Foundation/Foundation.h>

@interface ClassUtil : NSObject

+(Class)getMostSpecificClassOfType:(NSString*)type forModule:(NSString*)moduleKey;

@end
