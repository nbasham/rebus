#import "SimpleSoundManager.h"
#import "Settings.h"

@interface SimpleSoundManager()
    @property(nonatomic, strong) NSDictionary* availableSounds;
    @property(nonatomic, strong) NSMutableDictionary* cache;
    //@property(assign) BOOL soundOn;
    @property(assign) BOOL useCache;

	+(BOOL)exists:(NSString*)soundName;
	+(NSDictionary*)getAvailableSounds;
	+(BOOL)isLoaded:(NSString*)soundName;
	+(SystemSoundID)loadSound:(NSString*)soundName;
	-(void)handleMemoryWarning:(NSNotification*)notification;
	+(void)clearCache;
	-(void)listenForPlaySound:(NSNotification*)notification;
    -(void)playAfterDelay:(NSTimer*)timer;
	+(SimpleSoundManager*)sharedInstance;
@end

@implementation SimpleSoundManager

@synthesize availableSounds;
@synthesize cache;
//@synthesize soundOn;
@synthesize useCache;

+(SimpleSoundManager*)singleton {
    return [SimpleSoundManager sharedInstance];
}

+(SimpleSoundManager*)sharedInstance {
    static SimpleSoundManager* myInstance = nil;
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
    }
    return myInstance;
}

-(id)init {
    self = [super init];
	if (self) {
		//soundOn = YES;
        useCache = YES;
		availableSounds = [SimpleSoundManager getAvailableSounds];
		cache = [[NSMutableDictionary alloc] init];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenForPlaySound:) name:kPlaySound object:nil];
	}
	return self;
}

-(void)handleMemoryWarning:(NSNotification*)notification {
	[SimpleSoundManager clearCache];
}

-(void)listenForPlaySound:(NSNotification*)notification {
    if ([[notification name] isEqualToString:kPlaySound]) {
        NSString* soundName = [notification object];
		[SimpleSoundManager play:soundName];
    }
}

+(void)setUseCache:(BOOL)b {
    [SimpleSoundManager sharedInstance].useCache = b;
}

//+(BOOL)isSoundOn {
//    return [Settings;
//}
//
//+(void)setSoundOn:(BOOL)b {
//    [SimpleSoundManager sharedInstance].soundOn = b;
//}

+(void)play:(NSString*)soundName afterDelay:(float)delay {
    [NSTimer scheduledTimerWithTimeInterval:delay target:[SimpleSoundManager sharedInstance] selector:@selector(playAfterDelay:) userInfo:soundName repeats:NO];
}

-(void)playAfterDelay:(NSTimer*)timer {
    [SimpleSoundManager play:timer.userInfo];
}

+(void)playButton {
	[SimpleSoundManager play:@"button"];
}

//	case insensitive, use @"vibrate" for vibrate
+(void)play:(NSString*)soundName {
	if(![Settings getSoundOn]) {
		return;
	}
	
	NSString* lowercaseSoundName = [[[NSString stringWithString:soundName] lowercaseString] stringByDeletingPathExtension];
	if([lowercaseSoundName isEqualToString:@"vibrate"]) {
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
		return;
	}
    if(![SimpleSoundManager sharedInstance].useCache) {
		SystemSoundID snd = [self loadSound:lowercaseSoundName];
        AudioServicesPlaySystemSound(snd);
        return;
    }
    //  trim extension
	
	if(![SimpleSoundManager exists:lowercaseSoundName]) {
		DebugLog(@"Trying to play and sound ['%@'] that is not contained in main bundle ['%@']", soundName, [[SimpleSoundManager sharedInstance].availableSounds description]);
		return;
	}

	if(![self isLoaded:lowercaseSoundName]) {
		[self loadSound:lowercaseSoundName];
	}

	NSNumber* n = (NSNumber*)[[SimpleSoundManager sharedInstance].cache objectForKey:lowercaseSoundName];
	SystemSoundID snd = [n unsignedIntValue];
	AudioServicesPlaySystemSound(snd);
}

+(BOOL)exists:(NSString*)soundName {
	return [[SimpleSoundManager sharedInstance].availableSounds objectForKey:soundName] != nil;
}

+(NSDictionary*)getAvailableSounds {
	NSString* mainBundlePath = [[NSBundle mainBundle] bundlePath];
	NSError* dataError = nil;
	NSArray* dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:mainBundlePath error:&dataError];
	NSMutableDictionary* sounds = [[NSMutableDictionary alloc] init];
	for(NSString* fileName in dirContents) {
		if([fileName hasSuffix:@"caf"] || [fileName hasSuffix:@"wav"] || [fileName hasSuffix:@"aiff"] || [fileName hasSuffix:@"aif"]) {
			NSString* key = [[[fileName lastPathComponent] stringByDeletingPathExtension] lowercaseString];
			[sounds setObject:fileName forKey:key];
		}
	}
    return sounds;
}

+(BOOL)isLoaded:(NSString*)soundName {
	return [[SimpleSoundManager sharedInstance].cache objectForKey:soundName] != nil;
}

+(SystemSoundID)loadSound:(NSString*)soundName {
	NSString* soundFileName = [[SimpleSoundManager sharedInstance].availableSounds objectForKey:soundName];
	SystemSoundID sndObj;
    CFBundleRef mainBundle = CFBundleGetMainBundle();
	CFURLRef snd = CFBundleCopyResourceURL (mainBundle, (__bridge CFStringRef)soundFileName, NULL, NULL);
	OSStatus error = AudioServicesCreateSystemSoundID(snd, &sndObj);
	switch (error) {
		// from http://developer.apple.com/library/mac/#documentation/AudioToolbox/Reference/SystemSoundServicesReference/Reference/reference.html
		case kAudioServicesUnsupportedPropertyError:
			DebugLog(@"The property is not supported.");
			break;
		case kAudioServicesBadPropertySizeError:
			DebugLog(@"The size of the property data was not correct.");
			break;
		case kAudioServicesBadSpecifierSizeError:
			DebugLog(@"The size of the specifier data was not correct.");
			break;
		case kAudioServicesSystemSoundUnspecifiedError:
			DebugLog(@"An unspecified error has occurred.");
			break;
		case kAudioServicesSystemSoundClientTimedOutError:
			DebugLog(@"System sound client message timed out.");
			break;
	}
    if([SimpleSoundManager sharedInstance].useCache) {
        [[SimpleSoundManager sharedInstance].cache setObject:[NSNumber numberWithInt:sndObj] forKey:soundName];
    }
    CFRelease (snd);
    return sndObj;
}

+(void)clearCache {
    id o;
    NSEnumerator* cacheDictIterator = [[SimpleSoundManager sharedInstance].cache objectEnumerator];
    while((o = [cacheDictIterator nextObject])) {
        NSNumber* n = (NSNumber*)o;
        SystemSoundID snd = [n unsignedIntValue];
        AudioServicesDisposeSystemSoundID(snd);
    }
	[[SimpleSoundManager sharedInstance].cache removeAllObjects];
}

-(void)dealloc {
	[SimpleSoundManager clearCache];
}

@end
