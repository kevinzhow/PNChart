#PNChart

A simple and beautiful chart lib with animation used in Piner for iOS

[![](http://dl.dropboxusercontent.com/u/1599662/pnchart.png)](http://dl.dropboxusercontent.com/u/1599662/pnchart.png)

## Requirements

PNChart works on iOS 6.0 and later version and is compatible with ARC projects. It depends on the following Apple frameworks, which should already be included with most Xcode templates:

* Foundation.framework
* UIKit.framework
* CoreGraphics.framework
* QuartzCore.framework

You will need LLVM 3.0 or later in order to build PNChart.




## Usage

### Cocoapods

[CocoaPods](http://cocoapods.org) is the recommended way to add PNChart to your project.

1. Add a pod entry for PNChart to your Podfile `pod 'PNChart', '~> 0.1.5'`
2. Install the pod(s) by running `pod install`.
3. Include PNChart wherever you need it with `#import "PNChart.h"`.


### Copy the PNChart folder to your project

```objective-c
  #import "PNChart.h"

  //For LineChart
  PNChart * lineChart = [[PNChart alloc] initWithFrame:CGRectMake(0, 75.0, SCREEN_WIDTH, 200.0)];
  [lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
  [lineChart setYValues:@[@"1",@"10",@"2",@"6",@"3"]];
  [lineChart strokeChart];

  //For BarChart
  PNChart * barChart = [[PNChart alloc] initWithFrame:CGRectMake(0, 75.0, SCREEN_WIDTH, 200.0)];
  barChart.type = PNBarType;
  [barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
  [barChart setYValues:@[@"1",@"10",@"2",@"6",@"3"]];
  [barChart strokeChart];

  //By strokeColor you can change the chart color
  [barChart setStrokeColor:PNTwitterColor];
```

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).

## SpecialThanks

[@lexrus](http://twitter.com/lexrus)  CocoaPods Spec

