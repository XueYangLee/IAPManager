//
//  ViewController.m
//  IAPManager
//
//  Created by 李雪阳 on 2020/12/19.
//

#import "ViewController.h"
#import "IAPManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *payment=[[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    payment.backgroundColor=UIColor.blueColor;
    [payment setTintColor:UIColor.whiteColor];
    [payment setTitle:@"IAP支付" forState:UIControlStateNormal];
    [payment addTarget:self action:@selector(paymentClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payment];
}


- (void)paymentClick{
    //直接根据IAPid直接支付
    [[IAPManager sharedManager] payWithPurchaseContent:^(IAPPurchaseContent * _Nullable purchaseContent) {
        purchaseContent.tradeNum=@"支付的订单号";
        purchaseContent.productId=@"支付的IAP订单id";
    } result:^(IAPPurchaseResult result, IAPPurchaseContent * _Nullable purchaseContent, NSString * _Nullable resultMessage) {
        DLog(@"结果信息显示：%@",resultMessage)
    }];
    
    /*
    //先统一查询订单Product信息（或在APP启动时查询全部并保存）  再根据订单信息支付
    [[IAPManager sharedManager] fetchProductInfoWithProductIdentifiers:@[@"IAP订单id"] completion:^(NSArray<SKProduct *> * _Nullable products) {
        
        [[IAPManager sharedManager] payWithPurchaseContent:^(IAPPurchaseContent * _Nullable purchaseContent) {
            purchaseContent.tradeNum=@"支付的订单号";
            purchaseContent.product=products.firstObject;
        } result:^(IAPPurchaseResult result, IAPPurchaseContent * _Nullable purchaseContent, NSString * _Nullable resultMessage) {
            DLog(@"结果信息显示：%@",resultMessage)
        }];
        
    }];*/
}


@end
