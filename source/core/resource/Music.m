#import "Music.h"
#import "Settings.h"

@interface Music(Private)
-(NSString*)lastURLComponent:(NSURL*)url;
//-(void)fadeOut:(AVAudioPlayer*)p;
@end

@implementation Music

-(id)initWithFileName:(NSString*)fileName ofType:(NSString*)type {
    self = [super init];
    if (self) {
        [self setSoundFileName:fileName ofType:type];
	}
    return self;
}

-(NSString*)lastURLComponent:(NSURL*)url {
    if([DeviceUtil osVersionSupported:@"4.0"]) {
        return [url lastPathComponent];
    } else {
        NSString* urlStr = [url absoluteString];
        return [urlStr lastPathComponent];
    }
}

-(void)setSoundFileName:(NSString*)fileName ofType:(NSString*)type {
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    //DebugLog(path);
    if(path != nil) {
        NSURL* url = [NSURL fileURLWithPath:path];
        if(player != nil) {
            if([[self lastURLComponent:url] isEqualToString:[self lastURLComponent:player.url]]) {
                //DebugLog(@"%@ already set.", [url lastPathComponent]);
                return;
            }
        }
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];   
        player.delegate = self;
        [player prepareToPlay];
    }
}

-(BOOL)isPlaying {
    if(player != nil) {
        return player.isPlaying;
    }
    return NO;
}

-(void)play {
    player.numberOfLoops = -1;
	[player play];       
}

-(void)playOnce {
    player.numberOfLoops = 0;
	[player play];       
}

-(void)playThisManyTimes:(int)numTimes {
    player.numberOfLoops = numTimes;
	[player play];       
}

-(void)pause {
	[player pause];       
}

-(void)stop {
	[player stop];       
}

//-(float)getVolume {
//    return player.volume;
//}
//
//-(void)setVolume:(float)volume {
//	player.volume = volume;
//}

-(void)setAugmentedVolume {
	player.volume = [Settings getMusicVolume] * 0.25;
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    //DebugLog(@"audioPlayerBeginInterruption");
}

/* audioPlayerEndInterruption:withFlags: is called when the audio session interruption has ended and this player had been interrupted while playing. */
/* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags {
    //DebugLog(@"audioPlayerEndInterruption");
}


/* audioPlayerEndInterruption: is called when the preferred method, audioPlayerEndInterruption:withFlags:, is not implemented. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
    //DebugLog(@"audioPlayerEndInterruption");
}

//-(void)fadeOut:(AVAudioPlayer*)p {
//    DebugLog(@".");
//    p.volume -= .01;
//}
//
//-(void)fadeOutVolume {
//    float delay = 0.1;
//    float f = player.volume / 0.1;
//    int iterations = (f + 0.5f);
//    for (int i = 0; i < iterations; i++) {
//        DebugLog(@".");
//        [self performSelector:@selector(fadeOut:) withObject:player afterDelay:0.1];
//        delay += 0.1;
//    }
//}

@end
