//
//  ZLTimerDispatchSource.m
//  ZL_TimerSource
//
//  Created by os on 2020/11/8.
//

#import "ZLTimerDispatchSource.h"

@interface ZLTimerDispatchSource ()

@property (nonatomic,assign) NSInteger TimeRemain;

@end

@implementation ZLTimerDispatchSource

+ (instancetype)sharedTimerManager {
    
    static ZLTimerDispatchSource *manager =nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        if (manager ==nil) {
            manager = [[self alloc]init];
        }
    });
    
    return manager;
}

//时间计算
- (void)startTimer {
    
    if (self.timeRange <=0) {
        return;
    }
    // 倒计时的时间
    NSInteger deadlineSecond = self.TimeRemain>0?:self.timeRange;
    // 当前时间的时间戳
    NSString *nowStr = [self getCurrentTimeyyyymmdd];
    // 计算时间差值
    CGFloat secondsCountDown = [self getDateDifferenceWithNowDateStr:nowStr deadlineSecond:deadlineSecond];

    __weak __typeof(self) weakSelf = self;
    
    if (_timer == nil) {
        __block NSInteger timeout = secondsCountDown; // 倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout <= 0){ //  当倒计时结束时做需要的操作:
                    dispatch_source_cancel(weakSelf.timer);
                    weakSelf.timer = nil;
                    self.timeRest   = 0;
                    self.TimeRemain = 0;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakSelf.TimeinCall) {
                            weakSelf.TimeinCall();
                        }
                    });
                } else { // 倒计时重新计算 时/分/秒
                    NSInteger days = (int)(timeout/(3600*24));
                    NSInteger hours = (int)((timeout-days*24*3600)/3600);
                    NSInteger minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    NSInteger second = timeout - days*24*3600 - hours*3600 - minute*60;
                    NSString *strTime = [NSString stringWithFormat:@"剩余时间: %02ld分%02ld秒", minute, second];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakSelf.TimeoutCall) {
                            weakSelf.TimeoutCall(strTime);
                        }
                    });
                    timeout--; // 递减 倒计时-1(总时间以秒来计算)
                    self.timeRest = self.timeRange - timeout;
                    self.TimeRemain = timeout;
                }
            });
            dispatch_resume(_timer);
        }
        
    }
}

- (void)pauseTimer {
    if (self.timer) {
        dispatch_suspend(_timer);
    }
}

- (void)resumeTimer {
    if (self.timer) {
        dispatch_resume(_timer);
    }
}

- (void)stopTimer {
    if (self.timer) {
        dispatch_source_cancel(_timer);
        self.timeRest   = 0;
        self.TimeRemain = 0;
        _timer = nil;
    }
}

/**
 *  获取当天的字符串
 *  @return 格式为年-月-日 时分秒
 */
- (NSString *)getCurrentTimeyyyymmdd {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"mm:ss";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
}

/**
 *  获取时间差值  截止时间-当前时间
 *  nowDateStr : 当前时间
 *  deadlineSecond : 计时器秒数
 *  @return 时间戳差值
 */
- (NSInteger)getDateDifferenceWithNowDateStr:(NSString*)nowDateStr deadlineSecond:(CGFloat)deadlineSecond {
    
    NSInteger timeDifference = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss"];
    NSDate *nowDate = [formatter dateFromString:nowDateStr];
    NSTimeInterval oldTime = [nowDate timeIntervalSince1970];
    NSTimeInterval newTime = [nowDate timeIntervalSince1970] + deadlineSecond;
    timeDifference = newTime - oldTime;
    
    return timeDifference;
}

@end
