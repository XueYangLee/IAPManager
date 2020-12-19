//
//  IAPReceiptStore.h
//  NowMeditation
//
//  Created by 李雪阳 on 2020/11/23.
//

#import <Foundation/Foundation.h>
#import "IAPPurchaseContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface IAPReceiptStore : NSObject

/** 保存购买信息 */
+ (BOOL)savePurchaseContent:(IAPPurchaseContent *)purchaseContent forUserId:(NSString *)userId;

/** 获取所有服务器未验证的购买信息 */
+ (NSArray <IAPPurchaseContent *>*)unfinishedPurchaseContentsWithUserId:(NSString *)userId;

/** 更新订单完成后的购买信息数组 */
+ (void)updateFinishedPurchaseContentArray:(NSArray <IAPPurchaseContent *>*)purchaseContentArray forUserId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
