//
//  AppDelegate.m
//  IAPManager
//
//  Created by 李雪阳 on 2020/12/19.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "IAPManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_window makeKeyAndVisible];
    _window.backgroundColor=[UIColor whiteColor];
    ViewController *root=[ViewController new];
    _window.rootViewController=root;
    
    [[IAPManager sharedManager]startIAPTransactionsWithUserId:@"用户id"];
    
    return YES;
}



@end
