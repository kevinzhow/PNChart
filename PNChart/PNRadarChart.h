//
//  PNRadarChart.h
//  PNChartDemo
//
//  Created by Lei on 15/7/1.
//  Copyright (c) 2015年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNGenericChart.h"
#import "PNRadarChartDataItem.h"

#define MAXCIRCLE 20

typedef NS_ENUM(NSUInteger, PNRadarChartLabelStyle) {
    PNRadarChartLabelStyleCircle = 0,
    PNRadarChartLabelStyleHorizontal,
    PNRadarChartLabelStyleHidden,
};

@interface PNRadarChart : PNGenericChart

-(id)initWithFrame:(CGRect)frame  items:(NSArray *)items valueDivider:(CGFloat)unitValue;
/** 
 *Draws the chart in an animated fashion.
 */
-(void)strokeChart;

/** Array of `RadarChartDataItem` objects, one for each corner. */
@property (nonatomic) NSArray *chartData;
/** The unit of this chart ,default is 1 */
@property (nonatomic) CGFloat valueDivider;
/** The maximum for the range of values to display on the chart */
@property (nonatomic) CGFloat maxValue;
/** Default is gray. */
@property (nonatomic) UIColor *webColor;
/** Default is green , with an alpha of 0.7 */
@property (nonatomic) UIColor *plotColor;
/** Default is black */
@property (nonatomic) UIColor *fontColor;
/** Default is orange */
@property (nonatomic) UIColor *graduationColor;
/** Default is 15 */
@property (nonatomic) CGFloat fontSize;
/** Controls the labels display style that around chart */
@property (nonatomic, assign) PNRadarChartLabelStyle labelStyle;
/** Tap the label will display detail value ,default is YES. */
@property (nonatomic, assign) BOOL isLabelTouchable;
/** is show graduation on the chart ,default is NO. */
@property (nonatomic, assign) BOOL isShowGraduation;

@end
