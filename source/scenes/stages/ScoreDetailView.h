#import <UIKit/UIKit.h>

@interface ScoreDetailView : UIView

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *fastest;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *slowest;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *average;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *last;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *count;

@end
