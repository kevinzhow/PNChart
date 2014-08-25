//
//  PNCircleChart.h
//  PNChartDemo
//
//  Created by kevinzhow on 13-11-30.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNColor.h"
#import <UICountingLabel/UICountingLabel.h>

typedef NS_ENUM (NSUInteger, PNChartFormatType) {
    PNChartFormatTypePercent,
    PNChartFormatTypeDollar,
    PNChartFormatTypeNone
};

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface PNCircleChart : UIView

- (void)strokeChart;
- (void)growChartByAmount:(NSNumber *)growAmount;
- (id)initWithFrame:(CGRect)frame andTotal:(NSNumber *)total andCurrent:(NSNumber *)current andClockwise:(BOOL)clockwise andShadow:(BOOL)hasBackgroundShadow;

@property (strong, nonatomic) UICountingLabel *countingLabel;
@property (nonatomic) UIColor *strokeColor;
@property (nonatomic) UIColor *strokeColorGradientStart;
@property (nonatomic) NSNumber *total;
@property (nonatomic) NSNumber *current;
@property (nonatomic) NSNumber *lineWidth;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) PNChartFormatType chartType;

@property (nonatomic) CAShapeLayer *circle;
@property (nonatomic) CAShapeLayer *circleBG;

@end
