#import "MovieView.h"

@implementation MovieView

@synthesize player;

-(id)initWithName:(NSString*)fileName ofType:(NSString*)type {
    self = [super initWithFrame:CGRectZero];
    if (self) {
		NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
        NSArray* a = [path componentsSeparatedByString:@"/"];
        for (NSString* s in a) {
            DebugLog(s);
        }
		NSURL* url = [NSURL fileURLWithPath:path]; //   NEB removed retain without retesting
        a = [url pathComponents];
        for (NSString* s in a) {
            DebugLog(s);
        }
		self.player = [[MPMoviePlayerController alloc] initWithContentURL:url];
        [self.player prepareToPlay];       
		//player.view.frame = CGRectOffset(r, -r.origin.x, -r.origin.y);
		player.controlStyle = MPMovieControlStyleNone;
//		player.scalingMode = MPMovieScalingModeNone;
        self.frame = CGRectMake(0, 0, player.naturalSize.width, player.naturalSize.height);
        [player.view setFrame:self.bounds];
		[self addSubview:player.view];
        DebugLog(fileName);
        DebugRect(self.frame);
	}
    return self;
}

-(void)play {
    [self.player prepareToPlay];       
	player.repeatMode = MPMovieRepeatModeNone;
	[player play];       
}

-(void)playLoop {
    [self.player prepareToPlay];       
	player.repeatMode = MPMovieRepeatModeOne;
	[player play];       
}

-(void)pause {
	[player pause];       
}

-(void)stop {
	[player stop];       
}

@end
