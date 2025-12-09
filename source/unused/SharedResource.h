#import <UIKit/UIKit.h>

@interface SharedResource : NSObject

+(UIImage*)getImageNamed:(NSString*)name scaledToSize:(CGSize)newSize;
+(UIImage*)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
