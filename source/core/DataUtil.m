#import "DataUtil.h"

@implementation DataUtil

+(NSString*)getAppDirectoryPath {
    return [[NSBundle mainBundle] resourcePath];
}

+(NSString*)getDocumentDirectoryPath {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docDir = [paths objectAtIndex:0];
    return docDir;
}

+(NSString*)getPath:(NSString*)fileName {
    NSString* docDir = [DataUtil getDocumentDirectoryPath];
    NSString* path = [docDir stringByAppendingPathComponent:fileName];
    return path;
}

+(BOOL)fileExists:(NSString*)p {
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSString* path = [DataUtil getPath:p];
	if ([fileManager fileExistsAtPath:path] == YES) {
		return YES;
	} else {
		return NO;
	}
}

+(BOOL)deleteFile:(NSString*)p {
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSString* path = [DataUtil getPath:p];
	if ([fileManager removeItemAtPath:path error: NULL] == YES) {
		return YES;
	} else {
		return NO;
	}
}

+(BOOL)copyFile:(NSString*)src to:(NSString*)dest {
	NSFileManager* fileManager = [NSFileManager defaultManager];
    if([DataUtil fileExists:src]) {
        NSString* srcPath = [DataUtil getPath:src];
        NSString* destPath = [DataUtil getPath:dest];
        if ([fileManager copyItemAtPath:srcPath toPath:destPath error:NULL] == YES) {
            return YES;
        }
    }
    return NO;
}

+(BOOL)moveFile:(NSString*)src to:(NSString*)dest {
	NSFileManager* fileManager = [NSFileManager defaultManager];
    if([DataUtil fileExists:src]) {
        NSString* srcPath = [DataUtil getPath:src];
        NSString* destPath = [DataUtil getPath:dest];
        if ([fileManager moveItemAtPath:srcPath toPath:destPath error:NULL] == YES) {
            return YES;
        }
    }
    return NO;
}

+(id)readObjectWithKey:(NSString*)key path:(NSString*)p {
	NSString* path = [DataUtil getPath:p];
	NSDictionary * rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];    
	id obj = [rootObject valueForKey:key];
    return obj;
}

+(NSArray*)readArrayFromFile:(NSString*)fileName {
	NSString* path = [DataUtil getPath:fileName];
	NSArray * rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];    
	id obj = [rootObject valueForKey:@"array"];
    return obj;
}

+(void)writeObject:(id)obj key:(NSString*)key path:(NSString*)p {
	NSString* path = [DataUtil getPath:p];
	NSMutableDictionary * rootObject = [NSMutableDictionary dictionary];
	[rootObject setValue:obj forKey:key];
	[NSKeyedArchiver archiveRootObject: rootObject toFile: path];
}

+(void)writeArray:(NSArray*)a fileName:(NSString*)fileName {
	NSString* path = [DataUtil getPath:fileName];
	NSMutableDictionary* rootObject = [NSMutableDictionary dictionary];
	[rootObject setValue:a forKey:@"array"];
	[NSKeyedArchiver archiveRootObject: rootObject toFile: path];
}

+(BOOL)keyExists:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key] != nil;
}

+(BOOL)keyUndefined:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key] == nil;
}

+(BOOL)isKeyUndefinedThenDefine:(NSString*)key {
    BOOL isKeyUndefined = [DataUtil keyUndefined:key];
    if(isKeyUndefined) {
        [DataUtil setString:key withKey:key];
    }
    return isKeyUndefined;
}

+(BOOL)getBoolWithKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+(BOOL)getBoolWithKey:(NSString*)key withDefault:(BOOL)b {
	if([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil) {
		return b;
	}
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+(void)setBool:(BOOL)b withKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setBool:b forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)getIntWithKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+(int)getIntWithKey:(NSString*)key withDefault:(int)d {
	if([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil) {
		return d;
	}
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+(void)setInt:(int)v withKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setInteger:v forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(float)getFloatWithKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] floatForKey:key];
}

+(void)setFloat:(float)v withKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setFloat:v forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getStringWithKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(NSString*)getStringWithKey:(NSString*)key withDefault:(NSString*)d {
	if([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil) {
		return d;
	}
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(void)setString:(NSString*)v withKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setObject:v forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
 Read each line in a file into a string and add it to an array
 */
+(NSArray*)fileLines:(NSString*)fileName {
	//NSString* path = [DataUtil getPath:fileName];
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSString* fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray* lines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    return lines;
}

@end
