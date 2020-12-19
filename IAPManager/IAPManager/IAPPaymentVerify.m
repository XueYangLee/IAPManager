//
//  IAPPaymentVerify.m
//  NowMeditation
//
//  Created by 李雪阳 on 2020/12/4.
//

#import "IAPPaymentVerify.h"

@interface IAPPaymentVerify ()

@property (nonatomic,copy) NSString *userID;

@end

@implementation IAPPaymentVerify

- (instancetype)initWithUserId:(NSString *)userId{
    self = [super init];
    if (self) {
        self.userID = userId;
    }
    return self;
}


//MARK: 服务器验证  
- (void)verifyFromServerWithPurchaseContent:(IAPPurchaseContent *)purchaseContent comp:(VerifyCompletion)comp{
    //TODO: 上传服务器验证订单 ⚠️必须回传结果回调comp
    
    //purchaseContent内容(receipt、tradeNum、transactionIdentifier等)上报服务器进行二次验证  注意区分沙盒参数
}

//保存当前支付收据并服务器验证
- (void)verifyIAPPurchasedWithReceiptData:(NSData *)receiptData transactionIdentifier:(NSString *)transactionIdentifier completion:(VerifyCompletion)comp{
    [self savePurchaseContentToPaymentQueueWithReceiptData:receiptData transactionIdentifier:transactionIdentifier];
    [self verifyIAPReceiptsWithCompletion:comp];
}

//收据队列验证
- (void)verifyIAPReceiptsWithCompletion:(VerifyCompletion)comp{
    if (!self.userID.length) {
        return;
    }
    NSArray <IAPPurchaseContent *>*unfinishedPurchase = [IAPReceiptStore unfinishedPurchaseContentsWithUserId:self.userID];
    if (!unfinishedPurchase.count) {
        comp ? comp(NO, nil) : nil;
        return;
    }
    
    NSMutableArray <IAPPurchaseContent *>*contentResultArray = [NSMutableArray arrayWithArray:unfinishedPurchase];
    
    [contentResultArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(IAPPurchaseContent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self verifyFromServerWithPurchaseContent:obj comp:^(BOOL success, IAPPurchaseContent * _Nullable purchaseContent) {
            if (success) {
                [contentResultArray removeObject:obj];
                [IAPReceiptStore updateFinishedPurchaseContentArray:contentResultArray forUserId:self.userID];
            }
            comp ? comp(success, purchaseContent) : nil;
        }];
    }];
}

//保存支付信息
- (void)savePurchaseContentToPaymentQueueWithReceiptData:(NSData *)receiptData transactionIdentifier:(NSString *)transactionIdentifier{
    if (!receiptData.length) {
        return;
    }
    NSString *encodedReceipt = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    IAPPurchaseContent *purchaseContent = [IAPPurchaseContent new];
    if (self.purchaseContent) {
        purchaseContent = self.purchaseContent;
        
        purchaseContent.currencyCode = self.purchaseContent.product.priceLocale.currencyCode;
        purchaseContent.price = self.purchaseContent.product.price.floatValue;
    }
    if (transactionIdentifier.length) {
        purchaseContent.transactionIdentifier = transactionIdentifier;
    }
    purchaseContent.receiptData = receiptData;
    purchaseContent.receipt = encodedReceipt;
    
    [IAPReceiptStore savePurchaseContent:purchaseContent forUserId:self.userID];//保存购买信息
}



@end
