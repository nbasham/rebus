#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Sound : NSObject {
	AVAudioPlayer* snd;
}

-(id)initWithName:(NSString*)name type:(NSString*)type;
-(id)initAiffWithName:(NSString*)name;
-(void)setPlayRate:(float)rate;
-(void)play;
-(void)pause;
-(void)stop;
-(float)getVolume;
-(void)setVolume:(float)volume;

@end
