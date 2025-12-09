#import "SignView.h"

@implementation SignView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        layoutManager = [[LayoutManager alloc] initWithParent:self moduleName:@"stage.manager.sign"];
        UIImage* i = [ResourceManager getImage:@"sign" module:@"stage.manager" isPortrait:NO];
        assert( i != nil );
        CGRect r = CGRectMake(0, 0, i.size.width, i.size.height);
        
        self.frame = r;
        
        signImageView = [[UIImageView alloc] initWithImage:i];
        [self addSubview:signImageView];
        
        signMessageImageView = [[UIImageView alloc] initWithFrame:r];
        [self addSubview:signMessageImageView];
    }
    return self;
}

-(void)show:(id<SignDelegate>)delegate {
    [layoutManager addView:signImageView withKey:@"background" position:NONE];
    [layoutManager addView:signMessageImageView withKey:@"message" position:NONE];
    [delegate addAdditionalSignSubviews:layoutManager];
    NSString* imageName = [NSString stringWithFormat:@"stage.manager.sign.%@.pad.png", delegate.name];
    [signMessageImageView setImage:[UIImage imageNamed:imageName]];
    [layoutManager layout:NO];
}

-(void)hide {
    [layoutManager clear];
}

@end
