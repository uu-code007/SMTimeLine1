//
//  ViewController.m
//  SMTimeLine
//
//  Created by 孙慕 on 2017/11/7.
//  Copyright © 2017年 孙慕. All rights reserved.
//

#import "ViewController.h"
#import "SMTimeLineView.h"


@interface ViewController ()<SMTimeLinePresentTime>
@property (nonatomic,strong)SMTimeLineView *timeLine;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
   // self.view.backgroundColor = SMTimeLineFromRGB(0xececec);
    self.timeLine = [[SMTimeLineView alloc] initWithFrame:CGRectMake(0, 300,kWinW,200)];
    _timeLine.delegate = self;
   // _timeLine.userInteractionEnabled = YES;
    
    //    _timeLine.graduatedColor = [UIColor greenColor];
    //    _timeLine.indicateColor  = [UIColor blackColor];
    [self.view addSubview:_timeLine];
    
    [_timeLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timeLine attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0f constant:200.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timeLine attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timeLine attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timeLine attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"刷新" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 100, 100)];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 addTarget:self action:@selector(addRect) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"添加区域" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [_timeLine setTimeLineWithDate:[NSDate date]];
}
-(void)start:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [_timeLine.updateView startUpdateAnimation];
        [_timeLine removeAllRect];
    }else{
        [_timeLine.updateView stopUpdateAnimation];
        
    }
    
}

-(void)addRect{
    int x = arc4random() % 23;
    NSDate *start = [NSDate dateWithTimeIntervalSinceNow:-x * 3600 - 24 * 3600];
    
    NSDate *stop = [NSDate dateWithTimeInterval:23 * 60 * 60 sinceDate:start];
    
    [_timeLine joinDrawTimeLineRectWithStart:start stop:stop];
    [_timeLine updateTimeline];
}

#pragma mark --- MNTimeLineTimeDelegate

-(void)timeLinePresentTime:(NSDate *)time{
    NSTimeInterval cha =  [time timeIntervalSinceDate:[NSDate date]];
   NSLog(@"%@ 时间差%d",time,(int)cha);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end

