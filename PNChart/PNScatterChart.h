//
//  PNScatterChart.h
//  PNChartDemo
//
//  Created by Alireza Arabi on 12/4/14.
//  Copyright (c) 2014 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PNChartDelegate.h"
#import "PNScatterChartData.h"
#import "PNScatterChartDataItem.h"

@interface PNScatterChart : UIView

@property (nonatomic, retain) id<PNChartDelegate> delegate;

/** Array of `ScatterChartData` objects, one for each line. */
@property (nonatomic) NSArray *chartData;

/** Controls whether to show the coordinate axis. Default is NO. */
@property (nonatomic, getter = isShowCoordinateAxis) BOOL showCoordinateAxis;
@property (nonatomic) UIColor *axisColor;
@property (nonatomic) CGFloat axisWidth;

/** String formatter for float values in y-axis labels. If not set, defaults to @"%1.f" */
@property (nonatomic, strong) NSString *yLabelFormat;

/** Default is true. */
@property (nonatomic) BOOL showLabel;

/** Default is 18-point Avenir Medium. */
@property (nonatomic) UIFont  *descriptionTextFont;

/** Default is white. */
@property (nonatomic) UIColor *descriptionTextColor;

/** Default is black, with an alpha of 0.4. */
@property (nonatomic) UIColor *descriptionTextShadowColor;

/** Default is CGSizeMake(0, 1). */
@property (nonatomic) CGSize   descriptionTextShadowOffset;

/** Default is 1.0. */
@property (nonatomic) NSTimeInterval duration;

@property (nonatomic) CGFloat AxisX_minValue;
@property (nonatomic) CGFloat AxisX_maxValue;

@property (nonatomic) CGFloat AxisY_minValue;
@property (nonatomic) CGFloat AxisY_maxValue;

- (void) setAxisXWithMinimumValue:(CGFloat)minVal andMaxValue:(CGFloat)maxVal toTicks:(int)numberOfTicks;
- (void) setAxisYWithMinimumValue:(CGFloat)minVal andMaxValue:(CGFloat)maxVal toTicks:(int)numberOfTicks;
- (void) setup;
- (void) drawLineFromPoint : (CGPoint) startPoint ToPoint : (CGPoint) endPoint WithLineWith : (CGFloat) lineWidth AndWithColor : (UIColor*) color;

/**
 * Update Chart Value
 */

- (void)updateChartData:(NSArray *)data;

@end
