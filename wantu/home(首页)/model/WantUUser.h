//
//  WantUUser.h
//  wantu
//
//  Created by 吴新超 on 15/5/23.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WantUUser : NSObject
/**	string	字符串型的用户UID*/
@property (nonatomic, copy) NSString *idstr;

/**	string	友好显示名称*/
@property (nonatomic, copy) NSString *name;

/**	string	用户头像地址，50×50像素*/
@property (nonatomic, copy) NSString *profile_image_url;

/** 会员类型 > 2代表是会员 */
@property (nonatomic, assign) int mbtype;
/** 会员等级 */
@property (nonatomic, assign) int mbrank;
@property (nonatomic, assign, getter = isVip) BOOL vip;
@end
