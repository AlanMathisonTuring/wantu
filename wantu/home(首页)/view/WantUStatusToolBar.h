//
//  WantUStatusToolBar.h
//  wantu
//
//  Created by 吴新超 on 15/5/28.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WantUStatus;
@interface WantUStatusToolBar : UIView
@property (nonatomic, strong) UIButton *repostBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *attitudeBtn;
@property(nonatomic,strong) WantUStatus* status;
+(instancetype)toolBar;
@end
