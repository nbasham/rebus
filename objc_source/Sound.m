#import "Sound.h"

@implementation Sound

-(id)initWithName:(NSString*)name type:(NSString*)type {
    self = [super init];
    if (self) {
        snd = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:type]] error:NULL];
        if([DeviceUtil osVersionSupported:@"5.0"]) {
            [snd enableRate];
        }
        [snd prepareToPlay];
        snd.numberOfLoops = 1;
    }
    return self;
}

-(id)initAiffWithName:(NSString*)name {
    return [[Sound alloc] initWithName:name type:@"aiff"];
}

-(void)setPlayRate:(float)rate {
    if([DeviceUtil osVersionSupported:@"5.0"]) {
        snd.rate = rate;
    }
}

-(void)play {
	[snd play];       
}

-(void)pause {
	[snd pause];       
}

-(void)stop {
	[snd stop];       
}

-(float)getVolume {
    return snd.volume;
}

-(void)setVolume:(float)volume {
	snd.volume = volume;
}

@end
