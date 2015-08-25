//
//  WantUAccountTool.h
//  wantu
//
//  Created by 吴新超 on 15/5/21.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WantUAccount.h"
@interface WantUAccountTool : NSObject
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(WantUAccount *)account;

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (WantUAccount *)account;
@end
