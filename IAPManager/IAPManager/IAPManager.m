//
//  IAPManager.m
//  NowMeditation
//
//  Created by 李雪阳 on 2020/11/19.
//

#import "IAPManager.h"
#import <StoreKit/StoreKit.h>

#import "IAPReceiptStore.h"
#import "IAPJailbreakDetection.h"

@interface IAPManager () <SKPaymentTransactionObserver,SKProductsRequestDelegate>

/** 验证工具类 */
@property (nonatomic,strong) IAPPaymentVerify *paymentVerify;

/** 支付结果 */
@property (nonatomic,copy) PurchaseResult purchaseResult;

/** 恢复购买结果 */
@property (nonatomic,copy) RestoreResult restoreResult;

/** 获取IAP产品信息结果 */
@property (nonatomic,copy) FetchProductsCompletion fetchProductsComp;

/** 当前商品列表获取请求 */
@property(nonatomic, weak, nullable) SKProductsRequest *currentProductsRequest;

@end

@implementation IAPManager

+ (instancetype)sharedManager {
    static IAPManager *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[IAPManager alloc] init];
    });
    return shareManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addNotificationObserver];
    }
    return self;
}


#pragma mark - Notification
- (void)addNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didReceiveApplicationWillTerminateNotification) name:UIApplicationWillTerminateNotification object:nil];
}

- (void)applicationWillEnterForegroundNotification:(NSNotification *)notification {
    // 检查沙盒中没有持久化的交易.
    [self checkUnfinishedTransactionWithCompletion:nil];
}

- (void)didReceiveApplicationWillTerminateNotification {
    [self stopIAPTransactionsManager];
    [self removeNotificationObserver];
}

- (void)removeNotificationObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TransactionStart

- (void)startIAPTransactionsWithUserId:(NSString *)userId{
    if (!userId.length) {
        return;
    }
    if ([self isJailbroken]) {
        DLog(@"越狱设备，禁止支付")
        return;
    }
    if (self.paymentVerify) {
        DLog(@"IAP启动方法只需调用一次")
        return;
    }
    DLog(@"startIAP")
    
    self.paymentVerify = [[IAPPaymentVerify alloc]initWithUserId:userId];
    
    [self checkUnfinishedTransactionWithCompletion:nil];
    
    //添加IAP监听
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)stopIAPTransactionsManager{
    DLog(@"stopIAP")
    if (self.currentProductsRequest) {
        [self.currentProductsRequest cancel];
        self.currentProductsRequest = nil;
    }
    
    self.paymentVerify = nil;
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark - Pay

- (void)payWithPurchaseContent:(PurchaseContent)purchaseContent result:(PurchaseResult)result {
    if ([self isJailbroken]) {
        DLog(@"越狱设备，禁止支付")
        return;
    }
    
    if ([SKPaymentQueue canMakePayments]) {
        
        IAPPurchaseContent *content = [IAPPurchaseContent disposeIAPPurchaseContent:purchaseContent];
        if (!content) {
            DLog(@"订单缺失，检查订单参数")
            return;
        }
        
        self.purchaseResult = result;
        
        self.paymentVerify.purchaseContent = content;
        
        if (content.product) {
            //发送购买请求
            SKPayment *payment = [SKPayment paymentWithProduct:content.product];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }else{
            if (self.currentProductsRequest) {
                [self.currentProductsRequest cancel];
                self.currentProductsRequest = nil;
            }
            
            NSSet *identifiers = [NSSet setWithObject:content.productId];
            //初始化请求
            [self requestProductsWithProductIdentifiers:identifiers];
        }
    }else {
        DLog(@"用户禁止应用内付费购买")
    }
}

#pragma mark - fetchProducts

//MARK: 获取IAP产品信息
- (void)fetchProductInfoWithProductIdentifiers:(NSArray <NSString *>*)productIdentifiers completion:(FetchProductsCompletion)completion{
    if ([self isJailbroken]) {
        DLog(@"越狱设备，禁止支付")
        return;
    }
    
    if (!productIdentifiers.count) {
        return;
    }
    if (self.currentProductsRequest) {
        [self.currentProductsRequest cancel];
        self.currentProductsRequest = nil;
    }
    self.fetchProductsComp = completion;
    
    if ([SKPaymentQueue canMakePayments]) {
        NSSet *identifiers = [NSSet setWithArray:productIdentifiers];
        
        [self requestProductsWithProductIdentifiers:identifiers];
    }else {
        if (self.fetchProductsComp) {
            self.fetchProductsComp(nil);
        }
        DLog(@"用户禁止应用内付费购买")
    }
}

//MARK: 获取本地化价格
- (NSString *)getLocalePrice:(SKProduct *)product {
    if (product) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setLocale:product.priceLocale];
        
        return [formatter stringFromNumber:product.price];
    }
    return @"";
}

#pragma mark - SKProductsRequestDelegate

//MARK: 查询商品信息反馈回调
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray<SKProduct *> *products = response.products;
    
    if (self.fetchProductsComp) {
        self.fetchProductsComp(products);
    }
    
    if (!products.count) {
        DLog(@"没有正在出售的商品");
        return;
    }
    
    for (SKProduct *product in products) {
        DLog(@"描述信息----->%@\n产品标题----->%@\n产品描述信息----->%@\n价格(货币)----->%@(%@)\n\nproductIdentifier----->%@\n",product.description, product.localizedTitle, product.localizedDescription, product.price, product.priceLocale.currencyCode, product.productIdentifier)
    }
    
    if (self.paymentVerify.purchaseContent.productId) {
        self.paymentVerify.purchaseContent.product = products.firstObject;
        //发送购买请求
        SKPayment *payment = [SKPayment paymentWithProduct:products.firstObject];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

//MARK: 反馈请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    DLog(@"ERROR:%@\n\nERROR DETAIL:\n%@", [error localizedDescription], error)
    if (self.purchaseResult) {
        self.purchaseResult(IAPPurchaseFail, (self.paymentVerify.purchaseContent ? self.paymentVerify.purchaseContent : nil), [self purchaseResultMessage:IAPPurchaseFail]);
    }
}

//MARK: 商品信息查询反馈结束
- (void)requestDidFinish:(SKRequest *)request{
    DLog(@"商品信息查询反馈结束")
}

#pragma mark - SKPaymentTransactionObserver

//MARK: 购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    // 这里的事务包含之前没有完成的.
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing://正在购买
                [self transactionPurchasing:transaction];
                break;
                
            case SKPaymentTransactionStatePurchased://交易成功
                [self transactionPurchased:transaction];
                break;
                
            case SKPaymentTransactionStateFailed://购买失败
                [self transactionFailed:transaction];
                break;
                
            case SKPaymentTransactionStateRestored://已购买过 恢复购买
                [self transactionRestored:transaction];
                break;
                
            case SKPaymentTransactionStateDeferred://交易延期 交易还在队列里面，但最终状态还没有决定
                [self transactionDeferred:transaction];
                break;
        }
    }
}


#pragma mark - SKPaymentTransactionState

//MARK: 正在购买
- (void)transactionPurchasing:(SKPaymentTransaction *)transaction {
    DLog(@"正在购买...")
}

//MARK: 交易成功
- (void)transactionPurchased:(SKPaymentTransaction *)transaction {
    DLog(@"交易成功")
    NSString *transactionIdentifier = @"";
    if(transaction.originalTransaction){// 如果是自动续费的订单originalTransaction会有内容
        DLog(@"自动订阅")
        transactionIdentifier = transaction.originalTransaction.transactionIdentifier;
    }else{// 普通购买，以及 第一次购买 自动订阅
        DLog(@"普通购买")
        transactionIdentifier = transaction.transactionIdentifier;
    }
    DLog(@"%@->transactionIdentifier",transactionIdentifier)
    // 获取购买凭据
    NSData *receiptData = [self fetchTransactionReceiptData];
    if (!receiptData) {
        DLog(@"无购买凭证");
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.paymentVerify verifyIAPPurchasedWithReceiptData:receiptData transactionIdentifier:transactionIdentifier completion:^(BOOL success, IAPPurchaseContent * _Nullable purchaseContent) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.purchaseResult) {
            strongSelf.purchaseResult((success ? IAPPurchaseSuccess : IAPPurchaseSuccessVerifyFail), purchaseContent, [self purchaseResultMessage:(success ? IAPPurchaseSuccess : IAPPurchaseSuccessVerifyFail)]);
        }
    }];
    
    [self finishTransaction:transaction];
}

//MARK: 购买失败
- (void)transactionFailed:(SKPaymentTransaction *)transaction {
    DLog(@"购买失败  errorCode:%ld",transaction.error.code)
    if(transaction.error.code != SKErrorPaymentCancelled) {
        DLog(@"订单错误");
    }else {
        DLog(@"用户取消交易");
    }
    
    if (self.purchaseResult) {
        self.purchaseResult(IAPPurchaseFail, (self.paymentVerify.purchaseContent ? self.paymentVerify.purchaseContent : nil), [self purchaseResultMessage:IAPPurchaseFail]);
    }
    
    [self finishTransaction:transaction];
}

//MARK: 已购买过 恢复购买
- (void)transactionRestored:(SKPaymentTransaction *)transaction {
    DLog(@"已购买过 恢复购买")
    NSString *transactionIdentifier = @"";
    if(transaction.originalTransaction){// 如果是自动续费的订单originalTransaction会有内容
        transactionIdentifier = transaction.originalTransaction.transactionIdentifier;
    }else{// 普通购买，以及 第一次购买 自动订阅
        transactionIdentifier = transaction.transactionIdentifier;
    }
    NSData *receiptData = [self fetchTransactionReceiptData];
    if (!receiptData) {
        DLog(@"无购买凭证");
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.paymentVerify verifyIAPPurchasedWithReceiptData:receiptData transactionIdentifier:transactionIdentifier completion:^(BOOL success, IAPPurchaseContent * _Nullable purchaseContent) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.restoreResult) {
            strongSelf.restoreResult((success ? IAPRestoreSuccess : IAPRestoreSuccessVerifyFail), purchaseContent);
        }
    }];
    
    [self finishTransaction:transaction];
}

//MARK: 交易延期 交易还在队列里面，但最终状态还没有决定
- (void)transactionDeferred:(SKPaymentTransaction *)transaction {
    DLog(@"交易延期 交易还在队列里面，但最终状态还没有决定")
    //主要用于儿童模式，需要询问家长同意。这种情况下不能关闭订单（完成交易），否则这类充值将无法处理。
}


#pragma mark - CheckUnfinishedReceipts

//MARK: 验证未上报服务器的订单
- (void)checkUnfinishedTransactionWithCompletion:(VerifyCompletion)comp {
    [self.paymentVerify verifyIAPReceiptsWithCompletion:comp];
}

#pragma mark - restore

- (void)restoreIAPProductsWithResult:(RestoreResult)result{
    if ([self isJailbroken]) {
        DLog(@"越狱设备，禁止支付")
        return;
    }
    
    self.restoreResult = result;
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    DLog(@"恢复购买完成")
}
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    DLog(@"恢复购买失败: %@ %ld", error.localizedDescription,(long)error.code);
    if (self.restoreResult) {
        self.restoreResult(IAPRestoreFail, nil);
    }
}

#pragma mark - otherDispose

- (void)requestProductsWithProductIdentifiers:(NSSet <NSString *>*)productIdentifiers{
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    request.delegate = self;
    [request start];
    self.currentProductsRequest = request;
}

//MARK: 获取交易收据Data
- (NSData *)fetchTransactionReceiptData {
    // 验证凭据，获取到苹果返回的交易凭据，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    if(!receiptData){
        SKReceiptRefreshRequest *request = [[SKReceiptRefreshRequest alloc] init];
        request.delegate = self;
        [request start];
        
    }
    return receiptData;
}

//MARK: 完成交易统一处理
- (void)finishTransaction:(SKPaymentTransaction *)transaction{
    if (!transaction) {
        return;
    }
    // 不能完成一个正在交易的订单.
    if (transaction.transactionState == SKPaymentTransactionStatePurchasing) {
        return;
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

//MARK: 支付结果信息
- (NSString *)purchaseResultMessage:(IAPPurchaseResult)result{
    NSString *message = @"";
    if (result == IAPPurchaseSuccess) {
        message = @"支付成功";
    }else if (result == IAPPurchaseFail){
        message = @"支付失败，请重试";
    }else if (result == IAPPurchaseSuccessVerifyFail){
        message = @"支付成功，请稍后刷新验证";
    }
    return message;
}

//MARK: 判断是否越狱
- (BOOL)isJailbroken{
    return [IAPJailbreakDetection isJailBroken];
}



@end

