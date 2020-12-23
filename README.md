## IAPManager

自定义封装IAP苹果内购，支付小票信息钥匙串存储
引用的第三方库 ` SAMKeychain ` 和 ` YYModel `

#### 使用方式
拖入 ` IAPManager ` 和 ` Device `文件夹，
如不需要验证越狱设备仅拖入 ` IAPManager `并删除 ` isJailbroken `方法即可 

###### 1.APP启动及用户登录时需调用开始IAP交易监听方法
```
- (void)startIAPTransactionsWithUserId:(NSString *)userId;
```

###### 2.用户登出时调用停止IAP交易监听
```
- (void)stopIAPTransactionsManager;
```

###### 3.支付
```
[[IAPManager sharedManager] payWithPurchaseContent:^(IAPPurchaseContent * _Nullable purchaseContent) {
    purchaseContent.tradeNum=@"订单号";
    purchaseContent.productId=@"IAP订单id";
//        purchaseContent.product=@"IAP订单Product信息";
} result:^(IAPPurchaseResult result, IAPPurchaseContent * _Nullable purchaseContent, NSString * _Nullable resultMessage) {
    DLog(@"结果信息显示：%@",resultMessage)
}];
```

---

#### 注意：服务器验证方法更换
需在 ` IAPPaymentVerify ` 文件的 ` - (void)verifyFromServerWithPurchaseContent:(IAPPurchaseContent *)purchaseContent comp:(VerifyCompletion)comp; ` 方法中替换自己服务器验证方式并回传结果回调` comp `
