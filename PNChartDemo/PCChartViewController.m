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
	[lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]];
	[lineChart setYValues:@[@1,@24,@12,@18,@30,@10,@21]];
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
	[barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]];
	[barChart setYValues:@[@1,@24,@12,@18,@30,@10,@21]];
	[barChart strokeChart];
	[self.chartScrollView addSubview:barChartLabel];
	[self.chartScrollView addSubview:barChart];
    
    //Add CircleChart
    
    
	UILabel * circleChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 550, SCREEN_WIDTH, 30)];
	circleChartLabel.text = @"Circle Chart";
	circleChartLabel.textColor = PNFreshGreen;
	circleChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
	circleChartLabel.textAlignment = NSTextAlignmentCenter;
	
	PNChart * circleChart = [[PNChart alloc] initWithFrame:CGRectMake(0, 585.0, SCREEN_WIDTH, 200.0)];
	circleChart.backgroundColor = [UIColor clearColor];
	circleChart.type = PNCircleType;
    circleChart.total = [NSNumber numberWithInt:100];
    circleChart.current = [NSNumber numberWithInt:60];
	[circleChart strokeChart];
	[self.chartScrollView addSubview:circleChartLabel];
	[self.chartScrollView addSubview:circleChart];
    
    [self.chartScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 900.0)];
	
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
