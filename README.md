
##### 使用CocoaPods

```
pod "SMTimeLine"
```

##### 手动导入

将Classes文件夹中的所有源代码拽入项目中

导入主头文件：#import "SMTimeLineView.h"

##### 示例

###### 初始化

```
  self.timeLine = [[SMTimeLineView alloc] initWithFrame:CGRectMake(0, 300,kWinW,200)];
  _timeLine.delegate = self;
  [self.view addSubview:_timeLine];
``` 

###### 时间回调

```
#pragma mark --- MNTimeLineTimeDelegate

-(void)timeLinePresentTime:(NSDate *)time{
    NSTimeInterval cha =  [time timeIntervalSinceDate:[NSDate date]];
    NSLog(@"%@ 时间差%d",time,(int)cha);
}
```   

###### 设置时间指示位置

```
[_timeLine setTimeLineWithDate:[NSDate date]];
```

###### 添加标记区域

```
-(void)addRect{
    int x = arc4random() % 23;
    NSDate *start = [NSDate dateWithTimeIntervalSinceNow:-x * 3600 - 24 * 3600];
    
    NSDate *stop = [NSDate dateWithTimeInterval:23 * 60 * 60 sinceDate:start];
    
    [_timeLine joinDrawTimeLineRectWithStart:start stop:stop];
    [_timeLine updateTimeline];
}
```

###### 刷新动画

```
[_timeLine.updateView startUpdateAnimation];
[_timeLine.updateView stopUpdateAnimation];
```

如有问题：ios_sunmu@icloud.com
