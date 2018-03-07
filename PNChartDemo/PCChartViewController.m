//
//  PCChartViewController.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PCChartViewController.h"

#define ARC4RANDOM_MAX 0x100000000

@implementation PCChartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.textColor = PNFreshGreen;
    self.leftSwitch.hidden = YES;
    self.rightSwitch.hidden = YES;
    self.leftLabel.hidden = YES;
    self.rightLabel.hidden = YES;
    self.centerSwitch.hidden = YES;
    self.centerSwitchLabel.hidden = YES;

    self.changeValueButton.hidden = YES;

    if ([self.title isEqualToString:@"Line Chart"]) {

        self.titleLabel.text = @"Line Chart";

        self.rightSwitch.hidden = NO;
        self.rightLabel.hidden = NO;
        self.leftSwitch.hidden = NO;
        self.leftLabel.hidden = NO;
        self.animationsSwitch.hidden = NO;

        self.leftLabel.text = @"Dark Background";
        self.rightLabel.text = @"Show Curved Lines";

        self.animationsSwitch.enabled = YES;
        self.rightSwitch.enabled = YES;
        self.leftSwitch.enabled = YES;
        [self.animationsSwitch setOn:NO];
        [self.rightSwitch setOn:NO];
        [self.leftSwitch setOn:NO];


        self.lineChart.backgroundColor = [UIColor whiteColor];
        self.lineChart.yGridLinesColor = [UIColor grayColor];
        [self.lineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
            obj.pointLabelColor = [UIColor blackColor];
        }];

        self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
        self.lineChart.showCoordinateAxis = YES;
        self.lineChart.yLabelFormat = @"%1.1f";
        self.lineChart.xLabelFont = [UIFont fontWithName:@"Helvetica-Light" size:8.0];
//        [self.lineChart setXLabels:@[@"SEP 1", @"SEP 2", @"SEP 3", @"SEP 4", @"SEP 5", @"SEP 6", @"SEP 7"]];
        [self.lineChart setXLabels:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11"]];
        self.lineChart.yLabelColor = [UIColor blackColor];
        self.lineChart.xLabelColor = [UIColor blackColor];

        // added an example to show how yGridLines can be enabled
        // the color is set to clearColor so that the demo remains the same
        self.lineChart.showGenYLabels = NO;
        self.lineChart.showYGridLines = YES;

        //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
        //Only if you needed
        self.lineChart.yFixedValueMax = 200;
        self.lineChart.yFixedValueMin = 0.0;

        [self.lineChart setYLabels:@[
                @"0",
                @"50",
                @"100",
                @"150",
                @"200",
                @"250",
                @"300",
        ]
        ];

        // Line Chart #1
        NSArray *data01Array = @[@124, @134, @128, @127, @144, @139, @134, @134, @132, @130, @116, @95];
        PNLineChartData *data01 = [PNLineChartData new];

        data01.rangeColors = @[
                               [[PNLineChartColorRange alloc] initWithRange:NSMakeRange(1, 54) color:[UIColor redColor]],
                               [[PNLineChartColorRange alloc] initWithRange:NSMakeRange(55, 6) color:[UIColor yellowColor]],
                               [[PNLineChartColorRange alloc] initWithRange:NSMakeRange(61, 49) color:[UIColor greenColor]],
                               [[PNLineChartColorRange alloc] initWithRange:NSMakeRange(110, 20) color:[UIColor yellowColor]],
                               [[PNLineChartColorRange alloc] initWithRange:NSMakeRange(130, 470) color:[UIColor redColor]]
                               ];
        data01.dataTitle = @"Alpha";
        data01.color = PNFreshGreen;
        data01.pointLabelColor = [UIColor blackColor];
        data01.alpha = 0.3f;
        data01.showPointLabel = YES;
        data01.pointLabelFont = [UIFont fontWithName:@"Helvetica-Light" size:9.0];
        data01.itemCount = data01Array.count;
        data01.inflexionPointColor = PNRed;
        data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [data01Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };

        // Line Chart #2
        NSArray *data02Array = @[@0.0, @18.1, @26.4, @30.2, @12.2, @16.2, @27.2];
        PNLineChartData *data02 = [PNLineChartData new];
        data02.dataTitle = @"Beta";
        data02.pointLabelColor = [UIColor blackColor];
        data02.color = PNTwitterColor;
        data02.alpha = 0.5f;
        data02.itemCount = data02Array.count;
        data02.inflexionPointStyle = PNLineChartPointStyleCircle;
        data02.getData = ^(NSUInteger index) {
            CGFloat yValue = [data02Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };

        self.lineChart.chartData = @[data01, data02];
        [self.lineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
            obj.pointLabelColor = [UIColor blackColor];
        }];


        [self.lineChart strokeChart];
        self.lineChart.delegate = self;


        [self.view addSubview:self.lineChart];

        self.lineChart.legendStyle = PNLegendItemStyleStacked;
        self.lineChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
        self.lineChart.legendFontColor = [UIColor redColor];

        UIView *legend = [self.lineChart getLegendWithMaxWidth:320];
        [legend setFrame:CGRectMake(30, 340, legend.frame.size.width, legend.frame.size.width)];
        [self.view addSubview:legend];
    } else if ([self.title isEqualToString:@"Bar Chart"]) {
        static NSNumberFormatter *barChartFormatter;
        if (!barChartFormatter) {
            barChartFormatter = [[NSNumberFormatter alloc] init];
            barChartFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
            barChartFormatter.allowsFloats = NO;
            barChartFormatter.maximumFractionDigits = 0;
        }
        self.titleLabel.text = @"Bar Chart";

        self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
//        self.barChart.showLabel = NO;
        self.barChart.yLabelFormatter = ^(CGFloat yValue) {
            return [barChartFormatter stringFromNumber:@(yValue)];
        };

        self.barChart.yChartLabelWidth = 20.0;
        self.barChart.chartMarginLeft = 30.0;
        self.barChart.chartMarginRight = 10.0;
        self.barChart.chartMarginTop = 5.0;
        self.barChart.chartMarginBottom = 10.0;


        self.barChart.labelMarginTop = 5.0;
        self.barChart.showChartBorder = YES;
        [self.barChart setXLabels:@[@"2", @"3", @"4", @"5", @"2", @"3", @"4", @"5"]];
//       self.barChart.yLabels = @[@-10,@0,@10];
//        [self.barChart setYValues:@[@10000.0,@30000.0,@10000.0,@100000.0,@500000.0,@1000000.0,@1150000.0,@2150000.0]];
        [self.barChart setYValues:@[@10.82, @1.88, @6.96, @33.93, @10.82, @1.88, @6.96, @33.93]];
        [self.barChart setStrokeColors:@[PNGreen, PNGreen, PNRed, PNGreen, PNGreen, PNGreen, PNRed, PNGreen]];
        self.barChart.isGradientShow = NO;
        self.barChart.isShowNumbers = NO;

        [self.barChart strokeChart];

        self.barChart.delegate = self;

        [self.view addSubview:self.barChart];
    } else if ([self.title isEqualToString:@"Circle Chart"]) {
        self.titleLabel.text = @"Circle Chart";


        self.circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 150.0, SCREEN_WIDTH, 100.0)
                                                          total:@100
                                                        current:@60
                                                      clockwise:YES];

        self.circleChart.backgroundColor = [UIColor whiteColor];

        [self.circleChart setStrokeColor:[UIColor clearColor]];
        [self.circleChart setStrokeColorGradientStart:[UIColor blueColor]];
        [self.circleChart strokeChart];

        [self.view addSubview:self.circleChart];
    } else if ([self.title isEqualToString:@"Pie Chart"]) {
        self.titleLabel.text = @"Pie Chart";
        self.leftSwitch.hidden = NO;
        self.rightSwitch.hidden = NO;
        self.leftLabel.hidden = NO;
        self.rightLabel.hidden = NO;
        self.centerSwitch.hidden = NO;
        self.centerSwitchLabel.hidden = NO;


        NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNLightGreen],
                [PNPieChartDataItem dataItemWithValue:20 color:PNFreshGreen description:@"WWDC"],
                [PNPieChartDataItem dataItemWithValue:40 color:PNDeepGreen description:@"GOOG I/O"],
        ];

        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake((CGFloat) (SCREEN_WIDTH / 2.0 - 100), 135, 200.0, 200.0) items:items];
        self.pieChart.descriptionTextColor = [UIColor whiteColor];
        self.pieChart.descriptionTextFont = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
        self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
        self.pieChart.showAbsoluteValues = NO;
        self.pieChart.showOnlyValues = NO;
        [self.pieChart strokeChart];


        self.pieChart.legendStyle = PNLegendItemStyleStacked;
        self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];

        UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
        [legend setFrame:CGRectMake(130, 350, legend.frame.size.width, legend.frame.size.height)];
        [self.view addSubview:legend];

        [self.view addSubview:self.pieChart];
        self.changeValueButton.hidden = YES;
    } else if ([self.title isEqualToString:@"Scatter Chart"]) {
        self.animationsSwitch.hidden = YES;
        self.animationsLabel.hidden = YES;

        self.titleLabel.text = @"Scatter Chart";

        self.scatterChart = [[PNScatterChart alloc] initWithFrame:CGRectMake((CGFloat) (SCREEN_WIDTH / 6.0 - 30), 135, 280, 200)];
//        self.scatterChart.yLabelFormat = @"xxx %1.1f";
        [self.scatterChart setAxisXWithMinimumValue:20 andMaxValue:100 toTicks:6];
        [self.scatterChart setAxisYWithMinimumValue:30 andMaxValue:50 toTicks:5];
        [self.scatterChart setAxisXLabel:@[@"x1", @"x2", @"x3", @"x4", @"x5", @"x6"]];
        [self.scatterChart setAxisYLabel:@[@"y1", @"y2", @"y3", @"y4", @"y5"]];

        NSArray *data01Array = [self randomSetOfObjects];
        PNScatterChartData *data01 = [PNScatterChartData new];
        data01.strokeColor = PNGreen;
        data01.fillColor = PNFreshGreen;
        data01.size = 2;
        data01.itemCount = [data01Array[0] count];
        data01.inflexionPointStyle = PNScatterChartPointStyleCircle;
        __block NSMutableArray *XAr1 = [NSMutableArray arrayWithArray:data01Array[0]];
        __block NSMutableArray *YAr1 = [NSMutableArray arrayWithArray:data01Array[1]];

        data01.getData = ^(NSUInteger index) {
            CGFloat xValue;
            xValue = [XAr1[index] floatValue];
            CGFloat yValue = [YAr1[index] floatValue];
            return [PNScatterChartDataItem dataItemWithX:xValue AndWithY:yValue];
        };

        [self.scatterChart setup];
        self.scatterChart.chartData = @[data01];
/***    
        this is for drawing line to compare
        CGPoint start = CGPointMake(20, 35);
        CGPoint end = CGPointMake(80, 45);
        [self.scatterChart drawLineFromPoint:start ToPoint:end WithLineWith:2 AndWithColor:PNBlack];
***/
        self.scatterChart.delegate = self;
        self.changeValueButton.hidden = YES;
        [self.view addSubview:self.scatterChart];
    } else if ([self.title isEqualToString:@"Radar Chart"]) {
        self.titleLabel.text = @"Radar Chart";
        
        self.leftSwitch.hidden = NO;
        self.rightSwitch.hidden = NO;
        self.leftLabel.hidden = NO;
        self.rightLabel.hidden = NO;
        self.leftLabel.text = @"Labels Style";
        self.rightLabel.text = @"Graduation";
        
        
        NSArray *items = @[[PNRadarChartDataItem dataItemWithValue:3 description:@"Art"],
                           [PNRadarChartDataItem dataItemWithValue:2 description:@"Math"],
                           [PNRadarChartDataItem dataItemWithValue:8 description:@"Sports"],
                           [PNRadarChartDataItem dataItemWithValue:5 description:@"Literature"],
                           [PNRadarChartDataItem dataItemWithValue:4 description:@"Other"],
                           ];
        self.radarChart = [[PNRadarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 300.0) items:items valueDivider:1];
        
        self.radarChart.plotColor = [UIColor redColor];
        
        [self.radarChart strokeChart];
        
        [self.view addSubview:self.radarChart];
    }

}


- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex {
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d", point.x, point.y, (int) lineIndex, (int) pointIndex);
}

- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex {
    NSLog(@"Click on line %f, %f, line index is %d", point.x, point.y, (int) lineIndex);
}


- (IBAction)changeValue:(id)sender {

    if ([self.title isEqualToString:@"Line Chart"]) {

        // Line Chart #1
        NSArray *data01Array = @[@(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300)];
        PNLineChartData *data01 = [PNLineChartData new];
        data01.color = PNFreshGreen;
        data01.itemCount = data01Array.count;
        data01.inflexionPointColor = PNRed;
        data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [data01Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };

        // Line Chart #2
        NSArray *data02Array = @[@(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300), @(arc4random() % 300)];
        PNLineChartData *data02 = [PNLineChartData new];
        data02.color = PNTwitterColor;
        data02.itemCount = data02Array.count;
        data02.inflexionPointStyle = PNLineChartPointStyleSquare;
        data02.getData = ^(NSUInteger index) {
            CGFloat yValue = [data02Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };

        [self.lineChart setXLabels:@[@"DEC 1", @"DEC 2", @"DEC 3", @"DEC 4", @"DEC 5", @"DEC 6", @"DEC 7"]];
        [self.lineChart updateChartData:@[data01, data02]];

    } else if ([self.title isEqualToString:@"Bar Chart"]) {
        [self.barChart setXLabels:@[@"Jan 1", @"Jan 2", @"Jan 3", @"Jan 4", @"Jan 5", @"Jan 6", @"Jan 7"]];
        [self.barChart updateChartData:@[@(arc4random() % 30), @(arc4random() % 30), @(arc4random() % 30), @(arc4random() % 30), @(arc4random() % 30), @(arc4random() % 30), @(arc4random() % 30)]];
    } else if ([self.title isEqualToString:@"Circle Chart"]) {
        [self.circleChart updateChartByCurrent:@(arc4random() % 100)];
    } else if ([self.title isEqualToString:@"Scatter Chart"]) {
        // will be code soon.
    }

}

- (void)userClickedOnBarAtIndex:(NSInteger)barIndex {

    NSLog(@"Click on bar %@", @(barIndex));

    PNBar *bar = self.barChart.bars[(NSUInteger) barIndex];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];

    animation.fromValue = @1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.toValue = @1.1;
    animation.duration = 0.2;
    animation.repeatCount = 0;
    animation.autoreverses = YES;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;

    [bar.layer addAnimation:animation forKey:@"Float"];
}

/* this function is used only for creating random points */
- (NSArray *)randomSetOfObjects {
    NSMutableArray *array = [NSMutableArray array];
    NSString *LabelFormat = @"%1.f";
    NSMutableArray *XAr = [NSMutableArray array];
    NSMutableArray *YAr = [NSMutableArray array];
    for (int i = 0; i < 25; i++) {
        [XAr addObject:[NSString stringWithFormat:LabelFormat, (((double) arc4random() / ARC4RANDOM_MAX) * (self.scatterChart.AxisX_maxValue - self.scatterChart.AxisX_minValue) + self.scatterChart.AxisX_minValue)]];
        [YAr addObject:[NSString stringWithFormat:LabelFormat, (((double) arc4random() / ARC4RANDOM_MAX) * (self.scatterChart.AxisY_maxValue - self.scatterChart.AxisY_minValue) + self.scatterChart.AxisY_minValue)]];
    }
    [array addObject:XAr];
    [array addObject:YAr];
    return array;
}

- (IBAction)rightSwitchChanged:(id)sender {
    if ([self.title isEqualToString:@"Pie Chart"]) {
        UISwitch *showLabels = (UISwitch *) sender;
        self.pieChart.showOnlyValues = !showLabels.on;
        [self.pieChart strokeChart];
    }
    if ([self.title isEqualToString:@"Radar Chart"]) {
        UISwitch *showLabels = (UISwitch *) sender;
        self.radarChart.isShowGraduation = !showLabels.on;
        [self.radarChart strokeChart];
    } else if ([self.title isEqualToString:@"Line Chart"]) {
        UISwitch *showLabels = (UISwitch *) sender;
        self.lineChart.showSmoothLines = showLabels.on;
//        NSLog(@"self.lineChart.showSmoothLines : %d", self.lineChart.showSmoothLines);
        [self.lineChart strokeChart];
    }
}

- (IBAction)centerSwitchChanged:(id)sender {
    if (self.pieChart) {
        [self.pieChart setEnableMultipleSelection:self.centerSwitch.on];
        [self.pieChart strokeChart];
    }

}

- (IBAction)leftSwitchChanged:(id)sender {
    if ([self.title isEqualToString:@"Pie Chart"]) {
        UISwitch *showRelative = (UISwitch *) sender;
        self.pieChart.showAbsoluteValues = !showRelative.on;
        [self.pieChart strokeChart];
    } else if ([self.title isEqualToString:@"Radar Chart"]) {
        UISwitch *showRelative = (UISwitch *) sender;
        if (showRelative.on) {
            self.radarChart.labelStyle = PNRadarChartLabelStyleHorizontal;
        } else {
            self.radarChart.labelStyle = PNRadarChartLabelStyleCircle;
        }
        [self.radarChart strokeChart];

    } else if ([self.title isEqualToString:@"Line Chart"]) {
        UISwitch *senderSwitch = (UISwitch *) sender;
        if (senderSwitch.isOn) {
            UIColor *lineChartLabelColor = [UIColor cyanColor];
            UIColor *darkBackgroundColor = [UIColor colorWithRed:0.47 green:0.47 blue:0.47 alpha:1.0];

            UIColor *gridLinesForDarkBackgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1.0];
            self.lineChart.backgroundColor = darkBackgroundColor;
            self.lineChart.yGridLinesColor = gridLinesForDarkBackgroundColor;
            self.lineChart.showYGridLines = YES;
            self.lineChart.yLabelColor = lineChartLabelColor;
            self.lineChart.xLabelColor = lineChartLabelColor;
            [self.lineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
                obj.pointLabelColor = lineChartLabelColor;
            }];
        } else {
            self.lineChart.backgroundColor = [UIColor whiteColor];
            self.lineChart.yGridLinesColor = [UIColor grayColor];
            self.lineChart.yLabelColor = [UIColor blackColor];
            self.lineChart.xLabelColor = [UIColor blackColor];
            [self.lineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
                obj.pointLabelColor = [UIColor blackColor];
            }];
        }
        [self.lineChart setXLabels:@[@"DEC 1", @"DEC 2", @"DEC 3", @"DEC 4", @"DEC 5", @"DEC 6", @"DEC 7"]];
        [self.lineChart setYLabels:@[
                @"0 min",
                @"50 min",
                @"100 min",
                @"150 min",
                @"200 min",
                @"250 min",
                @"300 min",
        ]
        ];
        [self.lineChart strokeChart];
    }
}

- (IBAction)animationsSwitchChanged:(UISwitch *)sender {
    if ([self.title isEqualToString:@"Circle Chart"]) {
        self.circleChart.displayAnimated = sender.on;
        [self.circleChart strokeChart];
    } else if ([self.title isEqualToString:@"Line Chart"]) {
        self.lineChart.displayAnimated = sender.on;
        [self.lineChart strokeChart];
    } else if ([self.title isEqualToString:@"Bar Chart"]) {
        self.barChart.displayAnimated = sender.on;
        [self.barChart strokeChart];
    } else if ([self.title isEqualToString:@"Pie Chart"]) {
        self.pieChart.displayAnimated = sender.on;
        [self.pieChart strokeChart];
    } else if ([self.title isEqualToString:@"Radar Chart"]) {
        self.radarChart.displayAnimated = sender.on;
        [self.radarChart strokeChart];
    }
}

@end
