#import "RebusTools.h"
#import "StringUtil.h"
#import "DataUtil.h"

@implementation RebusTools

+(void)createPuzzleFileList {
    NSString* PATH = @"/Users/nbasham/Documents/dev/farm/rawPuzzles";
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError* dataError = nil;
	NSArray* dirContents = [fileManager contentsOfDirectoryAtPath:PATH error:&dataError];
    NSMutableString* s = [NSMutableString string];
    NSMutableArray* a = [NSMutableArray array];
    int puzzleId = 0;
	for(NSString* fileName in dirContents) {
		if([fileName hasSuffix:@"png"]) {
            [s appendFormat:@"%d\t%@\n", puzzleId++, [fileName stringByDeletingPathExtension]];
            [a addObject: fileName];
		}
	}
    NSString* DEST = @"/Users/nbasham/Documents/dev/farm/puzzleData/";
    NSString* puzzleListFileName = [NSString stringWithFormat:@"%@puzzleList.txt", DEST];
    NSData* dataToWrite = [s dataUsingEncoding:NSUTF8StringEncoding];
    [dataToWrite writeToFile:puzzleListFileName atomically:YES];

	for(NSString* fileName in a) {
        NSString* solution = [fileName stringByDeletingPathExtension];
        NSString* solutionParsed = [solution stringByReplacingOccurrencesOfString: @" " withString:@",\n"];
        solutionParsed = [NSString stringWithFormat:@"%@,", solutionParsed];
        NSData* dataToWrite = [solutionParsed dataUsingEncoding:NSUTF8StringEncoding];
        NSString* hotspotFileName = [NSString stringWithFormat:@"%@%@.hotspot.txt", DEST, solution];
        [dataToWrite writeToFile:hotspotFileName atomically:YES];
	}
}

//  [RebusTools remove:@"-fs8" fromFilesInDir:@"/Users/nbasham/Documents/dev/farm/optimized puzzles"];
+(void)remove:(NSString*)s fromFilesInDir:(NSString*)d {
    [RebusTools replace:s withString:@"" fromFilesInDir:d toFilesInDir:d];
//	NSFileManager* fileManager = [NSFileManager defaultManager];
//	NSError* dataError = nil;
//	NSArray* dirContents = [fileManager contentsOfDirectoryAtPath:d error:&dataError];
//	for(NSString* fileName in dirContents) {
//        NSString* newFileName = [fileName stringByReplacingOccurrencesOfString:s withString:@""];
//        NSString* newFilePath = [NSString stringWithFormat:@"%@/%@", d, newFileName];
//        NSString* oldFilePath = [NSString stringWithFormat:@"%@/%@", d, fileName];
//        /*BOOL result = */[fileManager moveItemAtPath:oldFilePath toPath:newFilePath error:&dataError];
//	}
}

+(void)replace:(NSString*)oldStr withString:(NSString*)newStr fromFilesInDir:(NSString*)src toFilesInDir:(NSString*)dest {
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError* dataError = nil;
	NSArray* dirContents = [fileManager contentsOfDirectoryAtPath:src error:&dataError];
	for(NSString* fileName in dirContents) {
        NSString* newFileName = [fileName stringByReplacingOccurrencesOfString:oldStr withString:newStr];
        NSString* newFilePath = [NSString stringWithFormat:@"%@/%@", src, newFileName];
        NSString* oldFilePath = [NSString stringWithFormat:@"%@/%@", dest, fileName];
        /*BOOL result = */[fileManager moveItemAtPath:oldFilePath toPath:newFilePath error:&dataError];
	}
}

/*
 answer.n.png and answer.n@2x.png
 to
 answer.n.phone.png and answer.n.phone@2x.png
 */
+(void)addPhoneToName:(NSString*)src {
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError* dataError = nil;
	NSArray* dirContents = [fileManager contentsOfDirectoryAtPath:src error:&dataError];
	for(NSString* fileName in dirContents) {
        if(![StringUtil contains:@"phone" inString:fileName]) {
            BOOL is2x = [StringUtil contains:@"@2x" inString:fileName];
            NSString* newFileName;
            if(is2x) {
                newFileName = [fileName stringByReplacingOccurrencesOfString:@"@2x.png" withString:@".phone@2x.png"];
            } else {
                newFileName = [fileName stringByReplacingOccurrencesOfString:@".png" withString:@".phone.png"];
            }
            NSString* newFilePath = [NSString stringWithFormat:@"%@/%@", src, newFileName];
            NSString* oldFilePath = [NSString stringWithFormat:@"%@/%@", src, fileName];
            /*BOOL result = */[fileManager moveItemAtPath:oldFilePath toPath:newFilePath error:&dataError];
        }
	}
}

+(void)createServerPuzzles {
    NSArray* a = [DataUtil fileLines:@"puzzleList.txt"];
    for (NSString* puzzleData in a) {
        NSArray* chunks = [puzzleData componentsSeparatedByString: @"\t"];
        if([chunks count] != 2) {
            NSLog(@"File puzzleList.txt error: %@", puzzleData);
        }
        int puzzleId = [[chunks objectAtIndex:0] intValue];
        if(puzzleId == -1) {
            break; // till all puzzles are completed
        }
        NSString* solution = [chunks lastObject];
        [RebusTools createServerPuzzle:puzzleId solution:solution];
    }
}


+(void)createServerPuzzle:(int)puzzleId solution:(NSString*) solution {
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError* dataError = nil;
    NSString* DEST = @"/Users/nbasham/Documents/dev/isolace/trunk/isolace-sudoku-web/war/public/rebus/puzzles/";
    NSString* oldFilePath = [NSString stringWithFormat:@"%@/%@.png", [DataUtil getAppDirectoryPath], solution];
    NSString* newFilePath = [NSString stringWithFormat:@"%@%@.png", DEST, [StringUtil md5HexDigest:solution]];
    /*BOOL result = */[fileManager copyItemAtPath:oldFilePath toPath:newFilePath error:&dataError];
    NSLog(@"src: %@", oldFilePath);
    NSLog(@"dest: %@", newFilePath);
    NSLog(@"result: %@", [dataError description]);
}
@end
