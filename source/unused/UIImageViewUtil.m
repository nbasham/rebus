#import "UIImageViewUtil.h"
#import "UIImage+Alpha.h"

@implementation UIImageViewUtil

+(void)setClipRectangle:(CGRect)r onView:(UIImageView*)v {
    //  r isn't correct
    r = CGRectMake(r.origin.x, [[UIScreen mainScreen] bounds].size.height - r.origin.y, r.size.width, r.size.height);
    UIImage* fullImageWithAlpha = [v.image imageWithAlpha];
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                fullImageWithAlpha.size.width,
                                                fullImageWithAlpha.size.height,
                                                CGImageGetBitsPerComponent(fullImageWithAlpha.CGImage),
                                                0,
                                                CGImageGetColorSpace(fullImageWithAlpha.CGImage),
                                                CGImageGetBitmapInfo(fullImageWithAlpha.CGImage));
    CGContextDrawImage(bitmap, CGRectMake(0, 0, fullImageWithAlpha.size.width, fullImageWithAlpha.size.height), fullImageWithAlpha.CGImage);
    CGContextClearRect(bitmap, r);
    CGImageRef clippedImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage* clippedImage = [UIImage imageWithCGImage:clippedImageRef];
    [v setImage:clippedImage];
    CGContextRelease(bitmap);
    CGImageRelease(clippedImageRef);
}

@end
