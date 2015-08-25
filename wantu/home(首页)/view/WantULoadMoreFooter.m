//
//  WantULoadMoreFooter.m
//  wantu
//
//  Created by 吴新超 on 15/5/24.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//

#import "WantULoadMoreFooter.h"

@implementation WantULoadMoreFooter

+(instancetype)footer{
    return [[[NSBundle mainBundle]loadNibNamed:@"WantULoadMoreFooter" owner:nil options:nil] lastObject];
}

@end
