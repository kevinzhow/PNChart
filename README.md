#PNChart

[![Build Status](https://travis-ci.org/kevinzhow/PNChart.png?branch=master)](https://travis-ci.org/kevinzhow/PNChart)

You can also find swift version at here https://github.com/kevinzhow/PNChart-Swift

A simple and beautiful chart lib with **animation** used in [Piner](https://itunes.apple.com/us/app/piner/id637706410) and [CoinsMan](https://itunes.apple.com/us/app/coinsman/id772163893) for iOS

[![](https://dl.dropboxusercontent.com/u/1599662/pnchart.gif)](https://dl.dropboxusercontent.com/u/1599662/pnchart.gif)

## Requirements

PNChart works on iOS 7.0+ and is compatible with ARC projects.
If you need support for iOS 6, use PNChart <= 0.8.1. Note that 0.8.2 supports iOS 8.0+ only, 0.8.3 and newer supports iOS 7.0+.

It depends on the following Apple frameworks, which should already be included with most Xcode templates:

* Foundation.framework
* UIKit.framework
* CoreGraphics.framework
* QuartzCore.framework

You will need LLVM 3.0 or later in order to build PNChart.


## Usage

### Cocoapods

[CocoaPods](http://cocoapods.org) is the recommended way to add PNChart to your project.

1. Add a pod entry for PNChart to your Podfile `pod 'PNChart'`
2. Install the pod(s) by running `pod install`.
3. Include PNChart wherever you need it with `#import "PNChart.h"`.


### Copy the PNChart folder to your project


[![](https://dl.dropboxusercontent.com/u/1599662/line.png)](https://dl.dropboxusercontent.com/u/1599662/line.png)

```objective-c
#import "PNChart.h"

//For Line Chart
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

[![](https://www.dropbox.com/s/ra9ivyh2e0hkbqt/pnchart-linechart-smooth.png)](https://www.dropbox.com/s/ra9ivyh2e0hkbqt/pnchart-linechart-smooth.png)

You can choose to show smooth lines.

```objective-c
lineChart.showSmoothLines = YES;
```

[![](https://dl.dropboxusercontent.com/u/1599662/bar.png)](https://dl.dropboxusercontent.com/u/1599662/bar.png)

```objective-c
#import "PNChart.h"

//For BarC hart
PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
[barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
[barChart setYValues:@[@1,  @10, @2, @6, @3]];
[barChart strokeChart];

```

[![](https://dl.dropboxusercontent.com/u/1599662/circle.png)](https://dl.dropboxusercontent.com/u/1599662/circle.png)


```objective-c
#import "PNChart.h"

//For Circle Chart

PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 80.0, SCREEN_WIDTH, 100.0) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:60] clockwise:NO shadow:NO];
circleChart.backgroundColor = [UIColor clearColor];
[circleChart setStrokeColor:PNGreen];
[circleChart strokeChart];

```


[![](https://dl.dropboxusercontent.com/u/1599662/pie.png)](https://dl.dropboxusercontent.com/u/1599662/pie.png)

```objective-c
# import "PNChart.h"
//For Pie Chart
NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNRed],
                           [PNPieChartDataItem dataItemWithValue:20 color:PNBlue description:@"WWDC"],
                           [PNPieChartDataItem dataItemWithValue:40 color:PNGreen description:@"GOOL I/O"],
                           ];



PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(40.0, 155.0, 240.0, 240.0) items:items];
pieChart.descriptionTextColor = [UIColor whiteColor];
pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
[pieChart strokeChart];
```

[![](https://dl.dropboxusercontent.com/u/1599662/scatter.png)](https://dl.dropboxusercontent.com/u/1599662/scatter.png)

```objective-c
# import "PNChart.h"
//For Scatter Chart

PNScatterChart *scatterChart = [[PNScatterChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /6.0 - 30, 135, 280, 200)];
[scatterChart setAxisXWithMinimumValue:20 andMaxValue:100 toTicks:6];
[scatterChart setAxisYWithMinimumValue:30 andMaxValue:50 toTicks:5];

NSArray * data01Array = [self randomSetOfObjects];
PNScatterChartData *data01 = [PNScatterChartData new];
data01.strokeColor = PNGreen;
data01.fillColor = PNFreshGreen;
data01.size = 2;
data01.itemCount = [[data01Array objectAtIndex:0] count];
data01.inflexionPointStyle = PNScatterChartPointStyleCircle;
__block NSMutableArray *XAr1 = [NSMutableArray arrayWithArray:[data01Array objectAtIndex:0]];
__block NSMutableArray *YAr1 = [NSMutableArray arrayWithArray:[data01Array objectAtIndex:1]];
data01.getData = ^(NSUInteger index) {
    CGFloat xValue = [[XAr1 objectAtIndex:index] floatValue];
    CGFloat yValue = [[YAr1 objectAtIndex:index] floatValue];
    return [PNScatterChartDataItem dataItemWithX:xValue AndWithY:yValue];
};

[scatterChart setup];
self.scatterChart.chartData = @[data01];
/***
this is for drawing line to compare
CGPoint start = CGPointMake(20, 35);
CGPoint end = CGPointMake(80, 45);
[scatterChart drawLineFromPoint:start ToPoint:end WithLineWith:2 AndWithColor:PNBlack];
***/
scatterChart.delegate = self;
```

#### Legend

Legend has been added to PNChart for Line and Pie Charts. Legend items position can be stacked or in series.

[![](https://dl.dropboxusercontent.com/u/4904447/pnchart_legend_1.png)](https://dl.dropboxusercontent.com/u/4904447/pnchart_legend_1.png)

[![](https://dl.dropboxusercontent.com/u/4904447/pnchart_legend_2.png)](https://dl.dropboxusercontent.com/u/4904447/pnchart_legend_2.png)

```objective-c
#import "PNChart.h"

//For Line Chart

//Add Line Titles for the Legend
data01.dataTitle = @"Alpha";
data02.dataTitle = @"Beta Beta Beta Beta";

//Build the legend
self.lineChart.legendStyle = PNLegendItemStyleSerial;
self.lineChart.legendFontSize = 12.0;        
UIView *legend = [self.lineChart getLegendWithMaxWidth:320];

//Move legend to the desired position and add to view
[legend setFrame:CGRectMake(100, 400, legend.frame.size.width, legend.frame.size.height)];
[self.view addSubview:legend];


//For Pie Chart

//Build the legend
self.pieChart.legendStyle = PNLegendItemStyleStacked;
self.pieChart.legendFontSize = 12.0;
UIView *legend = [self.pieChart getLegendWithMaxWidth:200];

//Move legend to the desired position and add to view
[legend setFrame:CGRectMake(130, 350, legend.frame.size.width, legend.frame.size.height)];
[self.view addSubview:legend];
```

#### Grid Lines

Grid lines have been added to PNChart for Line Chart.

```objective-c
lineChart.showYGridLines = YES;
lineChart.yGridLinesColor = [UIColor grayColor];
```

[![](https://www.dropbox.com/s/sxptjpwgtk32sod/pnchart-gridline.png)](https://www.dropbox.com/s/sxptjpwgtk32sod/pnchart-gridline.png)

#### Update Value

Now it's easy to update value in real time

```objective-c
if ([self.title isEqualToString:@"Line Chart"]) {

    // Line Chart #1
    NSArray * data01Array = @[@(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300)];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = data01Array.count;
    data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };

    // Line Chart #2
    NSArray * data02Array = @[@(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300)];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.color = PNTwitterColor;
    data02.itemCount = data02Array.count;
    data02.inflexionPointStyle = PNLineChartPointStyleSquare;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [data02Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };

    [self.lineChart setXLabels:@[@"DEC 1",@"DEC 2",@"DEC 3",@"DEC 4",@"DEC 5",@"DEC 6",@"DEC 7"]];
    [self.lineChart updateChartData:@[data01, data02]];

}
else if ([self.title isEqualToString:@"Bar Chart"])
{
    [self.barChart setXLabels:@[@"Jan 1",@"Jan 2",@"Jan 3",@"Jan 4",@"Jan 5",@"Jan 6",@"Jan 7"]];
    [self.barChart updateChartData:@[@(arc4random() % 30),@(arc4random() % 30),@(arc4random() % 30),@(arc4random() % 30),@(arc4random() % 30),@(arc4random() % 30),@(arc4random() % 30)]];
}
else if ([self.title isEqualToString:@"Circle Chart"])
{
    [self.circleChart updateChartByCurrent:@(arc4random() % 100)];
}
```

#### Callback

```objective-c
#import "PNChart.h"

//For LineChart

lineChart.delegate = self;


```

#### Animation

Animation is enabled by default when drawing all charts. It can be disabled by setting `displayAnimation = NO`.

```objective-c
#import "PNChart.h"

//For LineChart

lineChart.displayAnimation = NO;

```



```objective-c

//For DelegateMethod


-(void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex{
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
[ZhangHang](http://zhanghang.github.com)  Pie Chart
[MrWooj](https://github.com/MrWooJ) Scatter Chart



