//
//  IAPPaymentVerify.h
//  NowMeditation
//
//  Created by 李雪阳 on 2020/12/4.
//

#import <Foundation/Foundation.h>
#import "IAPPurchaseContent.h"
#import "IAPReceiptStore.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^__nullable VerifyCompletion)(BOOL success, IAPPurchaseContent *_Nullable purchaseContent);

@interface IAPPaymentVerify : NSObject

/** 初始化方法 ⚠️ */
- (instancetype)initWithUserId:(NSString *)userId;

/** 购买内容 */
@property (nonatomic,strong) IAPPurchaseContent *_Nullable purchaseContent;

//MARK: - 验证方式

/** 服务器验证方法⚠️   上传服务器验证订单 */
- (void)verifyFromServerWithPurchaseContent:(IAPPurchaseContent *)purchaseContent comp:(VerifyCompletion)comp;

/** 本地验证 （不建议使用，推荐服务器验证） */
- (void)verifyFromITunesURLWithPurchaseContent:(IAPPurchaseContent *)purchaseContent comp:(VerifyCompletion)comp;

//MARK: - 支付信息存储验证逻辑

/** 保存当前支付收据并服务器验证 */
- (void)verifyIAPPurchasedWithReceiptData:(NSData *)receiptData transactionIdentifier:(NSString *)transactionIdentifier completion:(VerifyCompletion)comp;

/** 验证收据 */
- (void)verifyIAPReceiptsWithCompletion:(VerifyCompletion)comp;

/** 保存支付信息 */
- (void)savePurchaseContentToPaymentQueueWithReceiptData:(NSData *)receiptData transactionIdentifier:(NSString *)transactionIdentifier;

@end

NS_ASSUME_NONNULL_END
