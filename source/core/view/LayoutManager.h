#import <Foundation/Foundation.h>

enum {
    NONE                    = 1 <<  0,
    POSITION_X              = 1 <<  1,
    POSITION_Y              = 1 <<  2,
    BOTTOM                  = 1 <<  3,
    RIGHT                   = 1 <<  4,
    RECT                    = 1 <<  5,
    XY                      = 1 <<  6,
    RUNTIME_POINT           = 1 <<  7,
    CENTER                  = 1 <<  8,
}; typedef NSUInteger LayoutManagerPositions;

@interface LayoutManager : NSObject {
}

-(id)initWithParent:(UIView*)v moduleName:(NSString*)name;
-(void)layout:(BOOL)isPortrait;
-(void)addView:(UIView*)v withKey:(NSString*)key position:(LayoutManagerPositions)p;
-(void)addView:(UIView*)v withKey:(NSString*)key x:(int)x y:(int)y;
-(UILabel*)createLabelWithKey:(NSString*)key position:(LayoutManagerPositions)p data:(NSString*)data;
-(UIImageView*)createBackgroundImageViewWithKey:(NSString*)key parent:(UIView*)parentView;
-(UIImageView*)createImageViewWithKey:(NSString*)key position:(LayoutManagerPositions)p;
-(void)insertView:(UIView*)o aboveViewWithKey:(NSString*)key;
-(void)sendToBack:(NSString*)key;
-(void)clear;
-(void)removeView:(UIView*)o;
-(UIView*)getViewByName:(NSString*)name;

@end
