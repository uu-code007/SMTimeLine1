//
//  NSDate+SMExtension.m
//  PlaybackTimeLine
//
//  Created by 孙慕 on 2017/11/6.
//  Copyright © 2017年 孙慕. All rights reserved.
//

#import "NSDate+SMExtension.h"

@implementation NSDate (SMExtension)

//获取日
- (NSUInteger)getDay{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitDay) fromDate:self];
    return [dayComponents day];
}


- (NSDate *)zeroOfDate{
     NSCalendar *calendar = [NSCalendar currentCalendar];
     NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:self];
     components.hour = 0;
     components.minute = 0;
     components.second = 0;

     // components.nanosecond = 0 not available in iOS
     NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:ts];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return date;
 }

-(NSDate *)getEndDate{
    NSDate *zeroDate = [self zeroOfDate];
    NSDate *endDate = [NSDate dateWithTimeInterval:24 * 60 * 60 - 1 sinceDate:zeroDate];
    return endDate;
}

@end
