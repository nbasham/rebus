#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

/*
 Call these from view controller
 
 animationView = [ResourceManager getMovie:@"animation" module:moduleName isPortrait:NO];
 [self.view addSubview:animationView];
 
 -(void)viewWillAppear:(BOOL)animated {
 	[super viewWillAppear:animated];
 	[animationView playLoop];
 }
 
 -(void)viewWillDisappear:(BOOL)animated {
 	[animationView stop];
 }

 -(void)layout:(BOOL)isPortrait {
    animationView.frame = [ResourceManager getStyleRect:@"animation" module:moduleName isPortrait:isPortrait];
 }

 */
@interface MovieView : UIView

@property(nonatomic, strong) MPMoviePlayerController* player;
-(id)initWithName:(NSString*)fileName ofType:(NSString*)type;
-(void)play;
-(void)playLoop;
-(void)pause;
-(void)stop;

@end
