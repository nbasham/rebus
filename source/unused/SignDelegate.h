#import <Foundation/Foundation.h>
#import "LayoutManager.h"

@protocol SignDelegate <NSObject>

@property(nonatomic, strong) NSString* name;

-(void)addAdditionalSignSubviews:(LayoutManager*)lm;

@end
