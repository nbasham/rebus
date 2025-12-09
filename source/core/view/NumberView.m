#import "NumberView.h"

@interface NumberView()
-(void)initializeWithImages:(NSArray*)imageArray valueStr:(NSString*)valueStr;
+(NSString*)secondsToMMSS:(int)seconds;
@end

@implementation NumberView

@synthesize numCols;

-(id)initWithImages:(NSArray*)imageArray value:(int)value format:(NumberViewFormat)format {
    scale = 1.0;
    return [self initWithImages:imageArray value:value format:format scale:scale];
}

-(id)initWithImages:(NSArray*)imageArray value:(int)value format:(NumberViewFormat)format scale:(float)f {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        scale = f;
        NSString* valueStr;
        switch (format) {
            case TIME_PUNCTUATION:
                valueStr = [NumberView secondsToMMSS:value];
                break;
            case NUMBER_PUNCTUATION: {
                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
                [numberFormatter setLocale:locale];
                [numberFormatter setNumberStyle: kCFNumberFormatterDecimalStyle];
                valueStr = [numberFormatter stringFromNumber:[NSNumber numberWithInt:value]];
                break;
            }
            default:    //  NO_PUNCTUATION
                valueStr = [NSString stringWithFormat:@"%d", value];
                break;
        }
        [self initializeWithImages:imageArray valueStr:valueStr];
    }
    return self;
}

-(void)initializeWithImages:(NSArray*)imageArray valueStr:(NSString*)valueStr {
    UIImage* sampleImage = [imageArray lastObject];
    int imageWidth = sampleImage.size.width * scale;
    int imageHeight = sampleImage.size.height * scale;
    self.frameHeight = imageHeight;
    numCols = [valueStr length];
    self.frameWidth = imageWidth * numCols;
    for (int i = 0; i < numCols; i++) {
        char c = [valueStr characterAtIndex:i];
        int imageIndex = 10;
        if(c != ','&& c != ':') {
            imageIndex = c - '0';
        }
        UIImageView* v = [[UIImageView alloc] initWithImage:[imageArray objectAtIndex:imageIndex]];
        v.frameX = (i * imageWidth);
        v.frameHeight = imageHeight;
        v.frameWidth = imageWidth;
        [self addSubview:v];
    }
}

+(NSString*)secondsToMMSS:(int)seconds {
	NSMutableString* s = [NSMutableString string];
    if(seconds < 60) {
		[s appendFormat:@"0:%.2d", seconds];
    } else {
        int min = floor(seconds/60.0);
        int sec = seconds % 60;
		[s appendFormat:@"%d:%.2d", min, sec];
    }
    return s;
}

@end
