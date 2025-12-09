#import "PrintUtil.h"
#import "AlertUtil.h"

@implementation PrintUtil

+(void)printImage:(UIImage*)image fromRect:(CGRect)r inView:(UIView*)v {
	BOOL osVersionSupported = [DeviceUtil osVersionSupported:@"4.2"];
	if(!osVersionSupported) {
        [AlertUtil showLocalizedOKAlert:@"iosversion4.2"];
		return;
	}

	if(![UIPrintInteractionController isPrintingAvailable]) {
        [AlertUtil showLocalizedOKAlert:@"printingNotAvailable"];
		return;
	}
	
	UIPrintInteractionController* controller = [UIPrintInteractionController sharedPrintController];
	UIPrintInteractionCompletionHandler completionHandler = ^(UIPrintInteractionController* printController, BOOL completed, NSError* error) {
		if(completed && error)
			DebugLog(@"Failed due to error in domain %@ with error code %u", error.domain, error.code);
	};
	UIPrintInfo* printInfo = [UIPrintInfo printInfo];
	
	printInfo.outputType = UIPrintInfoOutputGrayscale; //    do not use UIPrintInfoOutputPhoto, it prints 4x6
	printInfo.jobName = @"Puzzle print job";
	controller.printInfo = printInfo;
    printInfo.orientation = UIPrintInfoOrientationPortrait;
	controller.printingItem = image;
    //	if(!controller.printingItem && image.size.width > image.size.height) {
    //		printInfo.orientation = UIPrintInfoOrientationLandscape;
    //	}
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [controller presentFromRect:r inView:v animated:YES completionHandler:completionHandler];
    } else {
        [controller presentAnimated:YES completionHandler:completionHandler];
    }
}

@end
