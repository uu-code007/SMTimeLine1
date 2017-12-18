//
//  MNTimeLine.m
//  PlaybackTimeLine
//
//  Created by 孙慕 on 2017/11/6.
//  Copyright © 2017年 孙慕. All rights reserved.
//

#import "SMTimeLine.h"
#import "SMTimeLineConst.h"

@interface SMTimeLine (){
    float m_nStartX;
    float m_nEndX;
    float currentOffsetX;
    CGContextRef context;
    BOOL ok;
}
// 储存可视区域的视图及其index
@property (nonatomic, strong) NSMutableDictionary *visibleListViewsItems;

@end

@implementation SMTimeLine


-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        m_nStartX = 1;
        m_nEndX = self.frame.size.width;
        self.backgroundColor = [UIColor clearColor];
        _indicateColor = [UIColor redColor];
        self.graduatedColor = [UIColor grayColor];
    }
    return self;
}


-(void)drawRect:(CGRect)rect{
    
    context = UIGraphicsGetCurrentContext();
    
    CGContextSynchronize(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    
    CGContextSetLineWidth(context, 1.0);
    
    CGContextSetStrokeColorWithColor(context, self.graduatedColor.CGColor);
    
    CGContextBeginPath(context);
    
    
    float nDeltaX = (m_nEndX - m_nStartX  + 1) / 720;
    
    if (!self.endDrawRect) {
        
        if (nDeltaX > 60) {
            float mDeltaX = (m_nEndX - m_nStartX  + 1) /7200;
            int m = self.videoX / mDeltaX;
            int y = kWinW / mDeltaX;
            for (int x = m; x < y + m + 2; x ++){//m为屏幕起点index，y + 2一共绘制条数
                if ((1 + x*mDeltaX) > m_nEndX) {
                    [self drawRectSizeA:(x - m_nEndX/mDeltaX) mDeltaX:mDeltaX];
                }else{
                    [self drawRectSizeA:x mDeltaX:mDeltaX];
                    
                }
            }
        }else if (nDeltaX > 35){
            float mDeltaX = (m_nEndX - m_nStartX  + 1) /3600;
            int m = self.videoX / mDeltaX;
            int y = kWinW / mDeltaX;
            for (int x = m; x < y + m + 2; x ++){
                if ((1 + x*mDeltaX) > m_nEndX) {
                    [self drawRectSizeB:(x - m_nEndX/mDeltaX) nDeltaX:mDeltaX];
                }else{
                    [self drawRectSizeB:x nDeltaX:mDeltaX];
                    
                }
                
            }
            
        }
        
        else{
            int m = self.videoX / nDeltaX;
            int y = kWinW / nDeltaX;
            
            for (int x = m; x < y + m + 2; x ++){
                if ((1 + x*nDeltaX) > m_nEndX) {
                    [self drawRectSizeC:(x - m_nEndX/nDeltaX) nDeltaX:nDeltaX];
                }else{
                    [self drawRectSizeC:x nDeltaX:nDeltaX];
                }
                
            }
        }
        
    }else{
        
        if (nDeltaX > 60) {
            float mDeltaX = (m_nEndX - m_nStartX  + 1) /7200;
            for (int x = 0; x < 7200; x ++){
                [self drawRectSizeA:x mDeltaX:mDeltaX];
            }
            
        }else if (nDeltaX > 35){
            float mDeltaX = (m_nEndX - m_nStartX  + 1) /3600;
            for (int x = 0; x < 3600; x ++){
                [self drawRectSizeB:x nDeltaX:mDeltaX];
            }
            
        }
        
        else{
            for (int x = 0; x < 720; x ++){
                [self drawRectSizeC:x nDeltaX:nDeltaX];
                
            }
            
        }
        
        
        //报警区域
        for (NSValue *value in self.rectangleArray) {
            CGRect rect = [value CGRectValue];
            [self drawRectangle:rect];
        }
        CGContextSynchronize(context);
        CGContextSetLineCap(context, kCGLineCapSquare);
        
        CGContextSetLineWidth(context, 1.0);
        
        //        CGContextSetRGBStrokeColor(context, 1.f, 128/255.f, 37/255.f, 1.0);
        CGContextSetStrokeColorWithColor(context, self.graduatedColor.CGColor);
        
        CGContextBeginPath(context);
        
    }
    
}
-(void)drawTimeLabel:(NSString *)str X: (float)x{
    CGPoint point = CGPointMake(x, 30);
    
    [str drawAtPoint:point withAttributes:@{NSFontAttributeName:
                                                [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.f],
                                            NSForegroundColorAttributeName:self.indicateColor
                                            }];
       CGContextSetStrokeColorWithColor(context, self.graduatedColor.CGColor);
}

-(void)drawRectSizeA:(int)x mDeltaX:(float)mDeltaX{
    if (x % 7200){
//        if (x % 3600) {
            if (x % 300) {
                if (x % 10) {
                        [self drawScaleWithX:(1 + x*mDeltaX) Y:self.frame.size.height  Height:5];
                        [self drawScaleWithX:(1 + x*mDeltaX) Y:5 Height:5];
                    
                }else{
                    [self drawScaleWithX:(1 + x*mDeltaX) Y:self.frame.size.height  Height:15];
                    [self drawScaleWithX:(1 + x*mDeltaX) Y:15 Height:15];
                    if (x/5 > 60) {
                            NSString *str = [NSString stringWithFormat:@"%d:%02d",x/5/60,(x/5) % 60];
                            [self drawTimeLabel:str X:1 + x*mDeltaX];
                    }else{
                            NSString *str = [NSString stringWithFormat:@"00:%02d",x/5];
                            [self drawTimeLabel:str X:1 + x*mDeltaX];
                            
                    }
                }
       
                
            }else{
                [self drawScaleWithX:(1 + x*mDeltaX) Y:self.frame.size.height Height:25];
                [self drawScaleWithX:(1 + x*mDeltaX) Y:25 Height:25];

                NSString *str  =[NSString stringWithFormat:@"%d:00",x/300];
                [self drawTimeLabel:str X:1 + x*mDeltaX];
            }
//        }else{
//            [self drawScaleWithX:(1 + x*mDeltaX) Y:self.frame.size.height Height:self.frame.size.height];
//            [self drawTimeLabel:@"12:00" X:1 + x*mDeltaX];
//        }
    }else{
        [self drawScaleWithX:(1 + x*mDeltaX) Y:self.frame.size.height Height:self.frame.size.height];
        [self drawTimeLabel:@"00:00" X:1 + x*mDeltaX];
    }
}

-(void)drawRectSizeB:(int)x nDeltaX:(float)nDeltaX{
    if (x % 3600) {
//        if (x % 1800){
            if (x % 150) {
                if (x % 5) {
                    [self drawScaleWithX:(1 + x*nDeltaX) Y:self.frame.size.height Height:5];
                    [self drawScaleWithX:(1 + x*nDeltaX) Y:5 Height:5];
                
                }else{
                    [self drawScaleWithX:(1 + x*nDeltaX) Y:self.frame.size.height Height:10];
                    [self drawScaleWithX:(1 + x*nDeltaX) Y:10 Height:10];
                    if (x/5 > 30) {
                              NSString *str = [NSString stringWithFormat:@"%d:%02d",x/150,((x/5)* 2) % 60];
                            [self drawTimeLabel:str X:1 + x*nDeltaX];
                        
                    }else{
                            NSString *str = [NSString stringWithFormat:@"00:%02d",((x/5)* 2) % 60];
                            [self drawTimeLabel:str X:1 + x*nDeltaX];
                    }
//                    NSString *str  =[NSString stringWithFormat:@"%d:%d",x/150,((x/5) % 60) * 2];
//                    [self drawTimeLabel:str X:(1 + x*nDeltaX)];
//                    
                }
                
            }else{
                [self drawScaleWithX:(1 + x*nDeltaX) Y:self.frame.size.height  Height:15];
                [self drawScaleWithX:(1 + x*nDeltaX) Y:15 Height:15];

                NSString *str  =[NSString stringWithFormat:@"%d:00",x/150];
                [self drawTimeLabel:str X:1 + x*nDeltaX];
            }
//        }else{
//            [self drawScaleWithX:(1 + x*nDeltaX) Y:self.frame.size.height  Height:self.frame.size.height];
//            [self drawTimeLabel:@"12:00" X:1 + x*nDeltaX];
//        }
    }else{
        [self drawScaleWithX:(1 + x*nDeltaX) Y:self.frame.size.height Height:self.frame.size.height];
        [self drawTimeLabel:@"00:00" X:1];
        
    }

}
-(void)drawRectSizeC:(int)x nDeltaX:(float)nDeltaX{
    if (x % 720) {
//        if (x % 360){
            if (x % 30) {
                if (x % 5) {
                    [self drawScaleWithX:(1 + x*nDeltaX) Y:self.frame.size.height  Height:5];
                    [self drawScaleWithX:(1 + x*nDeltaX) Y:5 Height:5];

                    
                }else{
                    [self drawScaleWithX:(1 + x*nDeltaX) Y:self.frame.size.height Height:10];
                    [self drawScaleWithX:(1 + x*nDeltaX) Y:10 Height:10];
                    if (nDeltaX > 8) {
                        if (x > 30) {
                            NSString *str = [NSString stringWithFormat:@"%d:%d0",x/30,(x/5) % 6];
                            [self drawTimeLabel:str X:1 + x*nDeltaX];
                            
                            
                        }else{
                                 NSString *str = [NSString stringWithFormat:@"0%d:%d0",x/30,(x/5) % 6];
                                [self drawTimeLabel:str X:1 + x*nDeltaX];
                                
                         }

                    }

                }
                
            }else{
                [self drawScaleWithX:(1 + x*nDeltaX) Y:self.frame.size.height Height:15];
                [self drawScaleWithX:(1 + x*nDeltaX) Y:15 Height:15];

                NSString *str  =[NSString stringWithFormat:@"%d:00",x/30];
                [self drawTimeLabel:str X:1 + x*nDeltaX];
            }
//        }else{
//            [self drawScaleWithX:(1 + x*nDeltaX) Y:self.frame.size.height Height:self.frame.size.height];
//            [self drawTimeLabel:@"12:00" X:1 + x*nDeltaX];
//        }
    }else{
        [self drawScaleWithX:(1 + x*nDeltaX) Y:self.frame.size.height Height:self.frame.size.height];
        [self drawTimeLabel:@"00:00" X:1];
        
    }
}
-(void)drawScaleWithX:(float)nX Y:(float)nY Height:(float)nHeight{
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, nX, nY);

    CGContextAddLineToPoint(context, nX, nY - nHeight);
    CGContextStrokePath(context);
    
    
//    UIBezierPath *aPath = [UIBezierPath bezierPath];
//    [aPath moveToPoint:CGPointMake(nX, nY)];
//    [aPath addLineToPoint:CGPointMake(nX,nY - nHeight)];
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.strokeColor = self.graduatedColor.CGColor;
//    layer.path = aPath.CGPath;
//    layer.lineWidth = 1.0;
//    layer.fillColor = nil;
//    [self.layer addSublayer:layer];
}

//画矩形
-(void)drawRectangle:(CGRect)rect{
   // CGContextBeginPath(context);
    //CGContextStrokeRect(context, rect);
     CGContextSetRGBFillColor(context, 50/255.0f,128/255.0f,224/255.0f, 0.3);

    CGContextFillRect(context, rect);
 
    //CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1);
    //设置画笔线条粗细
    CGContextSetLineWidth(context, 0.5);
    //画矩形边框
    CGContextAddRect(context,rect);
    
    CGContextStrokePath(context);
    
    
//    CGContextSynchronize(context);
//    CGContextSetLineCap(context, kCGLineCapSquare);

}

-(void)setIndicateColor:(UIColor *)indicateColor{
    if (indicateColor) {
        _indicateColor = indicateColor;
    }
}

-(void)setGraduatedColor:(UIColor *)graduatedColor{
    if (graduatedColor) {
        _graduatedColor = graduatedColor;
    }
}
 

@end
