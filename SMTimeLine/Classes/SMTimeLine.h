//
//  MNTimeLine.h
//  PlaybackTimeLine
//
//  Created by 孙慕 on 2017/11/6.
//  Copyright © 2017年 孙慕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMTimeLine : UIView

/* 有视频区域加覆盖图层 */
@property (nonatomic,strong) NSArray *rectangleArray;
/* 屏幕可视区域起点（连续缩放只绘制可视区域） */
@property (nonatomic,assign) float videoX;
/* 绘制所有刻度接口 */
@property (nonatomic,assign) BOOL endDrawRect;
/* 刻度颜色 */
@property (nonatomic,strong) UIColor *graduatedColor;
/* 指示文字颜色 */
@property (nonatomic,strong) UIColor *indicateColor;
@end
