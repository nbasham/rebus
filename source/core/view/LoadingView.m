#import "LoadingView.h"
#import "ResourceManager.h"

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = NO;
        self.backgroundColor = [ResourceManager getStyleColor:@"loading.view" withAttribute:@"backgroundcolor" module:nil isPortrait:NO];
        self.alpha = CGColorGetAlpha(self.backgroundColor.CGColor);
        
        loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:loadingSpinner];
        
        messageLabel = [ResourceManager getLabel:@"loading.message" module:nil isPortrait:NO data:kNoData];
        [self addSubview:messageLabel];
    }
    return self;
}

-(void)show {
    [self showWithMessage:nil];
}

-(void)showWithMessage:(NSString*)messageKey {
    loadingSpinner.center = self.center;
    if(messageKey == nil) {
        messageLabel.text = @"";
    } else {
        messageLabel.text = [ResourceManager getLocalizedString:messageKey module:nil isPortrait:NO];
        messageLabel.frame = CGRectMake(0, loadingSpinner.frame.origin.y + 32, self.frame.size.width, 32);
    }
    [self setHidden:NO];
    [loadingSpinner startAnimating];
}

-(void)hide {
    [loadingSpinner stopAnimating];
    [self setHidden:YES];
}

@end
