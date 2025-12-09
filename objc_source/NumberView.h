#import <UIKit/UIKit.h>

enum {
    NO_PUNCTUATION                = 0,
    TIME_PUNCTUATION              = 1,
    NUMBER_PUNCTUATION            = 2,
}; typedef NSUInteger NumberViewFormat;

@interface NumberView : UIView {
    float scale;
}

@property(nonatomic, assign) int numCols;

-(id)initWithImages:(NSArray*)imageArray value:(int)value format:(NumberViewFormat)format;
-(id)initWithImages:(NSArray*)imageArray value:(int)value format:(NumberViewFormat)format scale:(float)scale;
//-(id)initWithImages:(NSArray*)imageArray time:(int)seconds;

@end
