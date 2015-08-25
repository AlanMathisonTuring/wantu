//
//  WantUHomeController.m
//  wantu
//
//  Created by 吴新超 on 15/5/17.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//

#import "WantUHomeController.h"
#import "WXCDropdownMenu.h"
#import "WantUDropdownMenuController.h"
#import "AFNetworking.h"
#import "WantUAccountTool.h"
#import "WantUStatus.h"
#import "WantUUser.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "WantULoadMoreFooter.h"
#import "WantUStatusCell.h"
#import "WantUStatusFrame.h"
#import "WantUStatusToolBar.h"
@interface WantUHomeController ()
/**
 *  微博数组（里面放的都是HWStatus模型，一个HWStatus对象就代表一条微博）
 */
@property (nonatomic, strong) NSMutableArray *statusFrames;
@end

@implementation WantUHomeController

- (NSMutableArray *)statusFrames
{
    if (!_statusFrames) {
        self.statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

/**
 *  将HWStatus模型转为HWStatusFrame模型
 */
- (NSArray *)stausFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *frames = [NSMutableArray array];
    for (WantUStatus *status in statuses) {
        WantUStatusFrame *f = [[WantUStatusFrame alloc] init];
        f.status = status;
        [frames addObject:f];
    }
    return frames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = WXCColor(211, 211, 211);
    //设置首页显示的内容
    [self setFrame];
    //设置首页的微博昵称
    [self setUserName];
    //下拉刷新最新数据
    //[self setDownRefresh];
    //上蜡刷新最新数据
    //[self setUpRefresh];
    // 添加下拉刷新控件 ---MJRefresh
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewStatus)];
    // 自动下拉刷新
    [self.tableView headerBeginRefreshing];
    // 添加上拉刷新控件
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreStatus)];
    [self addObserverForNotificationCenter];
    
    //获得未读数显示在tabbaritem上
    //利用一个定时器，每隔10秒向新浪发送一次请求，看是否有新的数据
    //在appDelegate中app进入后台的方法中向系统申请后台运行，否则，应用进入后台后就无法执行定时任务了
    NSTimer *timer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(setUpNewCount) userInfo:nil repeats:YES];
    //更改系统主线程轮询机制对NSTimer的处理模式，告诉主线程抽空也处理一下timer(不管是否在处理其它事情)
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    
}

//注册通知
-(void)addObserverForNotificationCenter{
    //转发
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repostAnyWeibo:) name:@"repostAnyWeibo"object:nil];
}

-(void)repostAnyWeibo:(NSNotification*) notification{
    NSString *msg = (NSString*)[notification object];
    [self showrepostsuccess:msg];
}

-(void)setUpNewCount{
    //1,创建请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //拼接请求参数
    WantUAccount * account = [WantUAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    //发送请求
    [manager GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //微博的未读数
//        int status = [responseObject[@"status"] intValue];
//        //设置tabbaritem图标上得提醒数字（这里的数字是字符串格式）
//        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",status];
        
        /**
        下面的方法将数字转成字符串更加方便（利用类似于JAVA的toString，NSNumber内部已经重写了description为将数字转为字符串）
        // @20 --> @"20"
        // NSNumber --> NSString
         */
        
        // 设置提醒数字(微博的未读数)
        NSString *status = [responseObject[@"status"] description];
        
        //IOS8之后只有用户授权后才能使用UIApplication设置应用程序图标的数字
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        //处理status为“0”的时候不显示，默认显示0
        if([@"0" isEqualToString:status]){
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }else{
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)setUpRefresh{
    WantULoadMoreFooter * footer = [WantULoadMoreFooter footer];
    footer.hidden = YES;
    self.tableView.tableFooterView = footer;
}

-(void) setDownRefresh{
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    //监听刷新事件（只有用户手动下拉的时候才会触发valueChange方法）
    [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
    //立即开始刷新 （不会触发valueChange事件）
    [control beginRefreshing];
    //手动加载刷新方法
    [self refreshStateChange:control];
}

-(void)refreshStateChange:(UIRefreshControl *)control{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    // 2.拼接请求参数
    WantUAccount *account = [WantUAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最前面的微博（最新的微博，ID最大的微博）
    WantUStatusFrame *firstStatusF = [self.statusFrames firstObject];
    if (firstStatusF) {
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        params[@"since_id"] = firstStatusF.status.idstr;
    }
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [WantUStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 将 HWStatus数组 转为 HWStatusFrame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        
        // 将最新的微博数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:newFrames atIndexes:set];
        
        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新
        [control endRefreshing];
        
        self.tabBarItem.badgeValue = nil;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        //显示刷新条数
        [self showStatusesCount:newStatuses.count];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
        
        // 结束刷新刷新
        [control endRefreshing];
    }];

}

-(void)loadNewStatus{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    // 2.拼接请求参数
    WantUAccount *account = [WantUAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最前面的微博（最新的微博，ID最大的微博）
    WantUStatusFrame *firstStatusF = [self.statusFrames firstObject];
    if (firstStatusF) {
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        params[@"since_id"] = firstStatusF.status.idstr;
    }
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [WantUStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 将 HWStatus数组 转为 HWStatusFrame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        
        // 将最新的微博数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:newFrames atIndexes:set];
        
        // 刷新表格
        [self.tableView reloadData];// 结束下拉刷新
        [self.tableView headerEndRefreshing];
        
        self.tabBarItem.badgeValue = nil;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        //显示刷新条数
        [self showStatusesCount:newStatuses.count];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}

-(void)showStatusesCount:(int)count{
    //创建一个用来显示条数label
    UILabel* label = [[UILabel alloc]init];
    label.size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 35);
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    //设置其他属性
    
    if(count == 0){
        label.text = @"没有新的微博，稍后再试";
    }else{
        label.text = [NSString stringWithFormat:@"共刷新%d条新的微博",count];
    }
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    
    //显示和隐藏刷新数量窗口
    label.y = 64-label.height;
    //将label显示在导航栏的下面，并添加在导航控制器上（导航控制器的方法）
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    //设置显示动画
    //动画时间：
    CGFloat time = 1.0;
    [UIView animateWithDuration:time animations:^{
        //label.y += label.height;
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
         CGFloat delay = 1.0;//延迟一秒再消失
        [UIView animateWithDuration:time delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            //label.y -= label.height;
            label.transform = CGAffineTransformIdentity;//回到原位置
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}


-(void)showrepostsuccess:(NSString*)msg{
    //创建一个用来显示条数label
    UILabel* label = [[UILabel alloc]init];
    label.size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 35);
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    //设置其他属性
    if([msg isEqual:@"success"]
       ){
        label.text = @"微博转发成功";
    }else{
        label.text = @"微博转发失败，请检查网络";
    }
    
    
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    
    //显示和隐藏刷新数量窗口
    label.y = 64-label.height;
    //将label显示在导航栏的下面，并添加在导航控制器上（导航控制器的方法）
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    //设置显示动画
    //动画时间：
    CGFloat time = 1.0;
    [UIView animateWithDuration:time animations:^{
        //label.y += label.height;
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        CGFloat delay = 1.0;//延迟一秒再消失
        [UIView animateWithDuration:time delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            //label.y -= label.height;
            label.transform = CGAffineTransformIdentity;//回到原位置
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}


//设置首页的微博昵称
-(void)setUserName{
    /*
     URL：https://api.weibo.com/2/users/show.json
     
     请求参数：
     access_token：保存在沙盒中的授权码码
     uid：用户额ID
     */
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // AFN的AFJSONResponseSerializer默认不接受text/plain这种类型
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    WantUAccount *account = [WantUAccountTool account];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;

    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //拿到当前导航栏的标题按钮
        UIButton * tittleButton = (UIButton*)self.navigationItem.titleView;
        //设置标题按钮的文字为用户昵称
        [tittleButton setTitle:responseObject[@"name"] forState:UIControlStateNormal];
        //保存昵称到沙盒
        account.name = responseObject[@"name"];
        [WantUAccountTool saveAccount:account];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
    }];
}
//设置首页显示的内容
-(void)setFrame{
    /* 设置导航栏上面的内容 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    
    /* 中间的标题按钮 */
    //    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *titleButton = [[UIButton alloc] init];
    titleButton.width = 150;
    titleButton.height = 30;
    //    titleButton.backgroundColor = HWRandomColor;
    
    // 设置图片和文字
    //先查询沙盒中上一次昵称信息
    WantUAccount* account = [WantUAccountTool account];
    [titleButton setTitle:account.name?account.name:@"首页" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    //    titleButton.imageView.backgroundColor = [UIColor redColor];
    //    titleButton.titleLabel.backgroundColor = [UIColor blueColor];
    titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 110, 0, 0);
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    
    // 监听标题点击
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleButton;
}
- (void)friendSearch
{
    NSLog(@"friendSearch");
}

- (void)pop
{
    NSLog(@"pop");
}

/**
 *  标题点击
 */
- (void)titleClick:(UIButton *)titleButton
{
    // 1.创建下拉菜单
    WXCDropdownMenu *menu = [WXCDropdownMenu menu];
    
    // 2.设置内容
    WantUDropdownMenuController *vc = [[WantUDropdownMenuController alloc] init];
    vc.view.height = 200;
    vc.view.width = 150;
    menu.contentController = vc;
    
    // 3.显示
    [menu showFrom:titleButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.statusFrames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // 获得cell
    WantUStatusCell *cell = [WantUStatusCell cellWithTableView:tableView];
    
    // 给cell传递模型数据
    cell.statusFrame = self.statusFrames[indexPath.row];
    
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    scrollView == self.tableView == self.view
    // 如果tableView还没有数据，就直接返回
    if (self.statusFrames.count == 0 || self.tableView.tableFooterView.isHidden == NO) return;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    /*
     contentInset：除具体内容以外的边框尺寸
     contentSize: 里面的具体内容（header、cell、footer），除掉contentInset以外的尺寸
     contentOffset:
     1.它可以用来判断scrollView滚动到什么位置
     2.指scrollView的内容超出了scrollView顶部的距离（除掉contentInset以外的尺寸）
     */

    
    // 当最后一个cell完全显示在眼前时，contentOffset的y值
    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
    if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
        // 显示footer
        self.tableView.tableFooterView.hidden = NO;
        
        // 加载更多的微博数据
        [self loadMoreStatus];
    }
}


/**
 *  加载更多的微博数据
 */
- (void)loadMoreStatus
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    WantUAccount *account = [WantUAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最后面的微博（最新的微博，ID最大的微博）
    WantUStatusFrame *lastStatusF = [self.statusFrames lastObject];
    if (lastStatusF) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastStatusF.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [WantUStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 将 HWStatus数组 转为 HWStatusFrame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusFrames addObjectsFromArray:newFrames];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        self.tableView.tableFooterView.hidden = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 结束刷新
        self.tableView.tableFooterView.hidden = YES;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WantUStatusFrame *frame = self.statusFrames[indexPath.row];
    return frame.cellHeight;
}

@end
