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

@property (strong, nonatomic) NSArray * yValues;

@property (strong, nonatomic) NSMutableArray * pathPoints;

@property (nonatomic) CGFloat xLabelWidth;

@property (nonatomic) float yValueMax;

@property (nonatomic) float chartCavanHeight;

@property (nonatomic) float xLabelHeight;

@property (nonatomic,strong) CAShapeLayer * chartLine;

@property (nonatomic, strong) UIColor * strokeColor;

@property (nonatomic) BOOL showLabel;

@property (nonatomic, strong)  UIBezierPath *progressline;

@end
