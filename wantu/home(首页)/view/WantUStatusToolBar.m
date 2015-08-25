//
//  WantUStatusToolBar.m
//  wantu
//
//  Created by 吴新超 on 15/5/28.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//

#import "WantUStatusToolBar.h"
#import "WantUStatus.h"
#import "AFNetworking.h"
#import "WantUAccountTool.h"
@interface WantUStatusToolBar()
/**里面存放了所有分割线*/
@property(nonatomic,strong) NSMutableArray* drivers;
/**里面存放了所有的按钮*/
@property(nonatomic,strong) NSMutableArray* btns;
@end
@implementation WantUStatusToolBar
{
    WantUStatus * wantustatus;
}
/**
 *按钮懒加载
 */
- (NSMutableArray *)btns
{
    if (!_btns) {
        self.btns = [NSMutableArray array];
    }
    return _btns;
}
/**
 *分割线懒加载
 */
-(NSMutableArray*)drivers{
    if (!_drivers) {
        self.drivers = [NSMutableArray array];
    }
    return _drivers;
}

+(instancetype)toolBar{
    return [[self alloc]init];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    // 设置按钮的frame
    int count = (int)self.subviews.count;
    CGFloat btnW = self.width/3;
    CGFloat btnH = self.height;
    for (int i=0; i<count; i++) {
        UIButton * btn = self.subviews[i];
        btn.x = btnW * i;
        btn.y = 0;
        btn.width = btnW;
        btn.height = btnH;
    }
    
    // 设置分割线的frame
    int dividerCount = self.drivers.count;
    for (int i = 0; i<dividerCount; i++) {
        UIImageView *divider = self.drivers[i];
        divider.width = 1;
        divider.height = btnH;
        divider.x = (i + 1) * btnW;
        divider.y = 0;
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
        // 添加按钮
        self.repostBtn = [self setupBtn:@"转发" icon:@"timeline_icon_retweet"];
        self.commentBtn = [self setupBtn:@"评论" icon:@"timeline_icon_comment"];
        self.attitudeBtn = [self setupBtn:@"赞" icon:@"timeline_icon_unlike"];
        
        [self setupDriver];
        [self setupDriver];
    }
    return self;
}

/**
 * 初始化一个按钮
 * @param title : 按钮文字
 * @param icon : 按钮图标
 */
- (UIButton *)setupBtn:(NSString *)title icon:(NSString *)icon
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:btn];
    
    [self.btns addObject:btn];
    
    return btn;
}

/**设置分割线*/
-(void)setupDriver{
    UIImageView* driver = [[UIImageView alloc]init];
    driver.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    [self addSubview:driver];
    [self.drivers addObject:driver];
}

/**
 *设置将status数据中的点赞数，评论数和转发数给toolbar
 */
-(void)setStatus:(WantUStatus *)status{
    
    // 转发
    [self setupBtnCount:status.reposts_count btn:self.repostBtn title:@"转发"];
    wantustatus = status;
    [self.repostBtn addTarget:self action:@selector(rePostOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 评论
    [self setupBtnCount:status.comments_count btn:self.commentBtn title:@"评论"];
    // 赞
    [self setupBtnCount:status.attitudes_count btn:self.attitudeBtn title:@"赞"];

}

-(void)rePostOnClick{
    
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    WantUAccount *account = [WantUAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"id"] = wantustatus.idstr;

    [mgr POST:@"https://api.weibo.com/2/statuses/repost.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"repostAnyWeibo" object:@"success"];
        //NSLog(@"success");
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"repostAnyWeibo" object:@"failure"];
        //NSLog(@"failure");
    }];

}


- (void)setupBtnCount:(int)count btn:(UIButton *)btn title:(NSString *)title
{
    if (count) { // 数字不为0
        if (count < 10000) { // 不足10000：直接显示数字，比如786、7986
            title = [NSString stringWithFormat:@"%d", count];
        } else { // 达到10000：显示xx.x万，不要有.0的情况
            double wan = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万", wan];
            // 将字符串里面的.0去掉
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }
    [btn setTitle:title forState:UIControlStateNormal];
}
@end
