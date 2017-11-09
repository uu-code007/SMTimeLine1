//
//  MNTimeLineView.m
//  PlaybackTimeLine
//
//  Created by 孙慕 on 2017/11/6.
//  Copyright © 2017年 孙慕. All rights reserved.
//
//  以[NSDate date] 为参考系 
#import "SMTimeLineView.h"

#import "NSDate+SMExtension.h"

@interface SMTimeLineView()<UICollectionViewDelegate,UICollectionViewDataSource>
/** 报警区域的数组*/
@property (nonatomic,strong,nonnull) NSMutableArray *rectDateArray;

// 关于时间轴的属性
/** 放大手势*/
@property (nonatomic,nullable,strong) UIPinchGestureRecognizer *PinchGestureRecognizer;

/** 一天的View的宽度*/
@property (nonatomic,assign) float CellWidth;

/** 每隔对应的时间*/
@property (nonatomic,assign) float unitTime;

/** 每隔对应的长度*/
@property (nonatomic,assign) float unitLength;

/** 时间最大偏移量（当前时间）*/
@property (nonatomic,assign) float maxContentOffsetX;

/** 时间轴最小偏移量（七天前）*/
@property (nonatomic,assign) float minContentOffsetX;

/** 绘图的View*/
@property (nonatomic,strong,nonnull) SMTimeLine *timeLine;

/** View加在collction实现重用*/
@property (nonatomic,strong,nonnull) UICollectionView *timeLineCollction;

/** 放大缩小*/
@property (nonatomic,assign) float addX;

/** 放大时标记可视区域，不断重绘时只绘制可视区域，最后绘制完整一次*/
@property (nonatomic,assign) float videoX;

/** 区分是否是最后一次*/
@property (nonatomic,assign) BOOL endDrawRect;


/**时间转换*/
@property (strong, nonatomic,nonnull) NSDateFormatter           *dateFormat;
@property (nonatomic,strong,nonnull)NSCalendar *calendar;
@property (nonatomic,strong,nonnull)NSDateComponents *comps;

/**报警区域的数组*/
@property (nonatomic,strong) NSMutableArray *rectangleArray;


@end
@implementation SMTimeLineView

static NSString * CellIdentifier = @"TimeLinecell";
static const NSInteger kTimeLineNumberOfDays = 7;


-(NSDateFormatter *)dateFormat{
    if (!_dateFormat) {
        _dateFormat = [[NSDateFormatter alloc] init];
        [_dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
    }
    return _dateFormat;
}
-(NSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _calendar;
}

-(NSDateComponents *)comps{
    if (!_comps) {
        _comps = [[NSDateComponents alloc] init];
    }
    return _comps;
}


-(SMAnimationView *)updateView{
    if (!_updateView) {
        _updateView = [[SMAnimationView alloc] initWithFrame:CGRectZero fromValue:[NSValue valueWithCGPoint:CGPointMake(0, 0)] toValue:[NSValue valueWithCGPoint:CGPointMake(kWinW, 0)]];
        [self addSubview:_updateView];
        
        [_updateView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_updateView attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_timeLineCollction attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_updateView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SMTimeLineHeight]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_updateView attribute:NSLayoutAttributeWidth     relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_updateView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_timeLineCollction attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    }
    return _updateView;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initDateArray];
        [self initTimeLineWithFrame:frame];

    }
    return self;
}

-(void)initDateArray{
    _rectangleArray = [[NSMutableArray alloc] init];
    _rectDateArray = [NSMutableArray array];
    for (int i = 0; i < kTimeLineNumberOfDays + 1; i ++) {
        NSMutableArray *mutArray = [[NSMutableArray alloc] init];
        [_rectDateArray addObject:mutArray];
        
        NSMutableArray *mutArray2 = [[NSMutableArray alloc] init];
        [_rectangleArray addObject:mutArray2];
    }

}

#pragma mark 时间轴初始化
-(void)initTimeLineWithFrame:(CGRect)frame{
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滚动方向
    flowLayout.minimumLineSpacing = 0;//行间距(最小值)
    flowLayout.minimumInteritemSpacing = 0;//item间距(最小值)
    self.timeLineCollction = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWinW, SMTimeLineHeight) collectionViewLayout:flowLayout];
    [self addSubview:self.timeLineCollction];
    self.timeLineCollction.backgroundColor = [UIColor clearColor];
    self.timeLineCollction.userInteractionEnabled = YES;
    self.timeLineCollction.showsVerticalScrollIndicator = NO;
    
    //collection 注册Cell
    [self.timeLineCollction registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    //collection位置和单元格属性
    self.CellWidth = SMTimeLineCellWidthDefault;
    [self updatelabelText];
    NSDate *date=[NSDate date];
    [self.dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    float x = [self timeLineXAboutpresentTime:date];
    self.timeLineCollction.contentOffset =CGPointMake(self.CellWidth * kTimeLineNumberOfDays + x - kWinW/2,0);
    self.timeLineCollction.delegate = self;
    self.timeLineCollction.dataSource = self;
    
    self.endDrawRect = YES;
   
    //添加放大缩小手势
    self.PinchGestureRecognizer
    = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinches:)];
    [self.timeLineCollction addGestureRecognizer:self.PinchGestureRecognizer];
    
    //添加约束
    [self.timeLineCollction setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLineCollction attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self attribute:NSLayoutAttributeWidth
                                                       multiplier:1.0f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLineCollction attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SMTimeLineHeight]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLineCollction attribute:NSLayoutAttributeCenterY     relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLineCollction attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self initTimeLineRedViewAndLabel];
}

-(void)initTimeLineRedViewAndLabel{
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    [self addSubview:redView];
    redView.tag = 101;
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = SMTimeLineLabelFont;
    self.timeLabel.backgroundColor = SMTimeLineColor(110, 205, 245);
    self.timeLabel.layer.masksToBounds = YES;
    self.timeLabel.layer.cornerRadius = 15;
    float x = [self timeLineXAboutpresentTime:[NSDate date]];
    self.maxContentOffsetX = self.CellWidth * kTimeLineNumberOfDays + x - kWinW/2;
    self.timeLabel.text = [self setLabelTextWithOffset:self.timeLineCollction.contentOffset.x];
    [self.timeLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:self.timeLabel];
    
    [redView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.timeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [redView addConstraint:[NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0f constant:2.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_timeLineCollction attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_timeLineCollction attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
     [self addConstraint:[NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_timeLineCollction attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0f constant:130.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0f constant:30.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_timeLineCollction attribute:NSLayoutAttributeCenterY multiplier:1 constant:-64]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_timeLineCollction attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

}


#pragma mark --UICollectionViewDelegate

// 定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section{
    return kTimeLineNumberOfDays + 1;
}

// 定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:( UICollectionView *)collectionView{
    return 1;
}

// 每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.timeLineCollction) {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        self.timeLine = [[SMTimeLine alloc] initWithFrame:CGRectMake(0, 0, self.CellWidth , SMTimeLineHeight)];
        if (self.rectangleArray[indexPath.row]) {
            self.timeLine.rectangleArray = self.rectangleArray[indexPath.row];
        }
        
        self.timeLine.videoX = self.videoX;
        self.timeLine.endDrawRect = self.endDrawRect;
        self.timeLine.graduatedColor = self.graduatedColor;
        self.timeLine.indicateColor  = self.indicateColor;
        
        //新建
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
        [cell.contentView addSubview:self.timeLine];
        return cell;
    }
    return nil;
}


#pragma mark --UICollectionViewDelegateFlowLayout

// 定义每个UICollectionView 的大小
- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath{
    return CGSizeMake(_CellWidth,SMTimeLineHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.timeLineCollction == scrollView) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(timeLinePresentTime:)]) {
            [self.delegate timeLinePresentTime:[self dateWithOffSet:scrollView.contentOffset.x]];
        }
        
        
        // 当前时间对应今天的偏移量
        NSDate *date=[NSDate date];
        
        // 重新计算时间label时间
        float x = [self timeLineXAboutpresentTime:date];
        self.maxContentOffsetX = self.CellWidth * 7 + x - kWinW/2;
        // 走到下一天还未更新列表示，下一天的报警区域，不该画上去BUG
        //        NSDate *curDate = [self.dateFormat dateFromString:self.timeLabel.text];
        //        float curOfset = [self timeLineXAboutpresentTime:curDate];
        //        if ((curOfset < (kWinW/2 + 10) ) || (self.CellWidth - curOfset) < (kWinW/2 + 10)) {
        //            self.isUpDate = NO;
        //        }
        
        if(scrollView.contentOffset.x < self.maxContentOffsetX || (scrollView.contentOffset.x > (x - kWinW/2))){
            //在时间轴表示时间范围内，时间label才会走
            self.timeLabel.text = [self setLabelTextWithOffset:scrollView.contentOffset.x];
            //回调出当前时间
            //     [self.delegate SMTimeLinePresentTime:[self datewithOffSet:scrollView.contentOffset.x]];
            
        }
        if (scrollView.contentOffset.x > self.maxContentOffsetX) {
            self.timeLineCollction.contentOffset = CGPointMake(self.maxContentOffsetX,0);
            
        }else if (scrollView.contentOffset.x < (x - kWinW/2)){
            
            self.timeLineCollction.contentOffset = CGPointMake((x - kWinW/2), 0);
        }
        
    }
}


#pragma mark - 手势方法
-(void)handlePinches:(UIPinchGestureRecognizer *)pinch{
    // self.isUpdateRect = YES;
    if (pinch.state == UIGestureRecognizerStateChanged) {
        
        int touchCount = (int )pinch.numberOfTouches;
        SMTimeLineLog(@"手势放大比例%f",pinch.scale);
        
        if (touchCount == 2) {
            
            CGPoint p1 = [pinch locationOfTouch: 0 inView:self.timeLineCollction];
            
            CGPoint p2 = [pinch locationOfTouch: 1 inView:self.timeLineCollction];
            
            self.addX =  (p1.x+p2.x)/(2 * self.CellWidth) * 1440;
            
        }
        
        if (pinch.scale > 1) {
            if (self.CellWidth < 45000) {
                self.CellWidth = self.CellWidth + 1440;
                [self updatelabelText];
                [self updateRect];
                self.videoX = (int)(self.timeLineCollction.contentOffset.x + self.addX) % (int)self.CellWidth;
                self.endDrawRect = NO;
                [self.timeLineCollction reloadData];
                self.timeLineCollction.contentOffset =CGPointMake(self.timeLineCollction.contentOffset.x + self.addX,0);
            }
        }else{
            if (self.CellWidth > 1440) {
                self.CellWidth = self.CellWidth - 1440;
                [self updatelabelText];
                [self updateRect];
                self.videoX = (int)(self.timeLineCollction.contentOffset.x - self.addX) % (int)self.CellWidth;
                self.endDrawRect = NO;
                [self.timeLineCollction reloadData];
                self.timeLineCollction.contentOffset =CGPointMake(self.timeLineCollction.contentOffset.x - self.addX,0);
            }
        }
    }
    
    if (pinch.state == UIGestureRecognizerStateEnded) {
        [self updateRect];
        self.endDrawRect = YES;
        [self.timeLineCollction reloadData];
    }
}


#pragma mark - 重新计算单元格宽。单元格代表的时长
-(void)updatelabelText{
    // 当每格宽度大于60的时候一天分成7200格
    if (self.CellWidth > 60 * 720) {
        self.unitTime = 24 * 3600 / 7200;
        self.unitLength = self.CellWidth / 7200;
        
    }else if (self.CellWidth > 30 * 720){
        self.unitTime = 24 * 3600 / 3600;
        self.unitLength = self.CellWidth / 3600;
        
    }
    else{
        self.unitTime = 24 * 3600 / 720;
        self.unitLength = self.CellWidth / 720;
        
    }
    
    
    NSDate *date=[NSDate date];
    float x = [self timeLineXAboutpresentTime:date];
    self.maxContentOffsetX = self.CellWidth * kTimeLineNumberOfDays + x - kWinW/2;
    self.timeLabel.text = [self setLabelTextWithOffset:self.timeLineCollction.contentOffset.x];
    
}


#pragma mark - 某个偏移对应的时间
-(NSString *)setLabelTextWithOffset:(float)setX{
    //与最后时间的差
    int cha = (self.CellWidth * (kTimeLineNumberOfDays + 1) - setX - kWinW/2)/self.unitLength * self.unitTime;
    NSDate *date = [NSDate dateWithTimeInterval:-cha sinceDate:[[NSDate date] getEndDate]];
    NSString *timestr = [self.dateFormat stringFromDate:date];
    return timestr;
}


-(NSDate *)dateWithOffSet:(float)setX{
    //与最后时间的差
    int cha = (self.CellWidth * (kTimeLineNumberOfDays + 1) - setX - kWinW/2)/self.unitLength * self.unitTime;
    NSDate *date = [NSDate dateWithTimeInterval:-cha sinceDate:[[NSDate date] getEndDate]];
    
    return date;
}

#pragma mark - 当前时间对应当天偏移量的位置
-(float)timeLineXAboutpresentTime:(NSDate *)date{
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    self.comps = [self.calendar components:unitFlags fromDate:date];
    NSInteger hour = [self.comps hour];
    NSInteger min = [self.comps minute];
    NSInteger sec = [self.comps second];
    NSTimeInterval cha = hour * 3600 + min * 60 + sec ;
    float x = (cha/self.unitTime) * self.unitLength;
    return x;
}




#pragma mark - 任意时间对应偏移量的位置
-(double)getPositionOffsetForDate:(NSDate *)date{
    
    NSDate *maxDate = [[NSDate date] getEndDate];
    NSTimeInterval end = [maxDate timeIntervalSince1970]*1;
    NSTimeInterval start = [date timeIntervalSince1970]*1;
    NSTimeInterval cha = end - start;
    //self.CellWidth * (kTimeLineNumberOfDays + 1) 对应  今天的 23：59：59
    double x =  self.CellWidth * (kTimeLineNumberOfDays + 1) - (cha / self.unitTime) * self.unitLength;
    
    return x - kWinW/2;
}

#pragma mark - 时间轴走动
-(void)setTimeLineWithDate:(nonnull NSDate * )date{
    float x = [self getPositionOffsetForDate:date];
    self.timeLineCollction.contentOffset = CGPointMake(x, 0);
    self.timeLabel.text = [self setLabelTextWithOffset:x];

}


#pragma mark - 插入覆盖区域
-(void)joinDrawTimeLineRectWithStart:(NSDate *)start stop:(NSDate *)stop{
    
    NSAssert([stop timeIntervalSince1970]*1 - [[NSDate date] timeIntervalSince1970]*1, @"Can not join the future time");
    NSAssert(([stop timeIntervalSince1970]*1 - [start timeIntervalSince1970]*1) < 24 * 3600 , @"The time slice should not exceed 24 hours");
    if ([start getDay] == [stop getDay] ) {//同一天
        SMRect *rect = [[SMRect alloc] init];
        rect.stop_time = stop;
        rect.start_time = start;
        
        float offSetX = [self getPositionOffsetForDate:start];
        NSInteger index = (offSetX + kWinW/2) / (int)self.CellWidth;
        
        [self.rectDateArray[index] addObject:rect];
    }else{//跨一天
        SMRect *rect1 = [[SMRect alloc] init];
        rect1.stop_time = stop;
        rect1.start_time = [stop zeroOfDate];
        float offSetX = [self getPositionOffsetForDate:stop];
        NSInteger index = (offSetX + kWinW/2) / (int)self.CellWidth;
        [self.rectDateArray[index] addObject:rect1];
        
        SMRect *rect2 = [[SMRect alloc] init];
        rect2.stop_time = [start getEndDate];
        rect2.start_time = start;
        float offSetX2 = [self getPositionOffsetForDate:start];
        NSInteger index2 = (offSetX2 + kWinW/2) / (int)self.CellWidth;
        [self.rectDateArray[index2] addObject:rect2];
    }

}

-(void)updateRect{
    for (int i = 0 ; i < self.rectDateArray.count; i ++) {
         [self.rectangleArray[i] removeAllObjects];
        for (SMRect *rect in self.rectDateArray[i]) {
            float startX = [self timeLineXAboutpresentTime:rect.start_time];
            float stopX = [self timeLineXAboutpresentTime:rect.stop_time];
            if ((stopX - startX) > 0){
                CGRect rectangleRect = CGRectMake(startX, 0, stopX - startX, SMTimeLineHeight);
                NSValue *value = [NSValue valueWithCGRect:rectangleRect];
                [self.rectangleArray[i] addObject:value];
            }
        }
    }
 }

-(void)updateTimeline{
    [self updateRect];
    [self.timeLineCollction reloadData];
    
}


-(void)removeAllRect{
    for (NSMutableArray *array in _rectDateArray) {
        [array removeAllObjects];
    }
    
    for (NSMutableArray *array in _rectangleArray) {
        [array removeAllObjects];
    }
}


/* 子类化布局 */
- (void)layoutSubviews
{
    [self placeSubview];
    
    [super layoutSubviews];
}

-(void)placeSubview{
    
}


@end
