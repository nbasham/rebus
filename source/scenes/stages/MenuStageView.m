#import "MenuStageView.h"
#import "MovieView.h"

@interface MenuStageView()
-(void)playMovie;
@end


@implementation MenuStageView

-(id)initWithStageName:(NSString*)name {
    self = [super initWithStageName:name];
    if (self) {
//        debugPuzzleIndex = [[UITextView alloc] initWithFrame:CGRectMake(120, 120, 40, 30)];
//        debugPuzzleIndex.delegate = self;
//        [debugPuzzleIndex setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
//        [self addSubview:debugPuzzleIndex];
    }
    return self;
}

-(void)enterScene {
//    [self performSelectorOnMainThread:@selector(playMovie) withObject:nil waitUntilDone:false];
}

-(void)playMovie {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"m4v"];
    NSURL* url = [NSURL fileURLWithPath:path];
    MPMoviePlayerController* player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    player.view.frame = CGRectMake(0, 0, 480, 272);
    player.controlStyle = MPMovieControlStyleNone;
    player.scalingMode = MPMovieScalingModeNone;
	[player play];       
    [self addSubview:player.view];
//    MovieView* movieView = [[MovieView alloc] initWithFrame:CGRectMake(0, 0, 480, 272) fileName:@"test" ofType:@"m4v"];
//    [self addSubview:movieView]; 
//    [movieView playLoop];
}

- (void)textViewDidChange:(UITextView *)textView {
//    [DataUtil setInt:[debugPuzzleIndex.text intValue] withKey:@"temp.puzzle.index"];
}

@end
