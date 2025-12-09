//
//  Common, modified to skip XIB and let AppDelegate load window et al
//
#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc,argv, @"UIApplication", @"AppDelegate");
    }
}