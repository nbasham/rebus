#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kPurchaseTransactionSuccessful @"kPurchaseTransactionSuccessful"
#define kPurchaseTransactionUnsuccessful @"kPurchaseTransactionUnsuccessful"

@interface AppPurchaseObserver : NSObject<SKPaymentTransactionObserver> {
}

-(void)completeTransaction:(SKPaymentTransaction*)transaction;
-(void)restoreTransaction:(SKPaymentTransaction*)transaction;
-(void)failedTransaction:(SKPaymentTransaction*)transaction;

@end
