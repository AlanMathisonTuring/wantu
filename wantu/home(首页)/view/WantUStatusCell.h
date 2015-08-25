//
//  WantUStatusCell.h
//  wantu
//
//  Created by 吴新超 on 15/5/25.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WantUStatusFrame;
@interface WantUStatusCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) WantUStatusFrame *statusFrame;
@end
