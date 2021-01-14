//
//  IAPJailbreakDetection.h
//  IAPManager
//
//  Created by 李雪阳 on 2021/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IAPJailbreakDetection : NSObject

/** 判断当前设备是否已经越狱 */
+ (BOOL)isJailBroken;

@end

NS_ASSUME_NONNULL_END
