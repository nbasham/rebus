#import <Foundation/Foundation.h>

@interface Puzzle : NSObject<NSCoding> {
    int puzzleId;
}

@property (assign, nonatomic) int puzzleId;

-(id)initWithDictionary:(NSDictionary*)d;
-(id)initWithDictionary:(NSDictionary*)d;
-(void)validate:(NSDictionary*)d;

@end
