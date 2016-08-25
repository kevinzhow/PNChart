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

        viewController.title = @"Pie Chart";
    } else if ([segue.identifier isEqualToString:@"scatterChart"])
    {
        //Add scatter chart
        
        viewController.title = @"Scatter Chart";
    }else if ([segue.identifier isEqualToString:@"radarChart"])
    {
        //Add radar chart
        
        viewController.title = @"Radar Chart";
    }
}

@end
