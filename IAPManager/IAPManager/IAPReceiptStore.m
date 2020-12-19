//
//  IAPReceiptStore.m
//  NowMeditation
//
//  Created by 李雪阳 on 2020/11/23.
//

#import "IAPReceiptStore.h"
#import <SAMKeychain.h>
#import <YYModel.h>

#define SERVICE_IAP_RECEIPT_KEKCHAINSTORE  [NSString stringWithFormat:@"%@.IAP.RECEIPTS",[[NSBundle mainBundle] bundleIdentifier]]

@implementation IAPReceiptStore

+ (BOOL)savePurchaseContent:(IAPPurchaseContent *)purchaseContent forUserId:(NSString *)userId{
    if (!purchaseContent || !userId.length) {
        return NO;
    }
    
    NSString *contentRecordJson = [SAMKeychain passwordForService:SERVICE_IAP_RECEIPT_KEKCHAINSTORE account:userId];
    
    NSArray <IAPPurchaseContent *>*purchaseRecordArray = [NSArray yy_modelArrayWithClass:[IAPPurchaseContent class] json:contentRecordJson];
    
    NSMutableArray <IAPPurchaseContent *>*contentSaveArray = [NSMutableArray array];
    if (purchaseRecordArray.count) {
        [contentSaveArray addObjectsFromArray:purchaseRecordArray];
    }
    [contentSaveArray addObject:purchaseContent];
    
    return [SAMKeychain setPassword:[contentSaveArray yy_modelToJSONString] forService:SERVICE_IAP_RECEIPT_KEKCHAINSTORE account:userId];
}


+ (NSArray <IAPPurchaseContent *>*)unfinishedPurchaseContentsWithUserId:(NSString *)userId{
    if (!userId.length) {
        return nil;
    }
    NSString *contentRecordJson = [SAMKeychain passwordForService:SERVICE_IAP_RECEIPT_KEKCHAINSTORE account:userId];
    
    NSArray <IAPPurchaseContent *>*purchaseRecordArray = [NSArray yy_modelArrayWithClass:[IAPPurchaseContent class] json:contentRecordJson];
    return purchaseRecordArray;
}


+ (void)updateFinishedPurchaseContentArray:(NSArray <IAPPurchaseContent *>*)purchaseContentArray forUserId:(NSString *)userId{
    [SAMKeychain setPassword:[purchaseContentArray yy_modelToJSONString] forService:SERVICE_IAP_RECEIPT_KEKCHAINSTORE account:userId];
}

@end
