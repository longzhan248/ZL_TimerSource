//
//  ZLTimerDispatchSource.h
//  ZL_TimerSource
//
//  Created by os on 2020/11/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TimeoutCallBack)(NSString *text);
typedef void (^TimeinCallBack)(void);

@interface ZLTimerDispatchSource : NSObject

/// 计时时间
@property (nonatomic, assign) NSInteger    timeRange;
/// 计时时间
@property (nonatomic, assign) NSInteger    timeRest;
/// 在计时时调用
@property (nonatomic, copy)   TimeinCallBack       TimeinCall;
/// 在计时结束时调用
@property (nonatomic, copy)   TimeoutCallBack      TimeoutCall;
/// 计时器
@property (nonatomic, strong) dispatch_source_t   timer;

+ (instancetype)sharedTimerManager;
- (void)startTimer;
- (void)pauseTimer;
- (void)resumeTimer;
- (void)stopTimer;

@end
