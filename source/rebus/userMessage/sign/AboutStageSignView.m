#import "AboutStageSignView.h"
#import "Products.h"
#import "AlertUtil.h"
#import "SceneViewController.h"
#import "UsageTracking.h"
#import "UIDeviceHardware.h"
#import "StringUtil.h"
#import "RebusGlobals.h"

@interface AboutStageSignView()
-(void)contactUs;
@end

@implementation AboutStageSignView

- (id)init {
    self = [super init];
    if (self) {
        self.name = @"about";
    }
    return self;
}

-(void)beforeShowAnimation {
    [super beforeShowAnimation];
    [super addImage:@"sign"];

    UIButton* b = [ResourceManager getImageButton:@"button" module:@"stage.manager.sign.about" isPortrait:NO hasDownState:YES];
    [b addTarget:self action:@selector(contactUs) forControlEvents:UIControlEventTouchUpInside];
    [layoutManager addView:b withKey:@"about.button" position:XY];

    CGRect webRect = [ResourceManager getStyleRect:@"webview" module:@"stage.about" isPortrait:NO];
    webView = [[UIWebView alloc] initWithFrame:webRect];
    webView.backgroundColor = [UIColor clearColor];
    [webView setOpaque:NO];
    NSString* htmlFileName = [DeviceUtil isPad] ? @"about.pad" : @"about.phone";
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:htmlFileName ofType:@"html"] isDirectory:NO]]];
    webView.delegate = self;	
    [self addSubview:webView];
}

-(void)hideAnimationComplete {
    [super hideAnimationComplete];
    webView = nil;
}

-(void)contactUs {
	[SimpleSoundManager playButton];
    SceneViewController* vc = (SceneViewController*)appDelegate.navigationController.topViewController;
    NSString* productName = [RebusGlobals getProductName];
    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString* subject = [NSString stringWithFormat:@"%@ %@", productName, version];

    
    NSString* device = [UIDeviceHardware deviceName];
    NSString* systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString* uid = @"";
    NSString* emailBody = NSLocalizedString(@"about.contactus.email.body", @"about.contactus.email.body");
    NSString* body = [NSString stringWithFormat:emailBody, device, systemVersion, uid];
    [UsageTracking trackEvent:@"touch" action:@"conatct.us" label:nil value:-1];
    [vc sendEmailTo:@"puzzlepleasure@gmail.com" withSubject:subject withBody:body withImage:nil];
}

//  causes links in the page to open Safari vs. opening in webview
-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if (inType == UIWebViewNavigationTypeLinkClicked) {
        [SimpleSoundManager playButton];
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        NSString* url = [[inRequest URL] description];
        if(-1 != [StringUtil indexOf:@"robin.web" inString:url]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://kadencecreative.com/"]];
            [UsageTracking trackEvent:@"touch" action:@"robin.web" label:nil value:-1];
        } else if ([[[inRequest URL] scheme] isEqual:@"mailto"]) {
            SceneViewController* vc = (SceneViewController*)appDelegate.navigationController.topViewController;
            [UsageTracking trackEvent:@"touch" action:@"robin.email" label:nil value:-1];
            NSString* product = [Products getProductName];
            [vc sendEmailTo:@"robin@kadencecreative.com" withSubject:product withBody:@"" withImage:nil];
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewParam {
    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	NSString* jsCommand = [NSString stringWithFormat:@"setVersion('%@');", version];
	[webViewParam stringByEvaluatingJavaScriptFromString:jsCommand];
    if([RebusGlobals isFreeApp]) {
        [webViewParam stringByEvaluatingJavaScriptFromString:@"appendFreeToTitle();"];
    }
}

@end
