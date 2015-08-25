//
//  WantUTabBarController.m
//  wantu
//
//  Created by 吴新超 on 15/5/17.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//

#import "WantUTabBarController.h"
#import "WantUNavigationController.h"
#import "WantUDiscoverController.h"
#import "WantUMineController.h"
#import "WantUMessageController.h"
#import "WantUHomeController.h"
#import "WXCTabBar.h"
@interface WantUTabBarController ()

@end

@implementation WantUTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化子控制器
    WantUHomeController *home = [[WantUHomeController alloc]init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    WantUMessageController *message = [[WantUMessageController alloc]init];
    [self addChildVc:message title:@"消息" image:@"tabbar_message_center"selectedImage:@"tabbar_message_center_selected"];
    
    WantUDiscoverController *discover = [[WantUDiscoverController alloc]init];
    [self addChildVc:discover title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    
    WantUMineController *mine = [[WantUMineController alloc]init];
    [self addChildVc:mine title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    WXCTabBar *tabBar = [[WXCTabBar alloc] init];
    tabBar.delegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    //    childVc.tabBarItem.title = title; // 设置tabbar的文字
    //    childVc.navigationItem.title = title; // 设置navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = WXCColor(123, 123, 123);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    WantUNavigationController *nav = [[WantUNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}

#pragma mark -  WXCTabBarDelegate代理方法
- (void)tabBarDidClickPlusButton:(WXCTabBar *)tabBar
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
