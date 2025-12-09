#import "RebusAnswerPlayState.h"

@interface RebusAnswerPlayState()
@end

@implementation RebusAnswerPlayState

@synthesize state;

-(id)initWithCharacter:(char)c {
    self = [super init];
    if (self) {
        answer = c;
        if(c == ' ') {
            [self updateValue:c];
        } else {
            [self updateValue:'_'];
        }
    }
    return self;
}

-(BOOL)isCorrect {
    return (value == answer);
}

-(void)updateValue:(char)c {
    switch (c) {
        case ' ':
            value = c;
            state = SPACE;
            break;
        case '_':
            value = c;
            state = UNANSWERED;
            break;
            
        default:
            value = c;
            state = ANSWERED;
            break;
    }
}

-(NSString*)getStringValue {
    return [[NSString stringWithFormat:@"%c", value] uppercaseString];
}

-(char)getValue {
    return value;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInt:answer forKey:@"answer"];
	[encoder encodeInt:value forKey:@"value"];
}

-(id)initWithCoder:(NSCoder *)decoder {
	if (self) {
		answer = [decoder decodeIntForKey:@"answer"];
		value = [decoder decodeIntForKey:@"value"];
        [self updateValue:value];
 	}
	return self;
}

@end
