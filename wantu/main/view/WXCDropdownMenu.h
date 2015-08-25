//
//  WXCDropdownMenu.h
//  wantu
//
//  Created by 吴新超 on 15/5/19.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXCDropdownMenu : UIView
+ (instancetype)menu;

/**
 *  显示
 */
- (void)showFrom:(UIView *)from;
/**
 *  销毁
 */
- (void)dismiss;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;
/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentController;

@end
