//
//  PNBarChart.h
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"

#define chartMargin  10
#define xLabelMargin 15
#define yLabelMargin 15
#define yLabelHeight 11
#define xLabelHeight 20

@interface PNBarChart : UIView

/**
 * This method will call and stroke the line in animation
 */

- (void)strokeChart;

@property (nonatomic) NSArray *xLabels;
@property (nonatomic) NSArray *yLabels;
@property (nonatomic) NSArray *yValues;
@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) int yValueMax;
@property (nonatomic) UIColor *strokeColor;
@property (nonatomic) NSArray *strokeColors;
@property (nonatomic) UIColor *barBackgroundColor;
@property (nonatomic) BOOL showLabel;

@property (nonatomic, retain) id<PNChartDelegate> delegate;
@end
