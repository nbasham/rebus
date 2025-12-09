#import <Foundation/Foundation.h>

@interface NavigationUtil : NSObject

+(void)navigateToRoot:(BOOL)animated;
+(void)navigateTo:(NSString*)key data:(id)data animated:(BOOL)animated;
+(void)navigateBack:(BOOL)animated;

@end
