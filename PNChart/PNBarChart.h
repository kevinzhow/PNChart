//
//  PNBarChart.h
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNGenericChart.h"
#import "PNChartDelegate.h"
#import "PNBar.h"

#define kXLabelMargin 15
#define kYLabelMargin 15
#define kYLabelHeight 11
#define kXLabelHeight 20

typedef NSString *(^PNYLabelFormatter)(CGFloat yLabelValue);

@interface PNBarChart : PNGenericChart

/**
 * Draws the chart in an animated fashion.
 */
- (void)strokeChart;

@property (nonatomic) NSArray *xLabels;
@property (nonatomic) NSArray *yLabels;
@property (nonatomic) NSArray *yValues;

@property (nonatomic) NSMutableArray * bars;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) float yValueMax;
@property (nonatomic) UIColor *strokeColor;
@property (nonatomic) NSArray *strokeColors;


/** Update Values. */
- (void)updateChartData:(NSArray *)data;

/** Changes chart margin. */
@property (nonatomic) CGFloat yChartLabelWidth;

/** Formats the ylabel text. */
@property (copy) PNYLabelFormatter yLabelFormatter;

/** Prefix to y label values, none if unset. */
@property (nonatomic) NSString *yLabelPrefix;

/** Suffix to y label values, none if unset. */
@property (nonatomic) NSString *yLabelSuffix;

@property (nonatomic) CGFloat chartMarginLeft;
@property (nonatomic) CGFloat chartMarginRight;
@property (nonatomic) CGFloat chartMarginTop;
@property (nonatomic) CGFloat chartMarginBottom;

/** Controls whether labels should be displayed. */
@property (nonatomic) BOOL showLabel;

/** Controls whether the chart border line should be displayed. */
@property (nonatomic) BOOL showChartBorder;

/** Controls whether the chart Horizontal separator should be displayed. */
@property (nonatomic, assign) BOOL showLevelLine;

/** Chart bottom border, co-linear with the x-axis. */
@property (nonatomic) CAShapeLayer * chartBottomLine;

/** Chart bottom border, level separator-linear with the x-axis. */
@property (nonatomic) CAShapeLayer * chartLevelLine;

/** Chart left border, co-linear with the y-axis. */
@property (nonatomic) CAShapeLayer * chartLeftLine;

/** Corner radius for all bars in the chart. */
@property (nonatomic) CGFloat barRadius;

/** Width of all bars in the chart. */
@property (nonatomic) CGFloat barWidth;

@property (nonatomic) CGFloat labelMarginTop;

/** Background color of all bars in the chart. */
@property (nonatomic) UIColor * barBackgroundColor;

/** Text color for all bars in the chart. */
@property (nonatomic) UIColor * labelTextColor;

/** Font for all bars in the chart. */
@property (nonatomic) UIFont * labelFont;

/** How many labels on the x-axis to skip in between displaying labels. */
@property (nonatomic) NSInteger xLabelSkip;

/** How many labels on the y-axis to skip in between displaying labels. */
@property (nonatomic) NSInteger yLabelSum;

/** The maximum for the range of values to display on the y-axis. */
@property (nonatomic) CGFloat yMaxValue;

/** The minimum for the range of values to display on the y-axis. */
@property (nonatomic) CGFloat yMinValue;

/** Controls whether each bar should have a gradient fill. */
@property (nonatomic) UIColor *barColorGradientStart;

/** Controls whether text for x-axis be straight or rotate 45 degree. */
@property (nonatomic) BOOL rotateForXAxisText;

@property (nonatomic, weak) id<PNChartDelegate> delegate;

/**whether show gradient bar*/
@property (nonatomic, assign) BOOL isGradientShow;

/** whether show numbers*/
@property (nonatomic, assign) BOOL isShowNumbers;

@end
