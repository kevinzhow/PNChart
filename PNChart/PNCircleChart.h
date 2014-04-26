//
//  PNCircleChart.h
//  PNChartDemo
//
//  Created by kevinzhow on 13-11-30.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNColor.h"


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface PNCircleChart : UIView

- (void)strokeChart;
- (id)initWithFrame:(CGRect)frame andTotal:(NSNumber *)total andCurrent:(NSNumber *)current andClockwise:(BOOL)clockwise andShadow:(BOOL)hasBackgroundShadow;

@property (nonatomic) UIColor *strokeColor;
@property (nonatomic) UIColor *labelColor;
@property (nonatomic) NSNumber *total;
@property (nonatomic) NSNumber *current;
@property (nonatomic) NSNumber *lineWidth;
@property (nonatomic) BOOL clockwise;

@property (nonatomic) CAShapeLayer *circle;
@property (nonatomic) CAShapeLayer *circleBG;

@end
