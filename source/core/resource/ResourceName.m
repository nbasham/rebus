#import "ResourceName.h"
#import "DeviceUtil.h"
#include "DebugLog.h"

@implementation ResourceName

@synthesize names;

+(id)name:(NSString*)name withExtension:(NSString*)ext module:(NSString*)moduleName isPortrait:(BOOL)isPortrait {
    ResourceName* o = [[ResourceName alloc] init:name withExtension:ext module:moduleName isPortrait:isPortrait];
    return o;
}

-(id)init:(NSString*)name withExtension:(NSString*)extOrNil module:(NSString*)moduleName isPortrait:(BOOL)isPortrait {
    self = [super init];
    if (self) {
       // NSDate *startTime = [NSDate date];
        pointer = 0;
        names = [[NSMutableArray alloc] initWithCapacity:12];
        NSString* productKey = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"productKey"] lowercaseString];
        NSString* device = @"phone";
        if([DeviceUtil isPad]) {
            device = @"pad";
        }
        NSString* orientation = @"";
        if(isPortrait) {
            orientation = @"portrait";
        }
        NSString* ext = extOrNil == nil ? @"" : extOrNil;
        
        //  [product key].[module name].<resource name>
        NSString* lowercaseName = [name lowercaseString];
        
        BOOL checkForProductPrefix = NO;
        if(checkForProductPrefix) {
            if(moduleName != nil) {
                if(isPortrait) {
                    [names addObject:[NSString stringWithFormat:@"%@.%@.%@.%@.%@%@", productKey, moduleName, lowercaseName, device, orientation, ext]];
                }
                [names addObject:[NSString stringWithFormat:       @"%@.%@.%@.%@%@", productKey, moduleName, lowercaseName, device, ext]];
                [names addObject:[NSString stringWithFormat:          @"%@.%@.%@%@", productKey, moduleName, lowercaseName, ext]];
            }
            
            //  [product key].<resource name>
            if(isPortrait) {
                [names addObject:[NSString stringWithFormat:@"%@.%@.%@.%@%@", productKey, lowercaseName, device, orientation, ext]];
            }
            [names addObject:[NSString stringWithFormat:@"%@.%@.%@%@", productKey, lowercaseName, device, ext]];
            [names addObject:[NSString stringWithFormat:@"%@.%@%@", productKey, lowercaseName, ext]];
        }

        //  [module name].<resource name>
        if(moduleName != nil) {
            if(isPortrait) {
                [names addObject:[NSString stringWithFormat:@"%@.%@.%@.%@%@", moduleName, lowercaseName, device, orientation, ext]];
            }
            [names addObject:[NSString stringWithFormat:@"%@.%@.%@%@", moduleName, lowercaseName, device, ext]];
            [names addObject:[NSString stringWithFormat:@"%@.%@%@", moduleName, lowercaseName, ext]];
        }

        //  <resource name>
        if(isPortrait) {
            [names addObject:[NSString stringWithFormat:@"%@.%@.%@%@", lowercaseName, device, orientation, ext]];
        }
        [names addObject:[NSString stringWithFormat:@"%@.%@%@", lowercaseName, device, ext]];
        [names addObject:[NSString stringWithFormat:@"%@%@", lowercaseName, ext]];
        //DebugLog(@"ResourceName init elapsed time: %f", -[startTime timeIntervalSinceNow]);
    }
    return self;
}

-(BOOL)hasNext {
    return pointer < [names count];
}

-(NSString*)next {
    return [names objectAtIndex:pointer++];
}

@end
