//
//  WantUMessageController.m
//  wantu
//
//  Created by 吴新超 on 15/5/17.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//

#import "WantUMessageController.h"
#import "Test1Controller.h"

@interface WantUMessageController ()

@end

@implementation WantUMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // style : 这个参数是用来设置背景的，在iOS7之前效果比较明显, iOS7中没有任何效果
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"写私信" style:UIBarButtonItemStylePlain target:self action:@selector(composeMsg)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 这个item不能点击(目前放在viewWillAppear就能显示disable下的主题)
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)composeMsg
{
    NSLog(@"composeMsg");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"来自微博的第%d条测试消息", indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     Test1Controller *test1 = [[Test1Controller alloc] init];
    test1.title = @"测试1控制器";
    // 当test1控制器被push的时候，test1所在的tabbarcontroller的tabbar会自动隐藏
    // 当test1控制器被pop的时候，test1所在的tabbarcontroller的tabbar会自动显示
    //    test1.hidesBottomBarWhenPushed = YES;
    
    // self.navigationController === HWNavigationController
    [self.navigationController pushViewController:test1 animated:YES];
}

@end
