//
//  ViewController.m
//  CCWeakTimerDemo
//
//  Created by CC on 2020/4/20.
//  Copyright © 2020 CC (deng you hua | cworld1000@gmail.com). All rights reserved.
//

#import "ViewController.h"
#import <CCWeakTimer/CCWeakTimer.h>

static const char *CCViewControllerTimerQueueContext = "CCViewControllerTimerQueueContext";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) CCWeakTimer *timer;
@property (strong, nonatomic) CCWeakTimer *backgroundTimer;

@property (strong, nonatomic) dispatch_queue_t privateQueue;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.privateQueue = dispatch_queue_create("com.cc.private_queue", DISPATCH_QUEUE_CONCURRENT);
    self.backgroundTimer = [CCWeakTimer scheduledTimerWithTimeInterval:0.2
                                                                target:self
                                                              selector:@selector(backgroundTimerDidFire)
                                                              userInfo:nil
                                                               repeats:YES
                                                         dispatchQueue:self.privateQueue];
    dispatch_queue_set_specific(self.privateQueue, (__bridge const void *)self, (void *)CCViewControllerTimerQueueContext, NULL);
}

- (void)dealloc
{
    [_timer invalidate];
    [_backgroundTimer invalidate];
}

- (IBAction)toggleTimer:(UIButton *)sender {
    static NSString *kStopTimerText = @"Stop";
    static NSString *kStartTimerText = @"Start";

    NSString *currentTitle = [sender titleForState:UIControlStateNormal];

    if ([currentTitle isEqualToString:kStopTimerText])
    {
        [sender setTitle:kStartTimerText forState:UIControlStateNormal];
        [self.timer invalidate];
    }
    else
    {
        [sender setTitle:kStopTimerText forState:UIControlStateNormal];
        self.timer = [CCWeakTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(mainThreadTimerDidFire:)
                                                        userInfo:nil
                                                         repeats:YES
                                                   dispatchQueue:dispatch_get_main_queue()];
    }
}

- (IBAction)fireTimer
{
    [self.timer fire];
}


- (void)mainThreadTimerDidFire:(CCWeakTimer *)timer
{
    NSAssert([NSThread isMainThread], @"This should be called from the main thread");

    self.label.text = [NSString stringWithFormat:@"%ld", [self.label.text integerValue] + 1];
}

- (void)backgroundTimerDidFire
{
    NSAssert(![NSThread isMainThread], @"This shouldn't be called from the main thread");

    const BOOL calledInPrivateQueue = dispatch_queue_get_specific(self.privateQueue, (__bridge const void *)(self)) == CCViewControllerTimerQueueContext;
    NSAssert(calledInPrivateQueue, @"This should be called on the provided queue");
}


@end
