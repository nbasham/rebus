#import <Foundation/Foundation.h>
#import "MovieView.h"
#import "Music.h"

typedef enum ResourceType { STRING, IMAGE, MOVIE, STYLE, MUSIC } ResourceType;
#define kNoData @""

@interface ResourceManager : NSObject {
//    @private NSMutableDictionary* styles;
//    @private NSMutableDictionary* availableMovies;
//    @private NSMutableDictionary* availableMusic;
//    @private NSMutableDictionary* imageCache;
//    @private ;
//    @private NSMutableDictionary* styleCache;
}

+(BOOL)resourceExists:(NSString*)name resourceType:(ResourceType)resourceType;
+(NSDictionary*)getResourcesByExtension:(NSString*)extension;
+(NSDictionary*)getResourcesByExtensions:(NSArray*)extensions;
+(UIFont*)getFont:(NSString*)fontName size:(NSString*)fontSize;

//  Music, Movies, Images, Styles and Localization
+(Music*)getMusic:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait;
+(MovieView*)getMovie:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait;
+(UIImage*)getImage:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait;
+(NSString*)getStyle:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait;
+(NSString*)getLocalizedString:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait;

//  Style Convenience Methods
// convenience method to allow e.g. [getStyle:@"text" withAttribute:@"rect"] vs. [getStyle:[NSString stringWithFormat:@"%@.%@", @"text", @"rect"]]
+(NSString*)getStyle:(NSString*)name withAttribute:(NSString*)attribute module:(NSString*)moduleName isPortrait:(BOOL)isPortrait;
// convenience method to convert csv string into a CGRect
+(CGRect)getStyleRect:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait;
// convenience method to convert #aabbcc or #aabbccdd to a UIColor
+(UIColor*)getStyleColor:(NSString*)name withAttribute:(NSString*)attribute module:(NSString*)moduleName isPortrait:(BOOL)isPortrait;
// convenience method to convert csv string into a NSArray of NSStrings
+(NSArray*)getStyleArray:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait;
+(CGPoint)getStyleXY:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait;

//  UIView Style Convenience Methods
+(UILabel*)getLabel:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait;
//  additional data parameter allows the calling code to use this value (instead of name) to look for the label's value in Localizable.strings
//  consider table rows that share the same label but have unique label.text values
+(UILabel*)getLabel:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait data:(NSString*)data;
+(UITextView*)getMultiLineLabel:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait data:(NSString*)data;
+(UITextField*)getTextField:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait data:(NSString*)data;
+(UIButton*)getImageButton:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait hasDownState:(BOOL)hasDownState;
+(UIButton*)getStretchImageButton:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait hasDownState:(BOOL)hasDownState;

+(void)applyViewAttributes:(UIView*)o name:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait;
+(void)applyStylesToLabel:(UILabel*)o name:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait data:(NSString*)data;
//+(void)applyTextAttributes:(id)o name:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait data:(NSString*)data;
+(void)applyStylesToButton:(UIButton*)o name:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait data:(NSString*)data;

//  must be called after frame is set
+(void)centerMultiLineLabelVertically:(UITextView*)o;
+(void)bottomAlignMultiLineLabel:(UITextView*)o;

@end
