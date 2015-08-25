//
//  WantUStatusPhotosView.h
//  wantu
//
//  Created by 吴新超 on 15/5/30.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WantUStatusPhotosView : UIView
@property (nonatomic, strong) NSArray *photos;
/**
 *  根据图片个数计算相册的尺寸
 */
+ (CGSize)sizeWithCount:(int)count;
@end
