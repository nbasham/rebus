#import "Settings.h"
#import "DataUtil.h"
#import "UsageTracking.h"

@interface Settings()
    @property(nonatomic, assign) BOOL soundOn;
    @property(nonatomic, assign) BOOL showIncorrect;
    @property(nonatomic, assign) BOOL showTimer;
    @property(nonatomic, assign) BOOL usageTracking;
    @property(nonatomic, assign) float musicVolume;

    +(Settings*)global;
@end

#define kSoundOnDefault YES
#define kSound @"sound.on"
#define kShowIncorrectDefault YES
#define kShowIncorrect @"show.incorrect"
#define kShowTimerDefault YES
#define kShowTimer @"show.timer"
#define kUsageTrackingDefault YES
#define kUsageTracking @"tracking.on"
#define kMusicVolume @"music.volume"
#define kMusicVolumeDefault 0.5

@implementation Settings

@synthesize soundOn;
@synthesize showIncorrect;
@synthesize showTimer;
@synthesize usageTracking;
@synthesize musicVolume;

+(Settings*)global {
    static Settings* myInstance = nil;
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        if([DataUtil keyUndefined:kSound]) {
            myInstance.soundOn = kSoundOnDefault;
        } else {
            myInstance.soundOn = [DataUtil getBoolWithKey:kSound];
        }
        if([DataUtil keyUndefined:kShowIncorrect]) {
            myInstance.showIncorrect = kShowIncorrectDefault;
        } else {
            myInstance.showIncorrect = [DataUtil getBoolWithKey:kShowIncorrect];
        }
        if([DataUtil keyUndefined:kShowTimer]) {
            myInstance.showTimer = kShowTimerDefault;
        } else {
            myInstance.showTimer = [DataUtil getBoolWithKey:kShowTimer];
        }
        if([DataUtil keyUndefined:kUsageTracking]) {
            myInstance.usageTracking = kUsageTrackingDefault;
        } else {
            myInstance.usageTracking = [DataUtil getBoolWithKey:kUsageTracking];
        }
        if([DataUtil keyUndefined:kMusicVolume]) {
            myInstance.musicVolume = kMusicVolumeDefault;
        } else {
            myInstance.musicVolume = [DataUtil getFloatWithKey:kMusicVolume];
        }
    }
    return myInstance;
}

//  These are set in the Settngs module which is defined by a configuration and thus sets
//  values based on a key and then propogates this event with that key, this is in lieu of their setters
-(void)listenForSettingsChanges:(NSNotification*)notification {
    if ([[notification name] isEqualToString:kSound]) {
        soundOn = [DataUtil getBoolWithKey:kSound];
        [UsageTracking trackEvent:@"settings" action:[notification name] label:nil value:soundOn];
    } else if ([[notification name] isEqualToString:kShowIncorrect]) {
        showIncorrect = [DataUtil getBoolWithKey:kShowIncorrect];
        [UsageTracking trackEvent:@"settings" action:[notification name] label:nil value:showIncorrect];
    } else if ([[notification name] isEqualToString:kShowTimer]) {
        showTimer = [DataUtil getBoolWithKey:kShowTimer];
        [UsageTracking trackEvent:@"settings" action:[notification name] label:nil value:showTimer];
    } else if ([[notification name] isEqualToString:kUsageTracking]) {
        usageTracking = [DataUtil getBoolWithKey:kUsageTracking];
        [UsageTracking trackEvent:@"settings" action:[notification name] label:nil value:usageTracking];
    } else if ([[notification name] isEqualToString:kMusicVolume]) {
        musicVolume = [DataUtil getFloatWithKey:kMusicVolume];
        [UsageTracking trackEvent:@"settings" action:[notification name] label:nil value:musicVolume * 100.0];
    }
}

-(id)init {
    self = [super init];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenForSettingsChanges:) name:nil object:nil];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
}

+(BOOL)getSoundOn {
    return [[Settings global] soundOn];
}

+(BOOL)getShowIncorrect {
    return [[Settings global] showIncorrect];
}

+(BOOL)getShowTimer {
    return [[Settings global] showTimer];
}

+(BOOL)getUsageTracking {
    return [[Settings global] usageTracking];
}

+(float)getMusicVolume {
    return [[Settings global] musicVolume];
}

@end
