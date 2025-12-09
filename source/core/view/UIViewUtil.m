#import "UIViewUtil.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIViewUtil

+(UIImage*)getImageFromView:(UIView*)v {
    UIGraphicsBeginImageContext(v.bounds.size);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	return [[UIImage alloc] initWithCGImage:viewImage.CGImage];
}

@end
