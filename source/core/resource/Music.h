#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Music : NSObject<AVAudioPlayerDelegate> {
	AVAudioPlayer* player;
}

-(id)initWithFileName:(NSString*)fileName ofType:(NSString*)type;
-(void)setSoundFileName:(NSString*)fileName ofType:(NSString*)type;
-(void)play;
-(BOOL)isPlaying;
-(void)playOnce;
-(void)playThisManyTimes:(int)numTimes;
-(void)pause;
-(void)stop;
/* The volume for the sound. The nominal range is from 0.0 to 1.0. */
//-(float)getVolume;
//-(void)setVolume:(float)volume;

//  Music quality is better if recorded at a higher volume, so we programatically
//  reduce the volume behind the user's back
-(void)setAugmentedVolume;
@end
