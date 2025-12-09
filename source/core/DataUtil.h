#import <Foundation/Foundation.h>

@interface DataUtil : NSObject {
}

+(NSString*)getAppDirectoryPath;
+(NSString*)getDocumentDirectoryPath;
+(NSString*)getPath:(NSString*)fileName;
+(BOOL)fileExists:(NSString*)p;
+(id)readObjectWithKey:(NSString*)key path:(NSString*)p;
+(NSArray*)readArrayFromFile:(NSString*)fileName;
+(NSArray*)fileLines:(NSString*)fileName;
+(void)writeObject:(id)obj key:(NSString*)key path:(NSString*)path;
+(void)writeArray:(NSArray*)a fileName:(NSString*)fileName;
+(BOOL)copyFile:(NSString*)src to:(NSString*)dest;
+(BOOL)moveFile:(NSString*)src to:(NSString*)dest;
+(BOOL)deleteFile:(NSString*)p;
+(BOOL)keyExists:(NSString*)key;
+(BOOL)keyUndefined:(NSString*)key;
+(BOOL)getBoolWithKey:(NSString*)key;
+(BOOL)getBoolWithKey:(NSString*)key withDefault:(BOOL)b;
+(void)setBool:(BOOL)b withKey:(NSString*)key;
+(int)getIntWithKey:(NSString*)key;
+(int)getIntWithKey:(NSString*)key withDefault:(int)d;
+(void)setInt:(int)v withKey:(NSString*)key;
+(float)getFloatWithKey:(NSString*)key;
+(void)setFloat:(float)v withKey:(NSString*)key;
+(NSString*)getStringWithKey:(NSString*)key ;
+(NSString*)getStringWithKey:(NSString*)key withDefault:(NSString*)d;
+(void)setString:(NSString*)v withKey:(NSString*)key;

//  if key wasn't defined return true and define it
+(BOOL)isKeyUndefinedThenDefine:(NSString*)what;
@end
