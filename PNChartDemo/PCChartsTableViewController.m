//
//  PCChartsTableViewController.m
//  PNChartDemo
//
//  Created by kevinzhow on 13-12-1.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PCChartsTableViewController.h"
#define ARC4RANDOM_MAX 0x100000000

@implementation PCChartsTableViewController

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    UIViewController * viewController = [segue destinationViewController];

    if ([segue.identifier isEqualToString:@"lineChart"]) {

        //Add line chart

        viewController.title = @"Line Chart";

    } else if ([segue.identifier isEqualToString:@"barChart"])
    {
        //Add bar chart

        viewController.title = @"Bar Chart";
    } else if ([segue.identifier isEqualToString:@"circleChart"])
    {
        //Add circle chart

        viewController.title = @"Circle Chart";

    } else if ([segue.identifier isEqualToString:@"pieChart"])
    {
        //Add pie chart

        viewController.title = @"Pie Chart";
    } else if ([segue.identifier isEqualToString:@"scatterChart"])
    {
        //Add scatter chart
        UILabel * scatterChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 30)];
        scatterChartLabel.text = @"Scatter Chart";
        scatterChartLabel.textColor = PNFreshGreen;
        scatterChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        scatterChartLabel.textAlignment = NSTextAlignmentCenter;
        
        PNScatterChart *scatterChart = [[PNScatterChart alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
        [scatterChart setAxisXWithMinimumValue:20 andMaxValue:100 toTicks:6];
        [scatterChart setAxisYWithMinimumValue:30 andMaxValue:50 toTicks:5];
        
        NSArray * data01Array = [self randomSetOfObjectsForScatterChart:scatterChart];
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
        
        NSArray * data02Array = [self randomSetOfObjectsForScatterChart:scatterChart];
        PNScatterChartData *data02 = [PNScatterChartData new];
        data02.strokeColor = PNBlue;
        data02.fillColor = PNBlue;
        data02.size = 2;
        data02.itemCount = [[data02Array objectAtIndex:0] count];
        data02.inflexionPointStyle = PNScatterChartPointStyleCircle;
        __block NSMutableArray *XAr2 = [NSMutableArray arrayWithArray:[data02Array objectAtIndex:0]];
        __block NSMutableArray *YAr2 = [NSMutableArray arrayWithArray:[data02Array objectAtIndex:1]];
        data02.getData = ^(NSUInteger index) {
            CGFloat xValue = [[XAr2 objectAtIndex:index] floatValue];
            CGFloat yValue = [[YAr2 objectAtIndex:index] floatValue];
            return [PNScatterChartDataItem dataItemWithX:xValue AndWithY:yValue];
        };
        
        [scatterChart setup];
        scatterChart.chartData = @[data01 , data02];
        
        // this is for drawing line to compare
        CGPoint start = CGPointMake(20, 35);
        CGPoint end = CGPointMake(80, 45);
        [scatterChart drawLineFromPoint:start ToPoint:end WithLineWith:2 AndWithColor:PNBlack];
        
        scatterChart.delegate = self;
        [viewController.view addSubview:scatterChartLabel];
        [viewController.view addSubview:scatterChart];
        viewController.title = @"Scatter Chart";
    }
}

/* this function is used only for creating random points */
- (NSArray *) randomSetOfObjectsForScatterChart:(PNScatterChart *)chart{
    NSMutableArray *array = [NSMutableArray array];
    NSString *LabelFormat = @"%1.f";
    NSMutableArray *XAr = [NSMutableArray array];
    NSMutableArray *YAr = [NSMutableArray array];
    for (int i = 0; i < 25 ; i++) {
        [XAr addObject:[NSString stringWithFormat:LabelFormat,(((double)arc4random() / ARC4RANDOM_MAX) * (chart.AxisX_maxValue - chart.AxisX_minValue) + chart.AxisX_minValue)]];
        [YAr addObject:[NSString stringWithFormat:LabelFormat,(((double)arc4random() / ARC4RANDOM_MAX) * (chart.AxisY_maxValue - chart.AxisY_minValue) + chart.AxisY_minValue)]];
    }
    [array addObject:XAr];
    [array addObject:YAr];
    return (NSArray*) array;
}



@end
