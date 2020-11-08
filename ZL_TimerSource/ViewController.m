//
//  ViewController.m
//  ZL_TimerSource
//
//  Created by os on 2020/11/8.
//

#import "ViewController.h"
#import "ZLTimerDispatchSource.h"

@interface ViewController ()

@property (nonatomic, strong) ZLTimerDispatchSource *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ZLTimerDispatchSource sharedTimerManager].timeRange = 10;
    [ZLTimerDispatchSource sharedTimerManager].TimeinCall = ^{
        NSLog(@"Hello World");
    };
    [ZLTimerDispatchSource sharedTimerManager].TimeoutCall = ^(NSString *text) {
        NSLog(@"%@", text);
    };
    [[ZLTimerDispatchSource sharedTimerManager] startTimer];
    
    // 恢复时间数据源按钮
    UIButton *btnResume = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    [btnResume setTitle:@"恢复" forState:UIControlStateNormal];
    [btnResume addTarget:self action:@selector(btnResumeClick:) forControlEvents:UIControlEventTouchUpInside];
    btnResume.backgroundColor = [UIColor brownColor];
    [self.view addSubview:btnResume];
    
    // 暂停时间数据源按钮
    UIButton *btnSuppend = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 40)];
    btnSuppend.backgroundColor = [UIColor brownColor];
    [btnSuppend setTitle:@"暂停" forState:UIControlStateNormal];
    [btnSuppend addTarget:self action:@selector(suppendTimerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSuppend];
}


- (void)btnResumeClick:(UIButton *)sender {
    [[ZLTimerDispatchSource sharedTimerManager] resumeTimer];
}

- (void)suppendTimerClick:(UIButton *)sender {
    [[ZLTimerDispatchSource sharedTimerManager] pauseTimer];
}

- (void)dealloc {
    [[ZLTimerDispatchSource sharedTimerManager] stopTimer];
    NSLog(@"走了");
}

@end
