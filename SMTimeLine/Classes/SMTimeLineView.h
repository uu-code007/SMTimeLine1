//
//  MNTimeLineView.h
//  PlaybackTimeLine
//
//  Created by 孙慕 on 2017/11/6.
//  Copyright © 2017年 孙慕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTimeLine.h"
#import "SMRect.h"
#import "SMAnimationView.h"
#import "SMTimeLineConst.h"


@protocol SMTimeLinePresentTime <NSObject>

-(void)timeLinePresentTime:( NSDate * _Nonnull )time;

@end

@interface SMTimeLineView : UIView

@property (nonatomic,weak,null_unspecified) id< SMTimeLinePresentTime > delegate;

/* 时间轴上指示时间的label */
@property (nonatomic,strong,nonnull) UILabel *timeLabel;                                
/* 更新时间轴动画的View */
@property (nonatomic,strong,nonnull) SMAnimationView *updateView;
/* 刻度点颜色 */
@property (nonatomic,strong,nullable) UIColor *graduatedColor;
/* 时间描述文字颜色 */
@property (nonatomic,strong,nullable) UIColor *indicateColor;

/* 设置时间轴时间 */
-(void)setTimeLineWithDate:(nonnull NSDate * )date;


/**
 时间轴上覆盖区域

 @param start 开始时间 UTC
 @param stop 结束时间 UTC
 */
-(void)joinDrawTimeLineRectWithStart:(NSDate *_Nonnull)start stop:(NSDate *_Nonnull)stop;
-(void)updateTimeline;
-(void)removeAllRect;

/** 摆放子控件frame */
- (void)placeSubview;
@end
