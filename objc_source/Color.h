#import <Foundation/Foundation.h>

//  HEXCOLOR(0x9e2e28FF);
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 \
                                    green:((c>>16)&0xFF)/255.0 \
                                     blue:((c>>8)&0xFF)/255.0 \
                                    alpha:((c)&0xFF)/255.0];
                                    
//msgLabel.textColor = RGB(255, 251, 204)                                    
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface Color : NSObject {
}

+(UIColor*)toUIColor:(NSString*)hexColorString;

/*
 Created by Jonas Schnelli on 01.07.10.
 https://github.com/jonasschnelli/UIColor-i7HexColor/blob/master/UIColor%2Bi7HexColor.m
 label.textColor = [UIColor colorWithHexString:@"ff0000"]; // red color
 label.textColor = [UIColor colorWithHexString:@"f00"]; // red color
 label.textColor = [UIColor colorWithHexString:@"ff000055"]; // red color with some alpha 
*/ 
+(UIColor*)colorWithHexString:(NSString*)hexString;
	
@end
