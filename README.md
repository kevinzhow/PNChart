#PNChart

A simple and beautiful chart lib with animation used in Piner for iOS

[![](http://dl.dropboxusercontent.com/u/1599662/pnchart.png)](http://dl.dropboxusercontent.com/u/1599662/pnchart.png)

## Usage

Copy the PNChart folder to your project

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
