#import <Foundation/Foundation.h>

@interface PathUtil : NSObject

+(NSURL*)getUrlFromFileName:(NSString*)fileName ofType:(NSString*)type;

@end
