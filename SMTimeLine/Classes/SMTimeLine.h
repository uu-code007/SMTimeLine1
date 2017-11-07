//
//  MNTimeLine.h
//  PlaybackTimeLine
//
//  Created by 孙慕 on 2017/11/6.
//  Copyright © 2017年 孙慕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMTimeLine : UIView

@property (nonatomic,strong) NSArray *rectangleArray;
@property (nonatomic,assign) float videoX;
@property (nonatomic,assign) BOOL endDrawRect;
@property (nonatomic,assign) BOOL isUpdateRect;

@property (nonatomic,strong) UIColor *graduatedColor;
@property (nonatomic,strong) UIColor *indicateColor;
@end
