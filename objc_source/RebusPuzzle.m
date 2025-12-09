#import "RebusPuzzle.h"
#import "DataUtil.h"
#import "StringUtil.h"

@interface RebusPuzzle()
@end

@implementation RebusPuzzle

@synthesize solution;
@synthesize puzzleId;

-(id)initWithId:(int)n solution:(NSString*)s {
    self = [super init];
    if (self) {
//        assert(![StringUtil contains:@"'" inString:s]);
        puzzleId = n;
		solution = [[NSString alloc] initWithString:s];
        if([solution length] > kMaxPuzzleLength) {
            DebugLog(@"Puzzle '%@' is too long, it is %d characters, and %d is the max.", solution, [solution length], kMaxPuzzleLength);
        }
        if([StringUtil contains:@" @" inString:solution]) {
            DebugLog(@"Puzzle '%@' has extra space before @.", solution);
        }
        if([StringUtil contains:@"'" inString:solution]) {
            DebugLog(@"Puzzle '%@' has an apostrophe.", solution);
        }
        if([solution hasPrefix:@" "] || [solution hasSuffix:@" "]) {
            DebugLog(@"Puzzle '%@' starts or ends with a space.", solution);
        }
	}
    return self;
}

-(UIImage*)getImage {
    NSString* imageName = [NSString stringWithFormat:@"%@.png", solution];
    UIImage* image = [UIImage imageNamed:imageName];
    return image;
}

-(int)getNumHints {
    if(hotspots == nil) {
        [self getHotspots];
    }
    return [hotspots count];
}

-(NSArray*)getHints {
    if(hotspots == nil) {
        [self getHotspots];
    }
    return hints;
}

-(NSArray*)getHotspots {
    if(hotspots == nil) {
        NSString* fileName = [NSString stringWithFormat:@"%@.hotspot.txt", solution];
        hotspots = [[NSMutableArray alloc] init];
        hints = [[NSMutableArray alloc] init];
        NSArray* lines = [DataUtil fileLines:fileName];
        for(NSString* line in lines) {
            NSArray* chunks = [line componentsSeparatedByString: @","];
            if([chunks count] == 5) {
                NSString* hint = [[chunks objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [hints addObject:hint];
                float x = [[chunks objectAtIndex:1] floatValue];
                float y = [[chunks objectAtIndex:2] floatValue];
                float w = [[chunks objectAtIndex:3] floatValue];
                float h = [[chunks objectAtIndex:4] floatValue];
                if([DeviceUtil isPhone]) {
                    x *= kPadToPhoneXRatio;
                    y *= kPadToPhoneYRatio;
                    w *= kPadToPhoneXRatio;
                    h *= kPadToPhoneYRatio;
                }
                [hotspots addObject:[NSValue valueWithCGRect:CGRectMake(x, y, w, h)]];
                chunks = nil;
            }
        }
        lines = nil;
    }
    return hotspots;
}

-(NSString*)description {
	NSMutableString* s = [NSMutableString string];
	[s appendFormat:@" solution: %@", solution];
	return s;
}

@end
