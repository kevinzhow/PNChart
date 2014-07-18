#PNChart

[![Build Status](https://travis-ci.org/kevinzhow/PNChart.png?branch=master)](https://travis-ci.org/kevinzhow/PNChart)

You can also find swift version at here https://github.com/kevinzhow/PNChart-Swift

A simple and beautiful chart lib with **animation** used in [Piner](https://itunes.apple.com/us/app/piner/id637706410) and [CoinsMan](https://itunes.apple.com/us/app/coinsman/id772163893) for iOS

[![](https://dl.dropboxusercontent.com/u/1599662/pnchart.gif)](https://dl.dropboxusercontent.com/u/1599662/pnchart.gif)

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

1. Add a pod entry for PNChart to your Podfile `pod 'PNChart', '~> 0.5'`
2. Install the pod(s) by running `pod install`.
3. Include PNChart wherever you need it with `#import "PNChart.h"`.


### Copy the PNChart folder to your project


[![](https://dl.dropboxusercontent.com/u/1599662/line.png)](https://dl.dropboxusercontent.com/u/1599662/line.png)

```objective-c
  #import "PNChart.h"

  //For LineChart
  PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
  [lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];

  // Line Chart No.1
  NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2];
  PNLineChartData *data01 = [PNLineChartData new];
  data01.color = PNFreshGreen;
  data01.itemCount = lineChart.xLabels.count;
  data01.getData = ^(NSUInteger index) {
      CGFloat yValue = [data01Array[index] floatValue];
      return [PNLineChartDataItem dataItemWithY:yValue];
  };
  // Line Chart No.2
  NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2];
  PNLineChartData *data02 = [PNLineChartData new];
  data02.color = PNTwitterColor;
  data02.itemCount = lineChart.xLabels.count;
  data02.getData = ^(NSUInteger index) {
      CGFloat yValue = [data02Array[index] floatValue];
      return [PNLineChartDataItem dataItemWithY:yValue];
  };

  lineChart.chartData = @[data01, data02];
  [lineChart strokeChart];

```

[![](https://dl.dropboxusercontent.com/u/1599662/bar.png)](https://dl.dropboxusercontent.com/u/1599662/bar.png)

```objective-c
  #import "PNChart.h"

  //For BarChart
  PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
  [barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
  [barChart setYValues:@[@1,  @10, @2, @6, @3]];
  [barChart strokeChart];

```

[![](https://dl.dropboxusercontent.com/u/1599662/circle.png)](https://dl.dropboxusercontent.com/u/1599662/circle.png)


```objective-c
#import "PNChart.h"

//For CircleChart

PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 80.0, SCREEN_WIDTH, 100.0) andTotal:[NSNumber numberWithInt:100] andCurrent:[NSNumber numberWithInt:60] andClockwise:NO];
circleChart.backgroundColor = [UIColor clearColor];
[circleChart setStrokeColor:PNGreen];
[circleChart strokeChart];

```


[![](https://dl.dropboxusercontent.com/u/1599662/pie.png)](https://dl.dropboxusercontent.com/u/1599662/pie.png)

```objective-c
# import "PNChart.h"
//For PieChart
NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNRed],
                           [PNPieChartDataItem dataItemWithValue:20 color:PNBlue description:@"WWDC"],
                           [PNPieChartDataItem dataItemWithValue:40 color:PNGreen description:@"GOOL I/O"],
                           ];
        
        
        
PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(40.0, 155.0, 240.0, 240.0) items:items];
pieChart.descriptionTextColor = [UIColor whiteColor];
pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
[pieChart strokeChart];
```

#### Callback

Currently callback only works on Linechart

```objective-c
  #import "PNChart.h"

//For LineChart

lineChart.delegate = self;


```

```objective-c

//For DelegateMethod


-(void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex andPointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}

-(void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}

```


## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).

## SpecialThanks

[@lexrus](http://twitter.com/lexrus)  CocoaPods Spec

