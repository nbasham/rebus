#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>

/*
 SimpleSoundManager lets you very simply play short sound files. It is based on Apple's AudioServices
 which carries with it a few restrictions.
	Sound files must be:
		- No longer than 30 seconds in duration
		- In linear PCM or IMA4 (IMA/ADPCM) format
		- Packaged in a .caf, .aif, .aiff, or .wav file
	In addition, when you use the AudioServicesPlaySystemSound function:
		- Sounds play at the current system audio volume, with no programmatic volume control available
		- Sounds play immediately
		- Looping and stereo positioning are unavailable
		- Simultaneous playback is unavailable: You can play only one sound at a time.

 Added value:
	- AudioServices is wrapped with a simple API
	- control with events and/or API
	- sound names are case insensitive
	- finds all useable sounds in main bundle
	- if requested sound doesn't exist a warning is issued including a list of existing sounds
	- lazy loading
	- played sounds are cached
	- switch to turn sounds on/off
	- low memory event clears cache
 
 API
	[SimpleSoundManager setSoundOn:YES];
	[SimpleSoundManager play:@"vibrate];
	[SimpleSoundManager play:@"tink];	// for Tink.aif or tINk.caf or TINK.wAv
	[[NSNotificationCenter defaultCenter] postNotificationName:kPlaySound object:@"tInK"];
 
 CONVERSION:
    http://www.devdaily.com/mac-os-x/convert-caf-sound-file-aif-aiff-mp3-format
    afconvert -f caff -d LEI16 slide.mp3 slide.caf
 
 Notes:
    - Design descision: non case sensitive naming precludes use of both mySound.caf and MySound.caf, sound loaded last will be used
    - Design descision: mySound.wav and mySound.caf are both stored as mysound, sound loaded last will be used
	- Ran with NSZombieEnabled
	- damaged files don't crash [no sound is played]
	- *Ran with Leaks and got a leak when multi-tasking. Internet says use .caf to avoid known .aiff issue.
		Converting files via terminal:	afconvert -f caff -d ima4 input.wav output.caf
		See http://webbuilders.wordpress.com/2009/07/06/935/
 
 */

#define kPlaySound @"kPlaySound"

@interface SimpleSoundManager : NSObject {
	@private NSDictionary* availableSounds;
	@private NSMutableDictionary* cache;
    //@private BOOL soundOn;
    @private BOOL useCache;
}

//  API
//+(BOOL)isSoundOn;
//+(void)setSoundOn:(BOOL)b;
+(void)play:(NSString*)soundName;
+(void)play:(NSString*)soundName afterDelay:(float)delay;
+(void)playButton;
+(void)setUseCache:(BOOL)b;

@end
