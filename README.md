# ZL_TimerSource

**当App进入后台后，定时器会自动暂停，为了让定时器一直跑我们需要加上下面代码：**

```
- (void)applicationDidEnterBackground:(UIApplication *)application {
        
        UIApplication *app = [UIApplication sharedApplication];
        __block UIBackgroundTaskIdentifier bgTask;
        bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (bgTask != UIBackgroundTaskInvalid) {
                    bgTask = UIBackgroundTaskInvalid;
                }
            });
        }];
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (bgTask != UIBackgroundTaskInvalid) {
                    bgTask = UIBackgroundTaskInvalid;
                }
            });
        });
}
```
