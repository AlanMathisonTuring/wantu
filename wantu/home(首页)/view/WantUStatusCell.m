//
//  WantUStatusCell.m
//  wantu
//
//  Created by 吴新超 on 15/5/25.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//

#import "WantUStatusCell.h"
#import "WantUStatus.h"
#import "WantUUser.h"
#import "WantUStatusFrame.h"
#import "UIImageView+WebCache.h"
#import "WantUPhoto.h"
#import "WantUStatusToolBar.h"
#import "WantUStatusPhotosView.h"

@interface WantUStatusCell()
/* 原创微博 */
/** 原创微博整体 */
@property (nonatomic, weak) UIView *originalView;
/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 配图 */
@property (nonatomic, weak) WantUStatusPhotosView *photoView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文 */
@property (nonatomic, weak) UILabel *contentLabel;

/**
 转发微博
 */
/**
 转发微博整体
 */
@property(nonatomic,weak)UIView *retweetView;
/**
 转发微博正文
 */
@property(nonatomic,weak)UILabel *retweetContentLabel;
/**
 转发图片
 */
@property(nonatomic,weak)WantUStatusPhotosView *retweetPhotoView;

/** 工具条整体 */
@property (nonatomic, weak) WantUStatusToolBar *toolBarView;

@end

@implementation WantUStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    WantUStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[WantUStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
/**
 重写set方法，让所有的cell往下挪
 */
-(void)setFrame:(CGRect)frame{
    frame.origin.y += HWStatusCellMagin;
    [super setFrame:frame];
}
/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //清楚cell的默认颜色
        self.backgroundColor = [UIColor clearColor];
        //点击cell的时候不要变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpOriginal];
        [self setUpRetweet];
        [self setUpToolBar];
    }
    return self;
}
/**设置原创微博*/
-(void)setUpOriginal{
    /** 原创微博整体 */
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    /** 头像 */
    UIImageView *iconView = [[UIImageView alloc] init];
    [originalView addSubview:iconView];
    self.iconView = iconView;
    
    /** 会员图标 */
    UIImageView *vipView = [[UIImageView alloc] init];
    vipView.contentMode = UIViewContentModeCenter;
    [originalView addSubview:vipView];
    self.vipView = vipView;
    
    /** 配图 */
    WantUStatusPhotosView *photoView = [[WantUStatusPhotosView alloc] init];
    [originalView addSubview:photoView];
    self.photoView = photoView;
    
    /** 昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = HWStatusCellNameFont;
    [originalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = HWStatusCellTimeFont;
    timeLabel.textColor = [UIColor orangeColor];

    [originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 来源 */
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = HWStatusCellSourceFont;
    [originalView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /** 正文 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = HWStatusCellContentFont;
    contentLabel.numberOfLines = 0;
    [originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;
}
/**设置转发微博 */
-(void)setUpRetweet{
    /** 转发微博整体 */
    UIView *retweetView = [[UIView alloc] init];
    [self.contentView addSubview:retweetView];
    self.retweetView = retweetView;
    
    /** 转发微博正文 + 昵称 */
    UILabel *retweetContentLabel = [[UILabel alloc] init];
    retweetContentLabel.font = HWStatusCellRetweetContentFont;
    retweetContentLabel.numberOfLines = 0;
    [retweetView addSubview:retweetContentLabel];
    self.retweetContentLabel = retweetContentLabel;
    
    /** 转发微博配图 */
    WantUStatusPhotosView *retweetPhotoView = [[WantUStatusPhotosView alloc] init];
    [retweetView addSubview:retweetPhotoView];
    self.retweetPhotoView = retweetPhotoView;
    
}
/**
 设置工具条
 */
-(void)setUpToolBar{
    /** 转发微博整体 */
    WantUStatusToolBar *toolBarView = [WantUStatusToolBar toolBar];
    [self.contentView addSubview:toolBarView];
    self.toolBarView = toolBarView;
}

- (void)setStatusFrame:(WantUStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    WantUStatus *status = statusFrame.status;
    WantUUser *user = status.user;
    
    /** 原创微博整体 */
    self.originalView.frame = statusFrame.originalViewF;
    
    
    /** 头像 */
    self.iconView.frame = statusFrame.iconViewF;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    /** 会员图标 */
    if (user.isVip) {
        self.vipView.hidden = NO;
        
        self.vipView.frame = statusFrame.vipViewF;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
        self.vipView.image = [UIImage imageNamed:vipName];
        
        self.nameLabel.textColor = [UIColor orangeColor];
    } else {
        self.nameLabel.textColor = [UIColor blackColor];
        self.vipView.hidden = YES;
    }
    
    /** 配图 */
     
    if(status.pic_urls.count>0){
        self.photoView.frame = statusFrame.photoViewF;
        self.photoView.photos = status.pic_urls;
        self.photoView.hidden = NO;
    }else{
        _photoView.hidden = YES;
    }
    
    
    
    /** 昵称 */
    self.nameLabel.text = user.name;
    self.nameLabel.frame = statusFrame.nameLabelF;
    
    /**
     *当时间变了之后重用cell时时间所对应的尺寸也会变，如果时间长度变大了，控件尺寸没变的话会导致时间显示不完全，所以需要重新计算时间的尺寸，相应的来源的尺寸也得重新计算
     */
    /** 时间 */
    NSString *newTime = status.created_at;
    CGFloat timeX = statusFrame.timeLabelF.origin.x;
    CGFloat timeY = CGRectGetMaxY(statusFrame.nameLabelF) + HWStatusCellBorderW;
    CGSize timeSize = [newTime sizeWithFont:HWStatusCellTimeFont];
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    self.timeLabel.text = newTime;
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(statusFrame.timeLabelF) + HWStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:HWStatusCellSourceFont];
    self.sourceLabel.frame = (CGRect){{sourceX, sourceY}, sourceSize};
    self.sourceLabel.text = status.source;
    
    /** 正文 */
    self.contentLabel.text = status.text;
    self.contentLabel.frame = statusFrame.contentLabelF;
    
    /**被转发微博*/
    if(status.retweeted_status){
        WantUStatus *retweetStatus = status.retweeted_status;
        WantUUser *retweetUser = retweetStatus.user;
        self.retweetView.hidden = NO;
        self.retweetView.backgroundColor = WXCColor(247, 247, 247);
        /** 转发微博整体 */
        self.retweetView.frame = statusFrame.retweetViewF;
        /** 转发微博正文+昵称 */
        NSString *retweetContent = [NSString stringWithFormat:@"@%@ ：%@",retweetUser.name,retweetStatus.text];
        self.retweetContentLabel.text = retweetContent;
        self.retweetContentLabel.frame = statusFrame.retweetContentLabelF;
        /** 转发微博配图 */
        
        if(retweetStatus.pic_urls.count>0){
            self.retweetPhotoView.frame = statusFrame.retweetPhotoViewF;
            self.retweetPhotoView.photos = retweetStatus.pic_urls;
            self.retweetPhotoView.hidden = NO;
        }else{
            _retweetPhotoView.hidden = YES;
        }
    }else{
        self.retweetView.hidden = YES;
    }
    
    /**
     工具条
     */
    /** 工具条整体 */
    self.toolBarView.frame = statusFrame.toolBarViewF;
    self.toolBarView.status = status;
}

@end
