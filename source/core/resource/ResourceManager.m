#import "ResourceManager.h"
#import "DataUtil.h"
#import "Color.h"
#import "ResourceName.h"

@interface ResourceManager()
    @property(nonatomic, strong)NSMutableDictionary* imageCache;
    @property(nonatomic, strong)NSMutableDictionary* styleCache;
    @property(nonatomic, strong)NSMutableDictionary* availableMusic;
    @property(nonatomic, strong)NSMutableDictionary* availableMovies;
    @property(nonatomic, strong)NSDictionary* styles;
    @property(nonatomic, strong)NSDictionary* availableImageNames;
    +(ResourceManager*)sharedInstance;
    -(void)handleMemoryWarning:(NSNotification*)notification;
@end

@implementation ResourceManager

@synthesize imageCache;
@synthesize styleCache;
@synthesize availableMusic;
@synthesize availableMovies;
@synthesize styles;
@synthesize availableImageNames;

+(ResourceManager*)sharedInstance {
    static ResourceManager* myInstance = nil;
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
    }
    return myInstance;
}

-(id)init {
    self = [super init];
    if (self) {
        //  profiling revealed #1 benefit from cache
        imageCache = [[NSMutableDictionary alloc] init];
        //  profiling revealed #2 benefit from cache
        styleCache = [[NSMutableDictionary alloc] init];
        availableMusic = (NSMutableDictionary*)[ResourceManager getResourcesByExtensions:[NSArray arrayWithObjects:nil]];
        //availableMusic = [ResourceManager getResourcesByExtensions:[NSArray arrayWithObjects:@"mp3", @"wav", @"caf", @"aiff", nil]];
        availableMovies = (NSMutableDictionary*)[ResourceManager getResourcesByExtensions:[NSArray arrayWithObjects:nil]];
        //availableMovies = [[ResourceManager getResourcesByExtensions:[NSArray arrayWithObjects:@"m4v", nil]] retain];
        styles = [[NSMutableDictionary alloc] init];
        NSArray* lines = [DataUtil fileLines:@"styles.txt"];
        for(NSString* line in lines) {
            if([line rangeOfString:@"="].location != NSNotFound) {
                NSArray* chunks = [line componentsSeparatedByString: @"="];
                NSString* key = [[chunks objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString* value = [[chunks objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [(NSMutableDictionary*)styles setObject:value forKey:key];
               // [(NSMutableDictionary*)styles setObject:[value lowercaseString] forKey:key];
            }
        }
        
        //  Get a list of image names packaged with the app, use this list to check an images existence, faster than checking on each image
        NSArray* a = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"./"];
        NSMutableDictionary* mutableAvailableImageNames = [NSMutableDictionary dictionary];
        for (NSString* imageName in a) {
            NSString* s = [imageName lastPathComponent];
            if([mutableAvailableImageNames objectForKey:s] == nil) {
                [mutableAvailableImageNames setObject:s forKey:s];
            }
        }
        availableImageNames = [NSDictionary dictionaryWithDictionary:mutableAvailableImageNames];
        mutableAvailableImageNames = nil;
//        NSMutableString* list = [NSMutableString string];
//        [list appendFormat:@"%d\n", [listOfImageNames count]];
//        for (NSString* imageName in listOfImageNames) {
//            [list appendFormat:@"%@\n", imageName];
//        }
//        DebugLog(list);

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

-(void)handleMemoryWarning:(NSNotification*)notification {
    DebugLog(@"Clearing ResourceManager caches.");
	[imageCache removeAllObjects];
	[styleCache removeAllObjects];
	[availableMusic removeAllObjects];
	[availableMovies removeAllObjects];
}

+(NSDictionary*)getResourcesByExtension:(NSString*)extension {
    return [ResourceManager getResourcesByExtensions:[NSArray arrayWithObjects:extension, nil]];
}

+(NSDictionary*)getResourcesByExtensions:(NSArray*)extensions {
	NSString* mainBundlePath = [[NSBundle mainBundle] bundlePath];
	NSError* dataError = nil;
	NSArray* dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:mainBundlePath error:&dataError];
	NSMutableDictionary* d = [[NSMutableDictionary alloc] init];
	for(NSString* fileName in dirContents) {
        for(NSString* ext in extensions) {
            if([fileName hasSuffix:ext]) {
                NSString* key = [[[fileName lastPathComponent] stringByDeletingPathExtension] lowercaseString];
                [d setObject:fileName forKey:key];
            }
        }
	}
    return d;
}

+(BOOL)resourceExists:(NSString*)name resourceType:(ResourceType)resourceType {
    switch (resourceType) {
        case STRING: {
            NSString* s = NSLocalizedString(name, name);
            if(![name isEqualToString:s]) {
                return YES;
            }
        }
        break;
        case IMAGE: {
            return [[ResourceManager sharedInstance].availableImageNames objectForKey:name] != nil;
//            if([[NSBundle mainBundle] pathForResource:name ofType:nil]) {
//                return YES;
//            }
        }
        break;
        case STYLE: {
            if([[ResourceManager sharedInstance].styles objectForKey:name] != nil) {
                return YES;
            }
        }
        break;
        case MOVIE: {
            if([[ResourceManager sharedInstance].availableMovies objectForKey:name] != nil) {
                return YES;
            }
        }
        break;
        case MUSIC: {
            if([[ResourceManager sharedInstance].availableMusic objectForKey:name] != nil) {
                return YES;
            }
        }
        break;
     }
    return NO;
}

+(UIColor*)getStyleColor:(NSString*)name withAttribute:(NSString*)attribute module:(NSString*)moduleName isPortrait:(BOOL)isPortrait {
    NSString* colorString = [ResourceManager getStyle:name withAttribute:attribute module:moduleName isPortrait:isPortrait];
    return [Color toUIColor:colorString];
}

+(NSArray*)getStyleArray:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait {
    NSString* arrayString = [ResourceManager getStyle:name module:moduleName isPortrait:isPortrait];
    NSString* trimedArrayString = [arrayString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray* chunks = [trimedArrayString componentsSeparatedByString: @","];
    return chunks;
}

+(CGPoint)getStyleXY:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait {
    NSString* pt = [ResourceManager getStyle:[NSString stringWithFormat:@"%@.xy", name] module:moduleName isPortrait:isPortrait];
    NSArray* chunks = [pt componentsSeparatedByString: @","];
    int x = [[chunks objectAtIndex:0] intValue];
    int y = [[chunks objectAtIndex:1] intValue];
    CGPoint p = CGPointMake(x, y);
    return p;
}

+(NSString*)getStyle:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait {
    NSString* cacheKey = [NSString stringWithFormat:@"%@%@%@", name, moduleName, isPortrait ? @"yes" : @"no"];
    NSString* cachedStyle = [[ResourceManager sharedInstance].styleCache objectForKey:cacheKey];
    if(cachedStyle != nil) {
        return cachedStyle;
    }
    ResourceName* resourceName = [ResourceName name:name withExtension:nil module:moduleName isPortrait:isPortrait];
    while([resourceName hasNext]) {
        NSString* s = [resourceName next];
        if([ResourceManager resourceExists:s resourceType:STYLE]) {
            NSString* style = [[ResourceManager sharedInstance].styles objectForKey:s];
            [[ResourceManager sharedInstance].styleCache setObject:style forKey:cacheKey];
            return style;
        }
    }
    DebugLog(@"'%@' No style definition found [%@].", name, [resourceName.names description]);
    return nil;
}

+(NSString*)getStyle:(NSString*)name withAttribute:(NSString*)attribute module:(NSString*)moduleName isPortrait:(BOOL)isPortrait {
    if(attribute == nil || attribute.length < 1) {
        return [ResourceManager getStyle:name module:moduleName isPortrait:isPortrait];
    }
    NSString* styleAndAttributeName = [NSString stringWithFormat:@"%@.%@", name, attribute];
    return [ResourceManager getStyle:styleAndAttributeName module:moduleName isPortrait:isPortrait];
}

+(CGRect)getStyleRect:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait {
    NSString* styleAndAttributeName = [NSString stringWithFormat:@"%@.rect", name];
    NSString* rectString = [ResourceManager getStyle:styleAndAttributeName module:moduleName isPortrait:isPortrait];
    NSArray* chunks = [rectString componentsSeparatedByString: @","];
    CGRect r = CGRectMake([[chunks objectAtIndex:0] intValue], [[chunks objectAtIndex:1] intValue], [[chunks objectAtIndex:2] intValue], [[chunks objectAtIndex:3] intValue]);
    return r;
}

+(NSString*)getLocalizedString:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait {
    ResourceName* resourceName = [ResourceName name:name withExtension:nil module:moduleName isPortrait:isPortrait];
    while([resourceName hasNext]) {
        NSString* s = [resourceName next];
        if([ResourceManager resourceExists:s resourceType:STRING]) {
            return NSLocalizedString(s, s);
        }
    }
    DebugLog(@"'%@' No localized string found [%@].", name, [resourceName.names description]);
    return @"No localized string found";
}

+(UIImage*)getImage:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait {
    BOOL useImageCache = NO;
    NSString* cacheKey;
    if(useImageCache) {
        cacheKey = [NSString stringWithFormat:@"%@%@%@", name, moduleName, isPortrait ? @"yes" : @"no"];
        UIImage* cachedImage = [[ResourceManager sharedInstance].imageCache objectForKey:cacheKey];
        if(cachedImage != nil) {
            return cachedImage;
        }
    }
    ResourceName* resourceName = [ResourceName name:name withExtension:@".png" module:moduleName isPortrait:isPortrait];
    while([resourceName hasNext]) {
        NSString* s = [resourceName next];
        if([ResourceManager resourceExists:s resourceType:IMAGE]) {
            //UIImage* i = [UIImage imageNamed:s];
            UIImage* i = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:s ofType:nil]];
            if(useImageCache) {
                [[ResourceManager sharedInstance].imageCache setObject:i forKey:cacheKey];
            }
            //DebugLog(@"Image found: '[%@/%@]'.", [NSBundle mainBundle].resourcePath,  s);
            return i;
        }
    }
    DebugLog(@"'%@' Image not found [%@].", name, [resourceName.names description]);
    return nil;
}

+(UIButton*)getImageButton:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait hasDownState:(BOOL)hasDownState {
	UIButton* b = [UIButton buttonWithType:UIButtonTypeCustom];
	b.adjustsImageWhenHighlighted = YES;
	b.adjustsImageWhenDisabled = NO;
	b.showsTouchWhenHighlighted = YES;
	b.reversesTitleShadowWhenHighlighted = NO;
    if(name == nil && moduleName == nil) {
        // name and moduleName equal to nil yields empty but functioning button
    } else {
        UIImage* image = [ResourceManager getImage:name module:moduleName isPortrait:isPortrait];
        [b setBackgroundImage:image forState:UIControlStateNormal];
        if(hasDownState) {
            NSString* downName = [NSString stringWithFormat:@"%@.down", name];
            image = [ResourceManager getImage:downName module:moduleName isPortrait:isPortrait];
            [b setBackgroundImage:image forState:UIControlStateHighlighted];
            [b setBackgroundImage:image forState:UIControlStateSelected];
        }
        b.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    }
    [ResourceManager applyStylesToButton:b name:@"default.button" module:nil isPortrait:isPortrait data:kNoData];
	return b;
}

+(UIButton*)getStretchImageButton:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait hasDownState:(BOOL)hasDownState {
	UIButton* b = [UIButton buttonWithType:UIButtonTypeCustom];
	b.adjustsImageWhenHighlighted = YES;
	b.adjustsImageWhenDisabled = YES;
	b.showsTouchWhenHighlighted = YES;
	b.reversesTitleShadowWhenHighlighted = YES;

	
    UIImage* image = [ResourceManager getImage:name module:moduleName isPortrait:isPortrait];
	UIImage* stretchableImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[b setBackgroundImage:stretchableImage forState:UIControlStateNormal];
    if(hasDownState) {
        NSString* downName = [NSString stringWithFormat:@"%@.down", name];
        image = [ResourceManager getImage:downName module:moduleName isPortrait:isPortrait];
        stretchableImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
        [b setBackgroundImage:stretchableImage forState:UIControlStateHighlighted];
        [b setBackgroundImage:stretchableImage forState:UIControlStateSelected];
    }
	b.frame = CGRectMake(0, 0, image.size.width, image.size.height);
	return b;
}

+(Music*)getMusic:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait {
    ResourceName* resourceName = [ResourceName name:name withExtension:nil module:moduleName isPortrait:isPortrait];
    while([resourceName hasNext]) {
        NSString* s = [resourceName next];
        if([ResourceManager resourceExists:s resourceType:MUSIC]) {
            Music* i = [[Music alloc] initWithFileName:[[ResourceManager sharedInstance].availableMusic objectForKey:s] ofType:nil];
            return i;
        }
    }
    DebugLog(@"'%@' Music not found [%@] in [%@].", name, [resourceName.names description], [ResourceManager sharedInstance].availableMusic);
    return nil;
}

+(MovieView*)getMovie:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait {
    ResourceName* resourceName = [ResourceName name:name withExtension:nil module:moduleName isPortrait:isPortrait];
    while([resourceName hasNext]) {
        NSString* s = [resourceName next];
        if([ResourceManager resourceExists:s resourceType:MOVIE]) {
            MovieView* i = [[MovieView alloc] initWithName:[[ResourceManager sharedInstance].availableMovies objectForKey:s] ofType:nil];
            return i;
        }
    }
    DebugLog(@"'%@' Movie not found [%@] in [%@].", name, [resourceName.names description], [ResourceManager sharedInstance].availableMovies);
    return nil;
}

+(UILabel*)getLabel:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait {
    return [ResourceManager getLabel:name module:moduleName isPortrait:isPortrait data:nil];
}

+(UILabel*)getLabel:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait data:(NSString*)data {
    UILabel* o = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
    [ResourceManager applyStylesToLabel:o name:@"default.label" module:nil isPortrait:isPortrait data:kNoData];
    [ResourceManager applyStylesToLabel:o name:name module:moduleName isPortrait:isPortrait data:data];
    return o;
}

+(UIFont*)getFont:(NSString*)fontName size:(NSString*)fontSize {
    UIFont* f = nil;
    @try {
        if([fontName isEqualToString:@"Copperplate"] && ![DeviceUtil osVersionSupported:@"5.0"] && ![DeviceUtil isPad]) {
            fontName = [ResourceManager getStyle:@"font.not" withAttribute:@"found" module:nil isPortrait:NO];
            if(fontName == nil) {
                fontName = @"Helvetica";
            }
        }
        f = [UIFont fontWithName:fontName size:[fontSize intValue]];
    }
    @catch (NSException *exception) {
        fontName = [ResourceManager getStyle:@"font.not" withAttribute:@"found" module:nil isPortrait:NO];
        if(fontName == nil) {
            fontName = @"Helvetica";
        }
        DebugLog(@"Unable to use font named '%@', using 'Helvetica' instead.", fontName);
        f = [UIFont fontWithName:fontName size:[fontSize intValue]];
    }

    return f;
}

+(void)applyStylesToLabel:(UILabel*)o name:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait data:(NSString*)data {
    [ResourceManager applyViewAttributes:o name:name module:moduleName isPortrait:isPortrait];

    NSString* fontName = [ResourceManager getStyle:name withAttribute:@"font" module:moduleName isPortrait:isPortrait];
    NSString* fontSize = [ResourceManager getStyle:name withAttribute:@"size" module:moduleName isPortrait:isPortrait];
    if(fontName != nil && fontSize != nil) {
        //o.font = [UIFont fontWithName:fontName size:[fontSize intValue]];
        o.font = [ResourceManager getFont:fontName size:fontSize];
    }
    o.textAlignment = [[ResourceManager getStyle:name withAttribute:@"alignment" module:moduleName isPortrait:isPortrait] intValue];
    NSString* color = [ResourceManager getStyle:name withAttribute:@"color" module:moduleName isPortrait:isPortrait];
    o.textColor = [Color toUIColor:color];
    if (data == nil) {
        o.text = [ResourceManager getLocalizedString:name module:moduleName isPortrait:isPortrait];
    } else {
        if(![kNoData isEqualToString:data]) {
            o.text = [ResourceManager getLocalizedString:data module:moduleName isPortrait:isPortrait];
        }
    }

    NSString* autosize = [ResourceManager getStyle:name withAttribute:@"autosize" module:moduleName isPortrait:isPortrait];
    o.adjustsFontSizeToFitWidth = [autosize intValue];
    NSString* px = [ResourceManager getStyle:name withAttribute:@"shadowoffsetx" module:moduleName isPortrait:isPortrait];
    NSString* py = [ResourceManager getStyle:name withAttribute:@"shadowoffsety" module:moduleName isPortrait:isPortrait];
    if(px != nil && py != nil) {
        o.shadowOffset = CGSizeMake([px intValue], [py intValue]);
    }
    NSString* shadowcolor = [ResourceManager getStyle:name withAttribute:@"shadowcolor" module:moduleName isPortrait:isPortrait];
    o.shadowColor = [Color toUIColor:shadowcolor];
}

+(void)applyStylesToButton:(UIButton*)o name:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait data:(NSString*)data {
    [ResourceManager applyStylesToLabel:(UILabel*)o.titleLabel name:name module:moduleName isPortrait:isPortrait data:data];
    NSString* color = [ResourceManager getStyle:name withAttribute:@"color" module:moduleName isPortrait:isPortrait];
    [o setTitleColor:[Color toUIColor:color] forState:UIControlStateNormal];
    NSString* shadowcolor = [ResourceManager getStyle:name withAttribute:@"shadowcolor" module:moduleName isPortrait:isPortrait];
    [o setTitleShadowColor:[Color toUIColor:shadowcolor] forState:UIControlStateNormal];
    if (data == nil) {
        [o setTitle:[ResourceManager getLocalizedString:name module:moduleName isPortrait:isPortrait] forState:UIControlStateNormal];
    } else {
        if(![kNoData isEqualToString:data]) {
            [o setTitle:[ResourceManager getLocalizedString:data module:moduleName isPortrait:isPortrait] forState:UIControlStateNormal];
        }
    }
}

+(UITextView*)getMultiLineLabel:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait data:(NSString*)data {
    //NSDate *startTime = [NSDate date];
    UITextView* o = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
    [ResourceManager applyViewAttributes:o name:name module:moduleName isPortrait:isPortrait];

    NSString* fontName = [ResourceManager getStyle:name withAttribute:@"font" module:moduleName isPortrait:isPortrait];
    NSString* fontSize = [ResourceManager getStyle:name withAttribute:@"size" module:moduleName isPortrait:isPortrait];
    if(fontName != nil && fontSize != nil) {
        //o.font = [UIFont fontWithName:fontName size:[fontSize intValue]];
        o.font = [ResourceManager getFont:fontName size:fontSize];
    }
    o.textAlignment = [[ResourceManager getStyle:name withAttribute:@"alignment" module:moduleName isPortrait:isPortrait] intValue];
    NSString* color = [ResourceManager getStyle:name withAttribute:@"color" module:moduleName isPortrait:isPortrait];
    o.textColor = [Color toUIColor:color];
    if (data == nil) {
        o.text = [ResourceManager getLocalizedString:name module:moduleName isPortrait:isPortrait];
    } else {
        if(![kNoData isEqualToString:data]) {
            o.text = [ResourceManager getLocalizedString:data module:moduleName isPortrait:isPortrait];
        }
    }

    NSString* editable = [ResourceManager getStyle:name withAttribute:@"editable" module:moduleName isPortrait:isPortrait];
    o.editable = [editable intValue];
    o.contentInset = UIEdgeInsetsMake(-4,-8,0,0);
    //DebugLog(@"getMultilineLabel() elapsed time: %f", -[startTime timeIntervalSinceNow]);
    return o;
}

+(UITextField*)getTextField:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait data:(NSString*)data {
    //NSDate *startTime = [NSDate date];
    UITextField* o = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
    [ResourceManager applyViewAttributes:o name:name module:moduleName isPortrait:isPortrait];
    
    NSString* fontName = [ResourceManager getStyle:name withAttribute:@"font" module:moduleName isPortrait:isPortrait];
    NSString* fontSize = [ResourceManager getStyle:name withAttribute:@"size" module:moduleName isPortrait:isPortrait];
    if(fontName != nil && fontSize != nil) {
        //o.font = [UIFont fontWithName:fontName size:[fontSize intValue]];
        o.font = [ResourceManager getFont:fontName size:fontSize];
    }
    o.textAlignment = [[ResourceManager getStyle:name withAttribute:@"alignment" module:moduleName isPortrait:isPortrait] intValue];
    NSString* color = [ResourceManager getStyle:name withAttribute:@"color" module:moduleName isPortrait:isPortrait];
    o.textColor = [Color toUIColor:color];
    if (data == nil) {
        o.text = [ResourceManager getLocalizedString:name module:moduleName isPortrait:isPortrait];
    } else {
        if(![kNoData isEqualToString:data]) {
            o.text = [ResourceManager getLocalizedString:data module:moduleName isPortrait:isPortrait];
        }
    }
    return o;
}

/*
    Method used by UILabel and UITextView but they do not share a common protocol so I tried using performSelector
    on UILabel/UITextView cast as an id but font size and alignment API require int args, wrapping in NSNumber
    didn't work, so this functionality is duplicated in applyStylesToLabel and getMultiLineLabel
*/
//+(void)applyTextAttributes:(id)o name:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait data:(NSString*)data {
//    NSString* fontName = [ResourceManager getStyle:name withAttribute:@"font" module:moduleName isPortrait:isPortrait];
//    NSString* fontSize = [ResourceManager getStyle:name withAttribute:@"size" module:moduleName isPortrait:isPortrait];
//    if(fontName != nil && fontSize != nil) {
//        [o performSelector:@selector(setFont:) withObject:[UIFont fontWithName:fontName size:[fontSize intValue]]];
//       // o.font = [UIFont fontWithName:fontName size:[fontSize intValue]];
//    }
//    NSString* alignment = [ResourceManager getStyle:name withAttribute:@"alignment" module:moduleName isPortrait:isPortrait];
//    [o performSelector:@selector(setTextAlignment:) withObject:[NSNumber numberWithInt:[alignment intValue]]];
//    //o.textAlignment = [alignment intValue];
//    NSString* color = [ResourceManager getStyle:name withAttribute:@"color" module:moduleName isPortrait:isPortrait];
//    [o performSelector:@selector(setTextColor:) withObject:[Color toUIColor:color]];
//    //o.textColor = [Color toUIColor:color];
//    if (data == nil) {
//        [o performSelector:@selector(setText:) withObject:[ResourceManager getLocalizedString:name module:moduleName isPortrait:isPortrait]];
//        //o.text = [ResourceManager getLocalizedString:name module:moduleName isPortrait:isPortrait];
//    } else {
//        if(![kNoData isEqualToString:data]) {
//            [o performSelector:@selector(setText:) withObject:[ResourceManager getLocalizedString:data module:moduleName isPortrait:isPortrait]];
//            //o.text = [ResourceManager getLocalizedString:data module:moduleName isPortrait:isPortrait];
//        }
//    }
//}

+(void)applyViewAttributes:(UIView*)o name:(NSString*)name module:(NSString*)moduleName isPortrait:(BOOL)isPortrait {
//    NSString* x = [ResourceManager getStyle:name withAttribute:@"x" module:moduleName isPortrait:isPortrait];
//    NSString* y = [ResourceManager getStyle:name withAttribute:@"y" module:moduleName isPortrait:isPortrait];
//    NSString* w = [ResourceManager getStyle:name withAttribute:@"width" module:moduleName isPortrait:isPortrait];
//    NSString* h = [ResourceManager getStyle:name withAttribute:@"height" module:moduleName isPortrait:isPortrait];
//    if(x != nil && y != nil && w != nil && h != nil) {
//        o.frame = CGRectMake([x intValue], [y intValue], [w intValue], [h intValue]);
//    }
    NSString* a = [ResourceManager getStyle:name withAttribute:@"alpha" module:moduleName isPortrait:isPortrait];
    o.alpha = [a floatValue];
    NSString* visible = [ResourceManager getStyle:name withAttribute:@"visible" module:moduleName isPortrait:isPortrait];
    BOOL vis = [visible intValue];
    [o setHidden:!vis];
    NSString* backgroundColor = [ResourceManager getStyle:name withAttribute:@"backgroundColor" module:moduleName isPortrait:isPortrait];
    o.backgroundColor = [Color toUIColor:backgroundColor];
}

+(void)centerMultiLineLabelVertically:(UITextView*)o {
    //  Center vertical alignment
    CGFloat topCorrect = ([o bounds].size.height - [o contentSize].height * [o zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    o.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

+(void)bottomAlignMultiLineLabel:(UITextView*)o {
    CGFloat topCorrect = ([o bounds].size.height - [o contentSize].height);
    topCorrect = (topCorrect <0.0 ? 0.0 : topCorrect);
    o.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

@end