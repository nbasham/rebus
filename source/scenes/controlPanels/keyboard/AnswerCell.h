#import <UIKit/UIKit.h>
#import "RebusAnswerPlayState.h"
#import "Sound.h"

@interface AnswerCell : UIView {
    UIImageView* stripImageView;
    UIImageView* tempImageView;
    UIImageView* imageView;
    RebusAnswerPlayState* answerPlayState;
    int imageHeight;
    int cellIndex;
    char lastChar;
	Sound* spinningSound;
}

-(id)initWithIndex:(int)i;
-(void)setChar:(char)c isCorrect:(BOOL)isCorrect;
-(void)clear;

@end
