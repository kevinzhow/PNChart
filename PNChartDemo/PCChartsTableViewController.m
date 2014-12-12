//
//  PCChartsTableViewController.m
//  PNChartDemo
//
//  Created by kevinzhow on 13-12-1.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PCChartsTableViewController.h"

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
        UILabel * pieChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 30)];
        pieChartLabel.text = @"Pie Chart";
        pieChartLabel.textColor = PNFreshGreen;
        pieChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        pieChartLabel.textAlignment = NSTextAlignmentCenter;

        NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNLightGreen],
                           [PNPieChartDataItem dataItemWithValue:20 color:PNFreshGreen description:@"WWDC"],
                           [PNPieChartDataItem dataItemWithValue:40 color:PNDeepGreen description:@"GOOG I/O"],
                           ];

        PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 100, 135, 200.0, 200.0) items:items];
        pieChart.descriptionTextColor = [UIColor whiteColor];
        pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
        pieChart.descriptionTextShadowColor = [UIColor clearColor];
        [pieChart strokeChart];


        [viewController.view addSubview:pieChartLabel];
        [viewController.view addSubview:pieChart];

        viewController.title = @"Pie Chart";
    }
}

- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}

- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}



@end
