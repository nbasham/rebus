#import <Foundation/Foundation.h>

@interface AlertUtil : NSObject

+(void)showOKAlert:(NSString*)message;
+(void)showLocalizedOKAlert:(NSString*)messageKey;

@end
