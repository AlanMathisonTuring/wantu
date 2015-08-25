//
//  WantUStatusFrame.h
//  wantu
//
//  Created by 吴新超 on 15/5/25.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//
//  一个HWStatusFrame模型里面包含的信息
//  1.存放着一个cell内部所有子控件的frame数据
//  2.存放一个cell的高度
//  3.存放着一个数据模型HWStatus

#import <Foundation/Foundation.h>

// 昵称字体
#define HWStatusCellNameFont [UIFont systemFontOfSize:15]
// 时间字体
#define HWStatusCellTimeFont [UIFont systemFontOfSize:12]
// 来源字体
#define HWStatusCellSourceFont HWStatusCellTimeFont
// 正文字体
#define HWStatusCellContentFont [UIFont systemFontOfSize:14]
// 转发正文字体
#define HWStatusCellRetweetContentFont [UIFont systemFontOfSize:13]
// cell之间的间距
#define HWStatusCellMagin 15
// cell的边框宽度
#define HWStatusCellBorderW 10
@class WantUStatus;


@interface WantUStatusFrame : NSObject

@property (nonatomic, strong) WantUStatus *status;

/** 原创微博整体 */
@property (nonatomic, assign) CGRect originalViewF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 会员图标 */
@property (nonatomic, assign) CGRect vipViewF;
/** 配图 */
@property (nonatomic, assign) CGRect photoViewF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 来源 */
@property (nonatomic, assign) CGRect sourceLabelF;
/** 正文 */
@property (nonatomic, assign) CGRect contentLabelF;

/** 转发微博整体 */
@property (nonatomic, assign) CGRect retweetViewF;
/** 转发微博正文 */
@property (nonatomic, assign) CGRect retweetContentLabelF;
/** 转发微博配图 */
@property (nonatomic, assign) CGRect retweetPhotoViewF;

/** 工具条整体 */
@property (nonatomic, assign) CGRect toolBarViewF;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
@end
