#import "SharedResource.h"

@interface SharedResource()
@end

@implementation SharedResource

+(UIImage*)getImageNamed:(NSString*)name scaledToSize:(CGSize)newSize {
    NSString* s = name;
    if([DeviceUtil isPhone]) {
        NSString* lowercaseName = [name lowercaseString];
        s = [NSString stringWithFormat:@"%@.%@%@", lowercaseName, @"pad", @".png"];
    }
    UIImage* i = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:s ofType:nil]];
    if([DeviceUtil isPhone]) {
        CGSize scaled = CGSizeMake(i.size.width*480/1024, i.size.height*320/768);
        i = [SharedResource imageWithImage:i scaledToSize:scaled];
    }
    return i;
}

+(UIImage*)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

@end
