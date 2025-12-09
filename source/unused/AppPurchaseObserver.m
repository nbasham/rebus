#import "AppPurchaseObserver.h"
#import "AppDelegate.h"

@implementation AppPurchaseObserver

-(void)paymentQueue:(SKPaymentQueue*)queue updatedTransactions:(NSArray*)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

-(void)paymentQueue:(SKPaymentQueue*)queue restoreCompletedTransactionsFailedWithError:(NSError*)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:kPurchaseTransactionUnsuccessful object:nil];
}

-(void)completeTransaction:(SKPaymentTransaction*)transaction {
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.puzzles categoryPurchased:transaction.payment.productIdentifier transactionId:transaction.transactionIdentifier];
	[[NSNotificationCenter defaultCenter] postNotificationName:kInAppStorePurchase object:nil];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	DebugLog(@"completeTransaction product id: %@ transaction id: %@", transaction.payment.productIdentifier, transaction.transactionIdentifier);
    [[NSNotificationCenter defaultCenter] postNotificationName:kPurchaseTransactionSuccessful object:nil];

}

-(void)restoreTransaction:(SKPaymentTransaction*)transaction {
	[self completeTransaction:transaction];
}

-(void)failedTransaction:(SKPaymentTransaction*)transaction {
    if (transaction.error.code != SKErrorPaymentCancelled) {
        DebugLog(@"%@", [transaction.error description]);
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPurchaseTransactionUnsuccessful object:nil];
}

@end
