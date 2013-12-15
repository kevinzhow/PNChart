//
//  PCChartsTableViewController.m
//  PNChartDemo
//
//  Created by kevinzhow on 13-12-1.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PCChartsTableViewController.h"
#import "PNChart.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"

@interface PCChartsTableViewController ()

@end

@implementation PCChartsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController * viewController = [segue destinationViewController];
    
    if ([segue.identifier isEqualToString:@"lineChart"]) {
        
        //Add LineChart
        UILabel * lineChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 30)];
        lineChartLabel.text = @"Line Chart";
        lineChartLabel.textColor = PNFreshGreen;
        lineChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        lineChartLabel.textAlignment = NSTextAlignmentCenter;
        
        PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
        lineChart.backgroundColor = [UIColor clearColor];
        [lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]];

        // Line Chart Nr.1
        PNLineChartData *data01 = [PNLineChartData new];
        data01.color = PNFreshGreen;
        data01.itemCount = lineChart.xLabels.count;
        data01.getData = ^(NSUInteger item) {
            CGFloat y = item * 10;
            return [PNLineChartDataItem dataItemWithY:y];
        };

        // Line Chart Nr.2
        PNLineChartData *data02 = [PNLineChartData new];
        data02.color = PNTwitterColor;
        data02.itemCount = lineChart.xLabels.count;
        data02.getData = ^(NSUInteger item) {
            CGFloat y = item == 0 ? (item * 5) + 10 : (item * 5);
            return [PNLineChartDataItem dataItemWithY:y];
        };

        lineChart.chartData = @[data01, data02];
        [lineChart strokeChart];
        
        lineChart.delegate = self;
        
        [viewController.view addSubview:lineChartLabel];
        [viewController.view addSubview:lineChart];
        
        viewController.title = @"Line Chart";
        
    }else if ([segue.identifier isEqualToString:@"barChart"])
    {
        //Add BarChart
        
        UILabel * barChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 30)];
        barChartLabel.text = @"Bar Chart";
        barChartLabel.textColor = PNFreshGreen;
        barChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        barChartLabel.textAlignment = NSTextAlignmentCenter;
        
        PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
        barChart.backgroundColor = [UIColor clearColor];
        [barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]];
        [barChart setYValues:@[@1,@24,@12,@18,@30,@10,@21]];
        [barChart strokeChart];
        
        [viewController.view addSubview:barChartLabel];
        [viewController.view addSubview:barChart];
        
        viewController.title = @"Bar Chart";
    }else if ([segue.identifier isEqualToString:@"circleChart"])
    {
        
        //Add CircleChart
        
        
        UILabel * circleChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 30)];
        circleChartLabel.text = @"Circle Chart";
        circleChartLabel.textColor = PNFreshGreen;
        circleChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        circleChartLabel.textAlignment = NSTextAlignmentCenter;
        
        PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 80.0, SCREEN_WIDTH, 100.0) andTotal:[NSNumber numberWithInt:100] andCurrent:[NSNumber numberWithInt:60]];
        circleChart.backgroundColor = [UIColor clearColor];
        [circleChart setStrokeColor:PNGreen];
        [circleChart strokeChart];
        
        [viewController.view addSubview:circleChartLabel];
        [viewController.view addSubview:circleChart];
        viewController.title = @"Circle Chart";
        
    }
    
}

-(void)userClickedOnLineKeyPoint:(CGPoint)point andPointIndex:(NSInteger)index{
    NSLog(@"Click Key on line %f, %f and index is %ld",point.x, point.y,(long)index);
}

-(void)userClickedOnLinePoint:(CGPoint)point {
    NSLog(@"Click on line %f, %f",point.x, point.y);
}

@end
