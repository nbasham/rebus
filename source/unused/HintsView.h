#import "SceneView.h"
#import "RebusPlayState.h"

@interface HintsView : SceneView {
	BOOL loading;
    int hintAvailabilityTime;
	BOOL stopTimer;
    UIImageView* secondHandImageView;
    UIImage* availableBackgroundImage;
    UIImage* unavailableBackgroundImage;
    UIImageView* textImageView;
    UIImage* availableTextImage;
    UIImage* unavailableTextImage;
    UIImageView* frameImageView;
}

-(void)startTimer;
-(void)stopTimer;

@end
