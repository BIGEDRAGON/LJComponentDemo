# Top Reflesh Control
![License](https://img.shields.io/cocoapods/l/TWPhotoPicker.svg)
![Platform](https://img.shields.io/cocoapods/p/TWPhotoPicker.svg)

A simple top reflesh control for scrollview/tableview.

## Snapshot

![Snapshot](https://raw.githubusercontent.com/jacoli/FMTopRefleshControl/master/snapshot.gif)

## Installation

With [CocoaPods](http://cocoapods.org/), add this line to your `Podfile`.

```
pod 'FMTopReflesh'
```

and run `pod install`, then you're all done!

Or copy FMTopRefleshControl.h FMTopRefleshControl.m to your project.

## How to use

Implement `FMTopRefleshControlTopView` protocol

```
- (void)pullToReflesh {
    //self.backgroundColor = [UIColor blueColor];
    self.textLabel.text = @"pull to relfesh";
}

- (void)releaseToReflesh {
    //self.backgroundColor = [UIColor yellowColor];
    self.textLabel.text = @"release to relfesh";
}

- (void)startReflesh {
    //self.backgroundColor = [UIColor redColor];
    [self.indicator startAnimating];
    self.textLabel.text = @"relfesh...";
}

- (void)refleshFinished {
    //self.backgroundColor = [UIColor whiteColor];
    [self.indicator stopAnimating];
    self.textLabel.text = nil;
}
```

Config reflesh control

```
    self.refleshControl = [[FMTopRefleshControl alloc] initWithScrollView:v withRefleshCallback:^(FMTopRefleshControl *control) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [control endReflesh];
        });
    } withTopView:[[CustomTopRefleshView alloc] initWithFrame:[UIScreen mainScreen].bounds]];

```

## Requirements

* iOS 7.0+ 
* ARC