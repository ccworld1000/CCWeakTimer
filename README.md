# CCWeakTimer （Microadjustment from [MSWeakTimer](https://github.com/mindsnacks/MSWeakTimer)）

## Description

[Thread-safe `NSTimer` drop-in alternative that doesn't retain the target and supports being used with `GCD` queues.

## Motivation
The first motivation for this class was to have a type of timer that objects could *own* and retain, without this creating a retain cycle ( *like `NSTimer` causes, since it retains its target* ). This way you can just release the timer in the `-dealloc` method of the object class that owns the timer.

The other problem when using `NSTimer` is this note on the documentation:

>**Special Considerations**

>You must send this message from the thread on which the timer was installed. If you send this message from another thread, the input source associated with the timer may not be removed from its run loop, which could prevent the thread from exiting properly.

More often than not, an object needs to create a timer and invalidate it when a certain event occurs. However, doing this when that object works with a private `GCD` queue gets tricky. This timer object is thread safe and doesn't have the notion of run loop, so it can be used with `GCD` queues and installed / invalidated from any thread or queue.

## Implementation
The implementation of `CCWeakTimer` was reviewed and validated by a `libdispatch` (`GCD`) engineer at the WWDC 2013 Core OS Lab.

## How to Use

Create an `CCWeakTimer` object with this class method:

```objc
+ (CCWeakTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                         target:(id)target
                                       selector:(SEL)selector
                                       userInfo:(id)userInfo
                                        repeats:(BOOL)repeats
                                  dispatchQueue:(dispatch_queue_t)dispatchQueue;
```

Check out the code in the [sample app](https://github.com/ccworld1000/CCWeakTimer/blob/master/CCWeakTimerDemo/CCWeakTimerDemo/ViewController.m).

## Installation

- Using [CocoaPods](http://cocoapods.org/):

Just add this line to your `Podfile`:

```
pod 'CCWeakTimer'
```

- Manually:

Simply add the files `CCWeakTimer.h` and `CCWeakTimer.m` to your project.

## Screenshots

![s](https://raw.github.com/ccworld1000/CCWeakTimer/master/Screenshot/s.png)


## Compatibility

- Requires ARC. If you want to use it in a project without ARC, mark ```CCWeakTimer.m``` with the linker flag ```-fobjc-arc```.
- Supports iOS iOS8+ and Mac OSX 10.8+.

## License
`CCWeakTimer` is available under the MIT license. See the LICENSE file for more info.
