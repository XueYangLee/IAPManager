//
//  IAPPurchaseContent.m
//  NowMeditation
//
//  Created by 李雪阳 on 2020/12/4.
//

#import "IAPPurchaseContent.h"

@implementation IAPPurchaseContent

+ (IAPPurchaseContent *_Nullable)disposeIAPPurchaseContent:(void (^ __nullable)(IAPPurchaseContent * purchaseContent))purchaseContent{
    
    IAPPurchaseContent *contentModel = [IAPPurchaseContent new];
    if (purchaseContent) {
        purchaseContent(contentModel);
    }
    
    if (!contentModel.tradeNum.length) {
        DLog(@"订单号缺失")
        return nil;
    }
    if (!contentModel.productId.length && !contentModel.product) {
        DLog(@"产品缺失")
        return nil;
    }
    
    return contentModel;
}

@end
