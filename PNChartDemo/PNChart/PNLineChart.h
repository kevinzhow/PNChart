//
//  PNLineChart.h
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PNChartDelegate.h"

#define chartMargin     10
#define yLabelMargin    15
#define yLabelHeight    11

@interface PNLineChart : UIView

/**
 * This method will call and troke the line in animation
 */

- (void)strokeChart;

@property(nonatomic,retain) id<PNChartDelegate> delegate;

@property (strong, nonatomic) NSArray * xLabels;

@property (strong, nonatomic) NSArray * yLabels;

/**
* Array of `LineChartData` objects, one for each line.
*/
@property (strong, nonatomic) NSArray *chartData;

@property (strong, nonatomic) NSMutableArray * pathPoints;

@property (nonatomic) CGFloat xLabelWidth;

@property (nonatomic) float yValueMax;

@property (nonatomic) float chartCavanHeight;

@property (nonatomic) float xLabelHeight;

@property (nonatomic) BOOL showLabel;

@end
