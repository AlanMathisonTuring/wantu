//
//  WantUStatus.m
//  wantu
//
//  Created by 吴新超 on 15/5/23.
//  Copyright (c) 2015年 wuxinchao. All rights reserved.
//

#import "WantUStatus.h"
#import "MJExtension.h"
#import "WantUPhoto.h"
@implementation WantUStatus
-(NSDictionary*)objectClassInArray{
    //告诉工具类将array中得字典中的pic_urls转成WantUPhoto模型
    return @{@"pic_urls":[WantUPhoto class]};
}
/**
 *重写获取微博创建时间的get方法，将日期转为我们微博显示的日期格式
 */
/**
 1.今年
 1> 今天
 * 1分内： 刚刚
 * 1分~59分内：xx分钟前
 * 大于60分钟：xx小时前
 
 2> 昨天
 * 昨天 xx:xx
 
 3> 其他
 * xx-xx xx:xx
 
 2.非今年
 1> xxxx-xx-xx xx:xx
 */
-(NSString *)created_at{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    dateFormater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    //设置日期格式（声明字符串内每个数字和单词的含义）
    // _created_at == Thu Oct 16 17:06:25 +0800 2014
    // dateFormat == EEE MMM dd HH:mm:ss Z yyyy
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年
    // NSString --> NSDate
    dateFormater.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    NSDate *createTime = [dateFormater dateFromString:_created_at];
   
    // 当前时间
    NSDate *now = [NSDate date];
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:createTime toDate:now options:0];

    if ([createTime isThisYear]) { // 今年
        if ([createTime isYesterday]) { // 昨天
            dateFormater.dateFormat = @"昨天 HH:mm";
            return [dateFormater stringFromDate:createTime];
        } else if ([createTime isToday]) { // 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%ld小时前", (long)cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%ld分钟前", (long)cmps.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年的其他日子
            dateFormater.dateFormat = @"MM-dd HH:mm";
            return [dateFormater stringFromDate:createTime];
        }
    } else { // 非今年
        dateFormater.dateFormat = @"yyyy-MM-dd HH:mm";
        return [dateFormater stringFromDate:createTime];
    }
}

/**微博来源，重写set方法（因为每条微博来源是固定的，所以只要设置一次就够了，不用像时间一样一直在变要不断调用）*/
-(void)setSource:(NSString *)source{
    //截取URL中有用的字符串信息显示到微博来源位置
    
    if(source.length>0){
        NSRange range;
        range.location = [source rangeOfString:@">"].location + 1;
        range.length = [source rangeOfString:@"</"].location - range.location;
        _source = [NSString stringWithFormat:@"来自 %@",[source substringWithRange:range]];
    }
    
}
@end
