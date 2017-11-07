//
//  SMTimeLineConst.h
//  PlaybackTimeLine
//
//  Created by 孙慕 on 2017/11/6.
//  Copyright © 2017年 孙慕. All rights reserved.
//

#import <UIKit/UIKit.h>

// 弱引用
#define SMWeakSelf __weak typeof(self) weakSelf = self;
// 日志输出
#ifdef DEBUG
#define SMTimeLineLog(...) NSLog(__VA_ARGS__)
#else
#define SMTimeLineLog(...)
#endif

#define kWinH [UIScreen mainScreen].bounds.size.height
#define kWinW [UIScreen mainScreen].bounds.size.width

// 过期提醒
#define SMTimeLineDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// RGB颜色
#define SMTimeLineColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define SMTimeLineFromRGB(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

// 文字颜色
#define SMTimeLineLabelTextColor SMTimeLineColor(90, 90, 90)

// 字体大小
#define SMTimeLineLabelFont [UIFont boldSystemFontOfSize:12]

#define SMTimeLineAnimationDefaultColor  SMTimeLineColor(120, 210, 255)

// 常量

UIKIT_EXTERN const CGFloat SMTimeLineCellWidthDefault;
UIKIT_EXTERN const CGFloat SMTimeLineHeight;


