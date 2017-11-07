//
//  SMAnimationView.h
//  PlaybackTimeLine
//
//  Created by 孙慕 on 2017/11/6.
//  Copyright © 2017年 孙慕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMAnimationView :UIView

-(instancetype)initWithFrame:(CGRect)frame fromValue:(NSValue *)formValue toValue:(NSValue *)toValue;

-(void)stopUpdateAnimation;
-(void)startUpdateAnimation;

@end
