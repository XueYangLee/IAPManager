//
//  IAPPurchaseContent.h
//  NowMeditation
//
//  Created by 李雪阳 on 2020/12/4.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IAPPurchaseContent : NSObject

//MARK: - 购买传递参数
/** 购买的订单号 */
@property (nonatomic,copy) NSString *_Nullable tradeNum;


/** IAP 产品id */
@property (nonatomic,copy) NSString *_Nullable productId;

/** IAP 完整产品信息 */
@property (nonatomic,strong) SKProduct *_Nullable product;


//MARK: - 购买保存参数

/** 小票收据 */
@property (nonatomic,copy) NSString *receipt;

/** 小票收据 Data */
@property (nonatomic,strong) NSData *receiptData;

/** 交易订单id */
@property (nonatomic,copy) NSString *transactionIdentifier;


/** 货币代码 CNY  EUR */
@property (nonatomic,copy) NSString *currencyCode;

/** 产品价格 */
@property (nonatomic,assign) float price;



/** 订单各参数处理 */
+ (IAPPurchaseContent *_Nullable)disposeIAPPurchaseContent:(void (^ __nullable)(IAPPurchaseContent * purchaseContent))purchaseContent;

@end

NS_ASSUME_NONNULL_END
