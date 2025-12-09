#import "Puzzle.h"

@implementation Puzzle

@synthesize puzzleId;

-(id)initWithDictionary:(NSDictionary*)d {
    self = [super init];
    if (self) {
		puzzleId = [(NSNumber*)[d objectForKey:@"id"] intValue];
	}
    return self;
}

-(void)validate:(NSDictionary*)d {    
}

-(NSString*)description {
	NSMutableString* s = [NSMutableString string];
	[s appendString:[super description]];
	[s appendFormat:@"id: %4d", puzzleId];
	return s;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInt:puzzleId forKey:@"puzzleId"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
	if (self) {
        puzzleId = [decoder decodeIntForKey:@"puzzleId"];
	}
	return self;
}


@end
