//
//  WantUStatusFrame.m
//  wantu
//
//  Created by 吴新超 on 15/5/25.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//

#import "WantUStatusFrame.h"
#import "WantUUser.h"
#import "WantUStatus.h"
#import "WantUStatusPhotosView.h"
@implementation WantUStatusFrame

-(void)setStatus:(WantUStatus *)status{
    _status = status;
    WantUUser *user = status.user;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /* 原创微博 */
    
    /** 头像 */
    CGFloat iconWH = 35;
    CGFloat iconX = HWStatusCellBorderW;
    CGFloat iconY = HWStatusCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + HWStatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [user.name sizeWithFont:HWStatusCellNameFont];
    //CGSize nameSize = [self sizeWithText:user.name font:HWStatusCellNameFont];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /** 会员图标 */
    if (user.isVip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + HWStatusCellBorderW;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 14;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    /** 时间 */
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + HWStatusCellBorderW;
    CGSize timeSize = [status.created_at sizeWithFont:HWStatusCellTimeFont];
   // CGSize timeSize = [self sizeWithText:status.created_at font:HWStatusCellTimeFont];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + HWStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:HWStatusCellSourceFont];
    //CGSize sourceSize = [self sizeWithText:status.source font:HWStatusCellSourceFont];
    self.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 正文 */
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + HWStatusCellBorderW;
    CGFloat maxW = cellW - 2 * contentX;
    CGSize contentSize = [status.text sizeWithFont:HWStatusCellContentFont maxW:maxW];
   // CGSize contentSize = [self sizeWithText:status.text font:HWStatusCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    
    /** 配图 */
    CGFloat originalH = 0;
    if(status.pic_urls.count>0){
        CGFloat photoX = contentX;
        CGFloat photoY = CGRectGetMaxY(self.contentLabelF) + HWStatusCellBorderW;
        CGSize photosViewSize = [WantUStatusPhotosView sizeWithCount:status.pic_urls.count];
        self.photoViewF = (CGRect){{photoX,photoY},photosViewSize};
        originalH = CGRectGetMaxY(self.photoViewF) + HWStatusCellBorderW;
     
    }else{
        originalH = CGRectGetMaxY(self.contentLabelF) + HWStatusCellBorderW;
        
    }
    /** 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = 0;
    CGFloat originalW = cellW;
    
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
    
     /* 转发微博 */
    if (status.retweeted_status) {
        WantUStatus *retweetStatus = status.retweeted_status;
        WantUUser *retweetUser = retweetStatus.user;
        
        /**正文+昵称*/
        CGFloat retweetContentX = HWStatusCellBorderW;
        CGFloat retweetContentY = HWStatusCellBorderW;

        NSString *retweetContent = [NSString stringWithFormat:@"@%@：%@",retweetUser.name,retweetStatus.text];
        CGFloat maxW = cellW - 2 * retweetContentX;
        CGSize contentSize = [retweetContent sizeWithFont:HWStatusCellRetweetContentFont maxW:maxW];
        
        self.retweetContentLabelF = (CGRect){{retweetContentX,retweetContentY},contentSize};
        
        /** 配图 */
        CGFloat retweetH = 0;
        if(retweetStatus.pic_urls.count>0){
            CGFloat retweetPhotoX = retweetContentX;
            CGFloat retweetPhotoY = CGRectGetMaxY(self.retweetContentLabelF) + HWStatusCellBorderW;
            CGSize retweetPhotosViewSize = [WantUStatusPhotosView sizeWithCount:retweetStatus.pic_urls.count];
            self.retweetPhotoViewF = (CGRect){{retweetPhotoX,retweetPhotoY},retweetPhotosViewSize};
            retweetH = CGRectGetMaxY(self.retweetPhotoViewF) + HWStatusCellBorderW;
          
        }else{
            retweetH = CGRectGetMaxY(self.retweetContentLabelF) + HWStatusCellBorderW;
           
        }
        
        /** 转发微博整体 */
        CGFloat originalX = 0;
        CGFloat originalY = CGRectGetMaxY(self.originalViewF);
        CGFloat originalW = cellW;
        self.retweetViewF = CGRectMake(originalX, originalY, originalW, retweetH);
        self.toolBarViewF = CGRectMake(originalX, CGRectGetMaxY(self.retweetViewF), originalW, 35);

    }else{
        self.toolBarViewF = CGRectMake(originalX, CGRectGetMaxY(self.originalViewF), originalW, 35);
    }
     self.cellHeight = CGRectGetMaxY(self.toolBarViewF) + HWStatusCellMagin;
   
}

@end
