#import "StringUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation StringUtil

+(NSString*)removeChars:(NSCharacterSet*)charsToRemove from:(NSString*)s {
    NSString* result  = @"";
    NSScanner* scanner = [NSScanner scannerWithString:s];
    NSString* scannerResult;
    [scanner setCharactersToBeSkipped:nil];
    while (![scanner isAtEnd]) {
        if([scanner scanUpToCharactersFromSet:charsToRemove intoString:&scannerResult]) {
            result = [result stringByAppendingString:scannerResult];
        } else {
            if(![scanner isAtEnd]) {
                [scanner setScanLocation:[scanner scanLocation]+1];
            }
        }
    }
    return result;
}

+(NSString*)firstCharToLowercase:(NSString*)s {
	NSString* uppered = [s stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[s substringToIndex:1] lowercaseString]];
    return uppered;
}

+(NSString*)encode:(NSString*)s {
    if(s != nil) {
        //  ””’':/?#[]@!$&()*+,;=
        NSString* encodedValue = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)s, NULL, CFSTR(" =/:"), kCFStringEncodingUTF8);
        return encodedValue;
    }
    return nil;
}

+(NSString*)padLeft:(NSString*)s length:(int)l {
    NSMutableString* o = [NSMutableString stringWithString:s];
    int diff = l - [s length];
    for (int i = 0; i < diff; i++) {
        [o insertString:@" " atIndex:0];
    }
    return o;
}

+(NSString*)padRight:(NSString*)s length:(int)l {
    NSMutableString* o = [NSMutableString stringWithString:s];
    int diff = l - [s length];
    for (int i = 0; i < diff; i++) {
        [o appendFormat:@"%@", @" "];
    }
    return o;
}

+(BOOL)string:(NSString*)s contains:(NSString*)s1 {
    if ([s rangeOfString:s1].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+(BOOL)hasLeadingTrailingWhitespace:(NSString*)s {
    NSString* trimmedString = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [trimmedString length] != [s length];
}

+(NSString*)getStringForBool:(BOOL)b {
    return b ? @"YES" : @"NO";
}

+(NSString*)clean:(NSString*)s {
    s = [s stringByReplacingOccurrencesOfString:@"’" withString:@"'"];
    s = [s stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    s = [s stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return s;
}

+(BOOL)contains:(NSString *)searchFor inString:(NSString*)s {
    return [StringUtil indexOf:searchFor inString:s] != -1;
}

+(BOOL)containsChar:(char)c inString:(NSString*)s {
    NSString* charStr = [NSString stringWithFormat:@"%c", c];
    return [StringUtil indexOf:charStr inString:s] != -1;
}

+(int)indexOf:(NSString *)searchFor inString:(NSString*)s {
    NSRange range = [s rangeOfString:searchFor];
    if ( range.location == NSNotFound ) {
        return -1;
    } else {
        return range.location;
    }
}

+(NSString*)md5HexDigest:(NSString*)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

@end
