#import <Foundation/Foundation.h>

@interface RebusTools : NSObject

+(void)createPuzzleFileList;
+(void)remove:(NSString*)s fromFilesInDir:(NSString*)d;
+(void)replace:(NSString*)oldStr withString:(NSString*)newStr fromFilesInDir:(NSString*)src toFilesInDir:(NSString*)dest;
+(void)addPhoneToName:(NSString*)src;
+(void)createServerPuzzles;
+(void)createServerPuzzle:(int)puzzleId solution:(NSString*) solution;

@end
