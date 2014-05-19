//
//  PCChartsTableViewController.h
//  PNChartDemo
//
//  Created by kevinzhow on 13-12-1.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"

@interface PCChartsTableViewController : UITableViewController<PNChartDelegate>

@property (nonatomic) PNBarChart * barChart;

@end
