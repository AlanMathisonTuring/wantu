//
//  WantUStatus.h
//  wantu
//
//  Created by 吴新超 on 15/5/23.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WantUUser;

@interface WantUStatus : NSObject
/**	string	字符串型的微博ID*/
@property (nonatomic, copy) NSString *idstr;

/**	string	微博信息内容*/
@property (nonatomic, copy) NSString *text;

/**	object	微博作者的用户信息字段 详细*/
@property (nonatomic, strong) WantUUser *user;

/**	string	微博创建时间*/
@property (nonatomic, copy) NSString *created_at;

/**	string	微博来源*/
@property (nonatomic, copy) NSString *source;

/**
 array 微博配图，多图时返回多图链接，没有返回“[]”
 */
@property(nonatomic,strong) NSArray *pic_urls;

/**	int 转发数*/
@property (assign,nonatomic) int reposts_count;

/**	int 评论数*/
@property (assign,nonatomic) int comments_count;

/**	int 点赞数*/
@property (assign,nonatomic) int attitudes_count;

/**
 转发微博
 */
@property(nonatomic,strong)WantUStatus *retweeted_status;
@end
