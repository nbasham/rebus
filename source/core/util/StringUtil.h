#import <Foundation/Foundation.h>

@interface StringUtil : NSObject {
}

+(NSString*)removeChars:(NSCharacterSet*)charsToRemove from:(NSString*)s;
+(NSString*)firstCharToLowercase:(NSString*)s;
+(NSString*)encode:(NSString*)s;
+(NSString*)padLeft:(NSString*)s length:(int)l;
+(NSString*)padRight:(NSString*)s length:(int)l;
+(BOOL)string:(NSString*)s contains:(NSString*)s1;
+(BOOL)hasLeadingTrailingWhitespace:(NSString*)s;
+(NSString*)getStringForBool:(BOOL)b;
+(int)indexOf:(NSString *)searchFor inString:(NSString*)s;
+(BOOL)contains:(NSString *)searchFor inString:(NSString*)s;
+(BOOL)containsChar:(char)c inString:(NSString*)s;
+(NSString*)clean:(NSString*)s;
+(NSString*)md5HexDigest:(NSString*)input;

@end
