//
//  PCChartViewController.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PCChartViewController.h"
#import "PNChart.h"

@interface PCChartViewController ()

@end

@implementation PCChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//Add LineChart
	UILabel * lineChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 30)];
	lineChartLabel.text = @"Line Chart";
	lineChartLabel.textColor = PNFreshGreen;
	lineChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
	lineChartLabel.textAlignment = NSTextAlignmentCenter;
	
	PNChart * lineChart = [[PNChart alloc] initWithFrame:CGRectMake(0, 75.0, SCREEN_WIDTH, 200.0)];
	lineChart.backgroundColor = [UIColor clearColor];
	[lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
	[lineChart setYValues:@[@"1",@"10",@"2",@"6",@"3"]];
	[lineChart strokeChart];
	[self.chartScrollView addSubview:lineChartLabel];
	[self.chartScrollView addSubview:lineChart];
	
	//Add BarChart
	
	UILabel * barChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 30)];
	barChartLabel.text = @"Bar Chart";
	barChartLabel.textColor = PNFreshGreen;
	barChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
	barChartLabel.textAlignment = NSTextAlignmentCenter;
	
	PNChart * barChart = [[PNChart alloc] initWithFrame:CGRectMake(0, 335.0, SCREEN_WIDTH, 200.0)];
	barChart.backgroundColor = [UIColor clearColor];
	barChart.type = PNBarType;
	[barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
	[barChart setYValues:@[@"1",@"10",@"2",@"6",@"3"]];
	[barChart strokeChart];
	[self.chartScrollView addSubview:barChartLabel];
	[self.chartScrollView addSubview:barChart];
	
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
