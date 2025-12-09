#import <Foundation/Foundation.h>
#import "ModalMessageViewDelegate.h"

@interface HelpMovieModalMessageViewDelegate : NSObject<ModalMessageViewDelegate> {
    MPMoviePlayerController* player;
    float musicVolume;
}

@end
