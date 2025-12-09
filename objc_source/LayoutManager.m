#import "LayoutManager.h"
#import "ResourceManager.h"
#import "DictionaryUtil.h"

@interface LayoutManager()
@property(nonatomic, strong) UIView* parent;
@property(nonatomic, strong) NSString* parentModuleName;
@property(nonatomic, strong) NSMutableDictionary* views;
-(void)addViewRecord:(NSMutableDictionary*)record withKey:(NSString*)key;
@end

@implementation LayoutManager

@synthesize parent;
@synthesize parentModuleName;
@synthesize views;

-(id)initWithParent:(UIView*)v moduleName:(NSString*)name {
    self = [super init];
    if (self) {
        parent = v;
        parentModuleName = name;
        parent.autoresizesSubviews = NO;
        views = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(NSString*)description {
	NSMutableString* s = [NSMutableString string];
	[s appendFormat:@"\nParent name: %@\n", parentModuleName];
    [s appendString:@"Views:\n"];
    for(NSString* key in views) {
        [s appendFormat:@"\t%@\n", key];
    }
	return s;
}

-(void)addViewRecord:(NSMutableDictionary*)record withKey:(NSString*)key {
    if ([DictionaryUtil dict:views containsKey:key]) {
        DebugLog(@"\nKey already added: %@\n%@", key, [self description]);
    } else {
        [views setObject:record forKey:key];
    }
}

-(void)sendToBack:(NSString*)key {
    NSMutableDictionary* record = [views objectForKey:key];
    UIView* v = [record objectForKey:@"view"];
    [parent sendSubviewToBack:v];
}

-(UIView*)getViewByName:(NSString*)name {
    for(NSString* key in views) {
        if([name isEqualToString:key]) {
            NSMutableDictionary* record = [views objectForKey:key];
            UIView* v = [record objectForKey:@"view"];
            return v;
        }
    }
    return nil;
}

-(void)removeView:(UIView*)o {
    for(NSString* key in views) {
        NSMutableDictionary* record = [views objectForKey:key];
        UIView* v = [record objectForKey:@"view"];
        if(v == o) {
            [views removeObjectForKey:key];
            [v removeFromSuperview];
            return;
        }
    }
}

-(void)insertView:(UIView*)o aboveViewWithKey:(NSString*)key {
    NSMutableDictionary* record = [views objectForKey:key];
    UIView* v = [record objectForKey:@"view"];
    [parent insertSubview:o aboveSubview:v];
}

-(void)addView:(UIView*)v withKey:(NSString*)key position:(LayoutManagerPositions)p {
    [parent addSubview:v];
    NSMutableDictionary* record = [NSMutableDictionary dictionaryWithCapacity:2];
    [record setObject:v forKey:@"view"];
    [record setObject:[NSNumber numberWithUnsignedInt:p] forKey:@"position"];
    [self addViewRecord:record withKey:key];
}

-(void)addView:(UIView*)v withKey:(NSString*)key x:(int)x y:(int)y {
    [parent addSubview:v];
    NSMutableDictionary* record = [NSMutableDictionary dictionaryWithCapacity:2];
    [record setObject:v forKey:@"view"];
    [record setObject:[NSNumber numberWithUnsignedInt:RUNTIME_POINT] forKey:@"position"];
    [record setObject:[NSNumber numberWithInt:x] forKey:@"x"];
    [record setObject:[NSNumber numberWithInt:y] forKey:@"y"];
    [self addViewRecord:record withKey:key];
}

-(UILabel*)createLabelWithKey:(NSString*)key position:(LayoutManagerPositions)p data:(NSString*)data {
    UILabel* v = [ResourceManager getLabel:key module:parentModuleName isPortrait:NO data:data];
    [parent addSubview:v];
    NSMutableDictionary* record = [NSMutableDictionary dictionaryWithCapacity:2];
    [record setObject:v forKey:@"view"];
    [record setObject:[NSNumber numberWithUnsignedInt:p] forKey:@"position"];
    [self addViewRecord:record withKey:key];
    return v;
}

-(UIImageView*)createBackgroundImageViewWithKey:(NSString*)key parent:(UIView*)parentView {
    UIImageView* v = [self createImageViewWithKey:key position:NONE];
    parent.frameWidth = v.image.size.width;
    parent.frameHeight = v.image.size.height;
    return v;
}

-(UIImageView*)createImageViewWithKey:(NSString*)key position:(LayoutManagerPositions)p {
    UIImage* i = [ResourceManager getImage:key module:parentModuleName isPortrait:NO];
    UIImageView* v = [[UIImageView alloc] initWithImage:i];
    v.frame = CGRectMake(0, 0, i.size.width, i.size.height);
    i = nil;
    v.userInteractionEnabled = NO;
    //DebugLog(@"%@ create x: %d y: %d w: %2.0f h: %2.0f", key, v.frame.origin.x, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
    [parent addSubview:v];
    NSMutableDictionary* record = [NSMutableDictionary dictionaryWithCapacity:2];
    [record setObject:v forKey:@"view"];
    [record setObject:[NSNumber numberWithUnsignedInt:p] forKey:@"position"];
    [self addViewRecord:record withKey:key];
    return v;
}

-(void)clear {
    for(NSString* key in views) {
        NSMutableDictionary* record = [views objectForKey:key];
        UIView* v = [record objectForKey:@"view"];
        [v removeFromSuperview];
        v = nil;
    }
    [views removeAllObjects];
}

-(void)layout:(BOOL)isPortrait {
    NSMutableString* s = [NSMutableString string];
    [s appendFormat:@"\n%@ layout x: %2.0f y: %2.0f w: %2.0f h: %2.0f\n", parentModuleName, parent.frame.origin.x, parent.frame.origin.y, parent.frame.size.width, parent.frame.size.height];
    for(NSString* key in views) {
        NSMutableDictionary* record = [views objectForKey:key];
        LayoutManagerPositions p = (NSUInteger)[(NSNumber*)[record objectForKey:@"position"] unsignedIntValue];
        if(p == NONE) {
            [s appendFormat:@"\t%@ layout without positioning\n", key];
            continue;
        }
        UIView* v = [record objectForKey:@"view"];
        NSString* styleName;
        if (p & RECT) {
            styleName = [NSString stringWithFormat:@"%@", key];
            v.frame = [ResourceManager getStyleRect:styleName module:parentModuleName isPortrait:isPortrait];
        }
        if (p & XY) {
            styleName = [NSString stringWithFormat:@"%@", key];
            CGPoint pt = [ResourceManager getStyleXY:styleName module:parentModuleName isPortrait:isPortrait];
            v.frameX = pt.x;
            v.frameY = pt.y;
        }
        if (p & CENTER) {
            styleName = [NSString stringWithFormat:@"%@", key];
            CGPoint pt = [ResourceManager getStyleXY:styleName module:parentModuleName isPortrait:isPortrait];
            v.center = pt;
        }
        if (p & POSITION_X) {
            int x = [[ResourceManager getStyle:[NSString stringWithFormat:@"%@.x", key] module:parentModuleName isPortrait:isPortrait] intValue];
            [v setFrameX:x];
        }
        if (p & POSITION_Y) {
            int y = [[ResourceManager getStyle:[NSString stringWithFormat:@"%@.y", key] module:parentModuleName isPortrait:isPortrait] intValue];
            [v setFrameY:y];
        }
        if (p & BOTTOM) {
            v.frameBottom = parent.frame.size.height;
        }
        if (p & RIGHT) {
            v.frameRight = parent.frame.size.width;
        }
        if(p & RUNTIME_POINT) {
            int x = [[record objectForKey:@"x"] intValue];
            int y = [[record objectForKey:@"y"] intValue];
            v.frameX = x;
            v.frameY = y;
        }
        [s appendFormat:@"\t%@ layout x: %2.0f y: %2.0f w: %2.0f h: %2.0f\n", key, v.frame.origin.x, v.frame.origin.y, v.frame.size.width, v.frame.size.height];
    }
    //DebugLog(s);
}

@end
