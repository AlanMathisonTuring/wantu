//
//  WXCTabBar.h
//  wantu
//
//  Created by 吴新超 on 15/5/19.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WXCTabBar;
//warning 因为WXCTabBar继承自UITabBar，所以称为WXCTabBar的代理，也必须实现WXCTabBar的代理协议
@protocol WXCTabBarDelegate <UITabBarDelegate>
@optional
- (void)tabBarDidClickPlusButton:(WXCTabBar *)tabBar;
@end

@interface WXCTabBar : UITabBar
@property (nonatomic, weak) id<WXCTabBarDelegate> delegate;
@end
