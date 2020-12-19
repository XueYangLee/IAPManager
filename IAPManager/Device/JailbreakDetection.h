//
//  JailbreakDetection.h
//  NowMeditation
//
//  Created by Singularity on 2020/11/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JailbreakDetection : NSObject

/** 判断当前设备是否已经越狱 */
+ (BOOL)isJailBroken;

@end

NS_ASSUME_NONNULL_END
