#import "NavigationUtil.h"
#import "AbstractViewController.h"
#import "ClassUtil.h"
#import "AppDelegate.h"

@implementation NavigationUtil

+(void)navigateTo:(NSString*)key data:(id)data animated:(BOOL)animated {
    Class appViewControllerClass = [ClassUtil getMostSpecificClassOfType:@"ViewController" forModule:key];
    AbstractViewController* vc = [[appViewControllerClass alloc] initWithModuleName:key data:data];
    [vc.appDelegate.navigationController pushViewController:vc animated:animated];
    //    DebugLog(@"navigateTo: %@", [delegate.navigationController.viewControllers description]);
}

+(void)navigateBack:(BOOL)animated {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	/*UIViewController* vc = */[appDelegate.navigationController popViewControllerAnimated:animated];
    //	DebugLog(@"navigateBack: %@\npopped vc: %@", [delegate.navigationController.viewControllers description], [vc  description]);
}

+(void)navigateToRoot:(BOOL)animated {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate.navigationController popToRootViewControllerAnimated:animated];
    //    DebugLog(@"navigateToRoot: %@", [delegate.navigationController.viewControllers description]);
}

@end
