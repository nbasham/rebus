#import "SceneView.h"

@implementation SceneView

@synthesize name;

-(id)initWithFrame:(CGRect)r name:(NSString*)n {
    self = [super initWithFrame:r];
    if (self) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        self.name = n;
        self.autoresizesSubviews = NO;
        layoutManager = [[LayoutManager alloc] initWithParent:self moduleName:name];
        self.backgroundColor = [UIColor clearColor];
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *v = [super hitTest:point withEvent:event];
//    DebugLog(@"%@ userInteractionEnabled = %d subviews count = %d", self.name, self.userInteractionEnabled, [self.subviews count]);
//    DebugLog(@"subviews count = %d", [self.subviews count]);
//    for (UIView* o in self.subviews) {
//        DebugLog(@"%@  %d",[o description], o.userInteractionEnabled);
//    }
//    return v;
//}

-(UIImageView*)addBackground {
    NSString* key = [NSString stringWithFormat:@"%@.background", name];
    UIImageView* backgroundImageView = [layoutManager createBackgroundImageViewWithKey:key parent:self];
    self.frame = backgroundImageView.frame;
    backgroundImageView.userInteractionEnabled = NO;
    return backgroundImageView;
}

-(void)enterScene {
}

-(void)exitScene {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //DebugLog(@"exitScene:%@", name);
    [layoutManager clear];
    layoutManager = nil;
    name = nil;
}

-(void)removeFromSuperview {
    [super removeFromSuperview];
    //DebugLog(@"name: %@", name);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)layoutSubviews {
    [layoutManager layout:NO];
}

-(NSString*)description {
    return name;
}

@end
