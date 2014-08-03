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
        lineChart.yLabelFormat = @"%1.1f";
        lineChart.backgroundColor = [UIColor clearColor];
        [lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]];
        lineChart.showCoordinateAxis = YES;

        // Line Chart Nr.1
        NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2, @127.2, @176.2];
        PNLineChartData *data01 = [PNLineChartData new];
        data01.color = PNFreshGreen;
        data01.itemCount = lineChart.xLabels.count;
        data01.inflexionPointStyle = PNLineChartPointStyleCycle;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [data01Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };

        // Line Chart Nr.2
        NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
        PNLineChartData *data02 = [PNLineChartData new];
        data02.color = PNTwitterColor;
        data02.itemCount = lineChart.xLabels.count;
        data02.inflexionPointStyle = PNLineChartPointStyleSquare;
        data02.getData = ^(NSUInteger index) {
            CGFloat yValue = [data02Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
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
        
        self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
        self.barChart.backgroundColor = [UIColor clearColor];
        self.barChart.yLabelFormatter = ^(CGFloat yValue){
            CGFloat yValueParsed = yValue;
            NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
            return labelText;
        };
        self.barChart.labelMarginTop = 5.0;
        [self.barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]];
        [self.barChart setYValues:@[@1,@24,@12,@18,@30,@10,@21]];
        [self.barChart setStrokeColors:@[PNGreen,PNGreen,PNRed,PNGreen,PNGreen,PNYellow,PNGreen]];
        // Adding gradient
        self.barChart.barColorGradientStart = [UIColor blueColor];

        [self.barChart strokeChart];
        
        

        self.barChart.delegate = self;
        
        [viewController.view addSubview:barChartLabel];
        [viewController.view addSubview:self.barChart];
        
        viewController.title = @"Bar Chart";
    }else if ([segue.identifier isEqualToString:@"circleChart"])
    {
        
        //Add CircleChart
        
        
        UILabel * circleChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 30)];
        circleChartLabel.text = @"Circle Chart";
        circleChartLabel.textColor = PNFreshGreen;
        circleChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        circleChartLabel.textAlignment = NSTextAlignmentCenter;
        
        PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 80.0, SCREEN_WIDTH, 100.0) andTotal:@100 andCurrent:@60 andClockwise:YES andShadow:YES];
        circleChart.backgroundColor = [UIColor clearColor];
        [circleChart setStrokeColor:PNGreen];
        [circleChart setStrokeColorGradientStart:[UIColor blueColor]];
        [circleChart strokeChart];
        
        [viewController.view addSubview:circleChartLabel];

        [viewController.view addSubview:circleChart];
        viewController.title = @"Circle Chart";
        
    }else if ([segue.identifier isEqualToString:@"pieChart"])
    {
        
        //Add PieChart
        UILabel * pieChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 30)];
        pieChartLabel.text = @"Pie Chart";
        pieChartLabel.textColor = PNFreshGreen;
        pieChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        pieChartLabel.textAlignment = NSTextAlignmentCenter;
        
        
        
        NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNLightGreen],
                           [PNPieChartDataItem dataItemWithValue:20 color:PNFreshGreen description:@"WWDC"],
                           [PNPieChartDataItem dataItemWithValue:40 color:PNDeepGreen description:@"GOOL I/O"],
                           ];
        
        
        
        PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(40.0, 155.0, 240.0, 240.0) items:items];
        pieChart.descriptionTextColor = [UIColor whiteColor];
        pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
        pieChart.descriptionTextShadowColor = [UIColor clearColor];
        [pieChart strokeChart];
        
        
        [viewController.view addSubview:pieChartLabel];
        [viewController.view addSubview:pieChart];
        
        viewController.title = @"Pie Chart";
        
    }
    
}

-(void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex andPointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}

-(void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}

- (void)userClickedOnBarCharIndex:(NSInteger)barIndex
{
    
    NSLog(@"Click on bar %@", @(barIndex));
    
    PNBar * bar = [self.barChart.bars objectAtIndex:barIndex];
    
    CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.fromValue= @1.0;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    animation.toValue= @1.1;
    
    animation.duration= 0.2;
    
    animation.repeatCount = 0;
    
    animation.autoreverses = YES;
    
    animation.removedOnCompletion = YES;
    
    animation.fillMode=kCAFillModeForwards;
    
    [bar.layer addAnimation:animation forKey:@"Float"];
}

@end
