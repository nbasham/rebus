#import "AnswerCell.h"
#import "AppDelegate.h"

@interface AnswerCell()
-(UIImage*)imageForChar:(char)c isCorrect:(BOOL)isCorrect;
-(void)handleButtonTouch:(UIButton*)sender;
@end

@implementation AnswerCell

-(id)initWithIndex:(int)index {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        cellIndex = index;
        AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        answerPlayState = [appDelegate.rebusPlayState getViewStateAtIndex:cellIndex];
        UIImage* image = [self imageForChar:[answerPlayState getValue] isCorrect:YES];
        self.frameSize = image.size;
        imageHeight = image.size.height;
        
        UIImage* stripImage = [ResourceManager getImage:@"letter.animation" module:@"keyboard.answer" isPortrait:NO];
        stripImageView = [[UIImageView alloc] initWithImage:stripImage];
        [stripImageView setHidden:YES];
        [self addSubview:stripImageView];
        
        imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:imageView];

        self.clipsToBounds = YES;
        lastChar = 'a';

        UIButton* o = [UIButton buttonWithType:UIButtonTypeCustom];
        [o addTarget:self action:@selector(handleButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        o.frame = self.frame;
        [self addSubview:o];
        //  http://www.freesound.org/search/?q=rachet
        spinningSound = [[Sound alloc] initWithName:@"spinning" type:@"caf"];
        //spinningSound.volume = 0.5;
    }
    return self;
}

-(NSString*)description {
	NSMutableString* s = [NSMutableString string];
    [s appendString:@"\n"];
	[s appendString:[super description]];
	[s appendFormat:@"cellIndex: %d\n", cellIndex];
	[s appendFormat:@"ps value: '%@'\n", [answerPlayState getStringValue]];
	[s appendFormat:@"imageHeight: %d\n", imageHeight];
	[s appendFormat:@"lastChar: '%c'\n", lastChar];
    [s appendString:@"\n"];
	return s;
}

-(void)clear {
    stripImageView = nil;
    tempImageView = nil;
    imageView = nil;
    spinningSound = nil;
    spinningSound = nil;
}

-(void)setChar:(char)c isCorrect:(BOOL)isCorrect {
    if(lastChar == 'a' && c == 'a') {
        stripImageView.frameBottom = 0;
        [stripImageView setHidden:NO];
        if([Settings getSoundOn]) {
            [spinningSound setPlayRate:0.01];
            [spinningSound play];
        }
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            imageView.frameY = imageHeight;
            stripImageView.frameBottom = imageHeight;
        }completion:^(BOOL finished){
            [spinningSound stop];       
            [stripImageView setHidden:YES];
            [imageView setImage:[self imageForChar:c isCorrect:isCorrect]];
            imageView.frameY = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateSelectionEvent object:nil];
        }];
    } else {
        int endIndex = 'z' - c;
        int startIndex = 'z' - lastChar;
        int initY = imageHeight * startIndex * -1;
        int destY = imageHeight * endIndex * -1;
        stripImageView.frameY = initY;
        [stripImageView setHidden:NO];
        [imageView setHidden:YES];
        float duration = MAX(.5, .1 * (abs(destY - initY) / 100));
        if([Settings getSoundOn]) {
            [spinningSound setPlayRate:1.0 + duration - 0.5];
            [spinningSound play];
        }
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            stripImageView.frameY = destY;
        }completion:^(BOOL finished){
            [spinningSound stop];       
            [stripImageView setHidden:YES];
            [imageView setImage:[self imageForChar:c isCorrect:isCorrect]];
            [imageView setHidden:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateSelectionEvent object:nil];
        }];
    }
    lastChar = c;
}

-(UIImage*)imageForChar:(char)c isCorrect:(BOOL)isCorrect {
    UIImage* i;
    if(c == ' ') {
        i = [ResourceManager getImage:@"space" module:@"answer" isPortrait:NO];
        return i;
    } else if(c == '_') {
        int randIndex = abs(arc4random()) % 6 + 1;
        i = [ResourceManager getImage:[NSString stringWithFormat:@"blank.%d", randIndex] module:@"answer" isPortrait:NO];
        return i;
    }
    BOOL showIncorrectGuess = [Settings getShowIncorrect];
    if(!isCorrect && showIncorrectGuess) {
        [SimpleSoundManager play:@"incorrect"];
    }
    NSString* s = isCorrect || !showIncorrectGuess ? [NSString stringWithFormat:@"%c", c] : [NSString stringWithFormat:@"incorrect.%c", c];
    i = [ResourceManager getImage:s module:@"answer" isPortrait:NO];
    return i;
}

-(void)handleButtonTouch:(UIButton*)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAnswerTouchEvent object:[NSNumber numberWithInt:cellIndex]];
}

@end
