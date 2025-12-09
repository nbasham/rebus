#import <Foundation/Foundation.h>
#import "Puzzle.h"

@interface RebusPuzzle : NSObject {
    NSMutableArray* hotspots;
    NSMutableArray* hints;
}

@property(nonatomic, assign, readonly)int puzzleId;
@property(nonatomic, strong, readonly)NSString* solution;

-(id)initWithId:(int)n solution:(NSString*)s;
-(int)getNumHints;
-(NSArray*)getHotspots;
-(NSArray*)getHints;
-(UIImage*)getImage;

@end
