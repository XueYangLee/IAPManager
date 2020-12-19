//
//  IAPManager.h
//  NowMeditation
//
//  Created by 李雪阳 on 2020/11/19.
//

#import <Foundation/Foundation.h>
#import "IAPPurchaseContent.h"
#import "IAPPaymentVerify.h"

NS_ASSUME_NONNULL_BEGIN

/** 支付结果 */
typedef NS_ENUM(NSUInteger, IAPPurchaseResult) {
    /** 支付成功 验证成功 */
    IAPPurchaseSuccess,
    /** 支付失败 */
    IAPPurchaseFail,
    /** 支付成功 验证失败 */
    IAPPurchaseSuccessVerifyFail,
};

/** 恢复购买结果 */
typedef NS_ENUM(NSUInteger, IAPRestoreResult) {
    /** 恢复成功 验证成功 */
    IAPRestoreSuccess,
    /** 恢复失败 */
    IAPRestoreFail,
    /** 恢复成功 验证失败 */
    IAPRestoreSuccessVerifyFail,
};

typedef void(^PurchaseContent)(IAPPurchaseContent *_Nullable purchaseContent);

typedef void(^__nullable PurchaseResult)(IAPPurchaseResult result, IAPPurchaseContent *_Nullable purchaseContent, NSString *_Nullable resultMessage);

typedef void(^__nullable RestoreResult)(IAPRestoreResult result, IAPPurchaseContent *_Nullable purchaseContent);

typedef void(^FetchProductsCompletion)(NSArray <SKProduct *>*_Nullable products);

/** 苹果内购 In App Purchases */
@interface IAPManager : NSObject

+ (instancetype)sharedManager;

/** 开始IAP交易监听  ⚠️ APP启动及用户登录时调用 ⚠️ */
- (void)startIAPTransactionsWithUserId:(NSString *)userId;

/** 停止IAP交易监听  ⚠️ 用户登出时调用 ⚠️ */
- (void)stopIAPTransactionsManager;



/** 购买 */
- (void)payWithPurchaseContent:(PurchaseContent)purchaseContent result:(PurchaseResult)result;

/** 获取IAP产品信息 SKProduct */
- (void)fetchProductInfoWithProductIdentifiers:(NSArray <NSString *>*)productIdentifiers completion:(FetchProductsCompletion)completion;

/** 恢复购买 */
- (void)restoreIAPProductsWithResult:(RestoreResult)result;


/** 验证未上报服务器的订单 */
- (void)checkUnfinishedTransactionWithCompletion:(VerifyCompletion)comp;


/** 获取本地化价格 */
- (NSString *)getLocalePrice:(SKProduct *)product;

/** 支付结果信息 */
- (NSString *)purchaseResultMessage:(IAPPurchaseResult)result;

/** 判断设备是否已经越狱 */
- (BOOL)isJailbroken;

@end

NS_ASSUME_NONNULL_END
