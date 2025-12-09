#import "ControlPanelView.h"
#import "RatingView.h"
#import "Music.h"
#import "AppStoreRatingRequest.h"

@interface SolvedControlPanelView : ControlPanelView/*<RatingViewDelegate>*/ {
    RatingView* ratingView;
    Music* clapping;
    AppStoreRatingRequest* appStoreRatingRequest;
}

@end
