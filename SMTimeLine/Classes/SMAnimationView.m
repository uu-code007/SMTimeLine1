//
//  SMAnimationView.m
//  PlaybackTimeLine
//
//  Created by 孙慕 on 2017/11/6.
//  Copyright © 2017年 孙慕. All rights reserved.
//

#import "SMAnimationView.h"
#import "SMTimeLineConst.h"

@implementation SMAnimationView
-(instancetype)initWithFrame:(CGRect)frame fromValue:(NSValue *)formValue toValue:(NSValue *)toValue{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor  = SMTimeLineAnimationDefaultColor;
        self.alpha = 0.5;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        
        //    animation.toValue = x;
        animation.fromValue = formValue;      // 起始点
        animation.toValue = toValue; // 终了点
        animation.duration = 0.5;
        
        animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
        animation.repeatCount = LONG_MAX;
        
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        [self.layer addAnimation:animation forKey:nil];
    }
    
    return  self;
}

-(void)stopUpdateAnimation{
    self.hidden = YES;
};
-(void)startUpdateAnimation{
    self.hidden = NO;
    
};
@end
