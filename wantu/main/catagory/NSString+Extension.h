//
//  NSString+Extension.h
//  wantu
//
//  Created by 吴新超 on 15/5/29.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;
@end
