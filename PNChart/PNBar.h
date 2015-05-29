//
//  PNBar.h
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PNBar : UIView


- (void)rollBack;

@property (nonatomic) float grade;
@property (nonatomic) float maxDivisor;

@property (nonatomic) CAShapeLayer *chartLine;
@property (nonatomic) UIColor *barColor;
@property (nonatomic) UIColor *barColorGradientStart;
@property (nonatomic) CGFloat barRadius;
@property (nonatomic) CAShapeLayer *gradientMask;

@property (nonatomic) CAShapeLayer *gradeLayer;
@property (nonatomic) CATextLayer* textLayer;

@property (nonatomic, assign) BOOL isNegative;          //!< 是否是负数
@property (nonatomic, assign) BOOL isShowNumber;        //!< 是否显示numbers
@end
