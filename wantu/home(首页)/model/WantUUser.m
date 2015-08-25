//
//  WantUUser.m
//  wantu
//
//  Created by 吴新超 on 15/5/23.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//

#import "WantUUser.h"

@implementation WantUUser
- (void)setMbtype:(int)mbtype
{
    _mbtype = mbtype;
    
    self.vip = mbtype > 2;
}
@end
