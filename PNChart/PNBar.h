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
@property (nonatomic) CAShapeLayer *chartLine;
@property (nonatomic) UIColor *barColor;
@property (nonatomic) UIColor *barColorGradientStart;
@property (nonatomic) CGFloat barRadius;
@property (nonatomic) CAShapeLayer *gradientMask;

@end
