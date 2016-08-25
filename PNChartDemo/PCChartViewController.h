//
//  PCChartViewController.h
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"

@interface PCChartViewController : UIViewController<PNChartDelegate>

@property (nonatomic) PNLineChart * lineChart;
@property (nonatomic) PNBarChart * barChart;
@property (nonatomic) PNCircleChart * circleChart;
@property (nonatomic) PNPieChart *pieChart;
@property (nonatomic) PNScatterChart *scatterChart;
@property (nonatomic) PNRadarChart *radarChart;
@property (weak, nonatomic) IBOutlet UILabel *centerSwitchLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)changeValue:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *changeValueButton;

@property (weak, nonatomic) IBOutlet UISwitch *animationsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *leftSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *centerSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *rightSwitch;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

- (IBAction)rightSwitchChanged:(id)sender;
- (IBAction)leftSwitchChanged:(id)sender;

@end
