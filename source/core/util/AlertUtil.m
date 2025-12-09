#import "AlertUtil.h"
#import "ResourceManager.h"

@implementation AlertUtil

+(void)showOKAlert:(NSString*)message {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

+(void)showLocalizedOKAlert:(NSString*)messageKey {
    NSString* message = [ResourceManager getLocalizedString:messageKey module:nil isPortrait:NO];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
