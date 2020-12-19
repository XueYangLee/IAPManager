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
    [[IAPManager sharedManager] payWithPurchaseContent:^(IAPPurchaseContent * _Nullable purchaseContent) {
        purchaseContent.tradeNum=@"订单号";
        purchaseContent.productId=@"IAP订单id";
//        purchaseContent.product=@"IAP订单Product信息";
    } result:^(IAPPurchaseResult result, IAPPurchaseContent * _Nullable purchaseContent, NSString * _Nullable resultMessage) {
        DLog(@"结果信息显示：%@",resultMessage)
    }];
}


@end
