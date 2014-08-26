//
//  PNBarChart.h
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNBar.h"

#define xLabelMargin 15
#define yLabelMargin 15
#define yLabelHeight 11
#define xLabelHeight 20

typedef NSString *(^PNyLabelFromatter)(CGFloat yLabelValue);

@interface PNBarChart : UIView

/**
 * This method will call and stroke the line in animation
 */

- (void)strokeChart;

@property (nonatomic) NSArray *xLabels;
@property (nonatomic) NSArray *yLabels;
@property (nonatomic) NSArray *yValues;

@property (nonatomic) NSMutableArray * bars;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) int yValueMax;
@property (nonatomic) UIColor *strokeColor;
@property (nonatomic) NSArray *strokeColors;


/*
 chartMargin changes chart margin
 */
@property (nonatomic) CGFloat yChartLabelWidth;

/*
 yLabelFormatter will format the ylabel text
 */

@property (copy) PNyLabelFromatter yLabelFormatter;

/*
 chartMargin changes chart margin
 */
@property (nonatomic) CGFloat chartMargin;

/*
 showLabelDefines if the Labels should be deplay
 */
@property (nonatomic) BOOL showLabel;

/*
 showChartBorder if the chart border Line should be deplay
 */
@property (nonatomic) BOOL showChartBorder;

/*
 chartBottomLine the Line at the chart bottom
 */
@property (nonatomic) CAShapeLayer * chartBottomLine;

/*
 chartLeftLine the Line at the chart left
 */
@property (nonatomic) CAShapeLayer * chartLeftLine;

/*
 barRadius changes the bar corner radius
 */
@property (nonatomic) CGFloat barRadius;

/*
 barWidth changes the width of the bar
 */
@property (nonatomic) CGFloat barWidth;

/*
 labelMarginTop changes the width of the bar
 */
@property (nonatomic) CGFloat labelMarginTop;

/*
 barBackgroundColor changes the bar background color
 */
@property (nonatomic) UIColor * barBackgroundColor;

/*
 labelTextColor changes the bar label text color
 */
@property (nonatomic) UIColor * labelTextColor;

/*
 labelFont changes the bar label font
 */
@property (nonatomic) UIFont * labelFont;

/*
 xLabelSkip define the label skip number
 */
@property (nonatomic) NSInteger xLabelSkip;

/*
 yLabelSum define the label sum number
 */
@property (nonatomic) NSInteger yLabelSum;

/*
 yMaxValue define the max value of the chart
 */
@property (nonatomic) CGFloat yMaxValue;

/*
 yMinValue define the min value of the chart
 */
@property (nonatomic) CGFloat yMinValue;

/*
 switch to indicate that the bar should be filled as a gradient
 */
@property (nonatomic) UIColor *barColorGradientStart;


@property (nonatomic, retain) id<PNChartDelegate> delegate;

@end
