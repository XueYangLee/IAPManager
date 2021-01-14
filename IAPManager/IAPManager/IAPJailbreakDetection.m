//
//  IAPJailbreakDetection.m
//  IAPManager
//
//  Created by 李雪阳 on 2021/1/14.
//

#import "IAPJailbreakDetection.h"
#import <UIKit/UIKit.h>

#define ARRAY_SIZE(a) sizeof(a)/sizeof(a[0])

@implementation IAPJailbreakDetection

// 四种检查是否越狱的方法, 只要命中一个, 就说明已经越狱.
+ (BOOL)isJailBroken {
    BOOL jailbroken =  NO;
    
    jailbroken = [self detectJailBreakByJailBreakFileExisted];
    
    if (!jailbroken) {
        jailbroken = [self detectJailBreakByCydiaPathExisted];
    }
    
    if (!jailbroken) {
        jailbroken = [self detectJailBreakByAppPathExisted];
    }
    
    if (!jailbroken) {
        jailbroken = [self detectJailBreakByEnvironmentExisted];
    }
    
    return jailbroken;
}

/**
 * 判定常见的越狱文件
 * /Applications/Cydia.app
 * /Library/MobileSubstrate/MobileSubstrate.dylib
 * /bin/bash
 * /usr/sbin/sshd
 * /etc/apt
 * 这个表可以尽可能的列出来，然后判定是否存在，只要有存在的就可以认为机器是越狱了。
 */
const char* jailbreak_tool_pathes[] = {
    "/Applications/Cydia.app",
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/bin/bash",
    "/usr/sbin/sshd",
    "/etc/apt"
};

+ (BOOL)detectJailBreakByJailBreakFileExisted {
    for (int i = 0; i<ARRAY_SIZE(jailbreak_tool_pathes); i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_tool_pathes[i]]]) {
            DLog(@"The device is jail broken!");
            return YES;
        }
    }
//    DLog(@"The device is NOT jail broken!");
    return NO;
}

/**
 * 判断cydia的URL scheme.
 * URL scheme是可以用来在应用中呼出另一个应用，是一个资源的路径（详见《iOS中如何呼出另一个应用》），这个方法也就是在判定是否存在cydia这个应用。
 */
+ (BOOL)detectJailBreakByCydiaPathExisted {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        DLog(@"The device is jail broken!");
        return YES;
    }
//    DLog(@"The device is NOT jail broken!");
    return NO;
}

/**
 * 读取系统所有应用的名称.
 * 这个是利用不越狱的机器没有这个权限来判定的。
 */
#define USER_APP_PATH                 @"/User/Applications/"
+ (BOOL)detectJailBreakByAppPathExisted {
    if ([[NSFileManager defaultManager] fileExistsAtPath:USER_APP_PATH]) {
        DLog(@"The device is jail broken!");
        NSArray *applist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:USER_APP_PATH error:nil];
        DLog(@"applist = %@", applist);
        return YES;
    }
//    DLog(@"The device is NOT jail broken!");
    return NO;
}

/**
 * 这个DYLD_INSERT_LIBRARIES环境变量，在非越狱的机器上应该是空，越狱的机器上基本都会有Library/MobileSubstrate/MobileSubstrate.dylib.
 */
char* printEnv(void) {
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    return env;
}

+ (BOOL)detectJailBreakByEnvironmentExisted {
    if (printEnv()) {
        DLog(@"The device is jail broken!");
        return YES;
    }
//    DLog(@"The device is NOT jail broken!");
    return NO;
}

@end
