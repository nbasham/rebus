#import <Foundation/Foundation.h>

/*
    Resource names are built with the following structure:
        [product key].[module name].<resource name>.[resource attribute].[device].[orientation].[language].[ext]
    By convention, the more specific the name, the higher precedence it takes e.g. myimage.pad is going to be
    used over myImage. A more complete example of precedence follows:
        quotefalls.play.backbutton.pad.portrait.png
        quotefalls.play.backbutton.pad.png
        quotefalls.play.backbutton.png
        quotefalls.backbutton.pad.portrait.png
        quotefalls.backbutton.pad.png
        quotefalls.backbutton.png
        play.backbutton.pad.portrait.png
        play.backbutton.pad.png
        play.backbutton.png
        backbutton.pad.portrait.png
        backbutton.pad.png
        backbutton.png
 
    ResourceName is a class that hides the rules of precedence, device, and orientation concerns, providing a
    way to iterate over name candidates in the order of precedence.
 
    NOTE: All resource names must be entirely lowercase
 */
@interface ResourceName : NSObject {
    @private int pointer;
    NSMutableArray* names;
}

@property(nonatomic, strong) NSArray* names;

+(id)name:(NSString*)name withExtension:(NSString*)ext module:(NSString*)moduleName isPortrait:(BOOL)isPortrait;
-(id)init:(NSString*)name withExtension:(NSString*)ext module:(NSString*)moduleName isPortrait:(BOOL)isPortrait;
-(BOOL)hasNext;
-(NSString*)next;

@end
