#import "LessonStageSignView.h"

@interface LessonStageSignView()
@end

@implementation LessonStageSignView

@synthesize lessonIndex;

- (id)init {
    self = [super init];
    if (self) {
        self.name = @"lesson";
    }
    return self;
}

-(void)beforeShowAnimation {
    [super beforeShowAnimation];
    [super addImage:@"sign"];
    [super dismissOnTouch];
    
    NSString* imageName = [NSString stringWithFormat:@"lesson.%d", lessonIndex];
    UIImage* i = [ResourceManager getImage:imageName module:@"stage.manager.sign" isPortrait:NO];
    assert( i != nil );
    UIImageView* v = [[UIImageView alloc] initWithImage:i];
    [layoutManager addView:v withKey:imageName position:NONE];
    
    UIButton* b = [ResourceManager getImageButton:@"button" module:@"stage.manager.sign" isPortrait:NO hasDownState:YES];
    [ResourceManager applyStylesToButton:b name:@"button" module:@"stage.manager.sign" isPortrait:NO data:@"stage.manager.sign.lesson.button.label"];
    [layoutManager addView:b withKey:@"lesson.button" position:XY];
}

-(void)hide {
    [SimpleSoundManager playButton];
    [super hide];
}

-(void)hideAnimationComplete {
    [super hideAnimationComplete];
    //NSLog(@"LessonStageSignView.hideAnimationComplete");
}

@end
