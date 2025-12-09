#import "HelpView.h"

@interface HelpView()
@end

@implementation HelpView

-(id)initWithFrame:(CGRect)f name:(NSString*)n {
    self = [super initWithFrame:f name:n];
    if (self) {
        [super addBackground];
    }
    return self;
}

-(void)enterScene {
    [super enterScene];
}

-(void)exitScene {
    [super exitScene];
}

@end
