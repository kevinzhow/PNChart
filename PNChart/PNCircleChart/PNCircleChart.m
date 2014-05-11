//
//  PNCircleChart.m
//  PNChartDemo
//
//  Created by kevinzhow on 13-11-30.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNCircleChart.h"

@interface PNCircleChart ()
@end

@implementation PNCircleChart


- (id)initWithFrame:(CGRect)frame andTotal:(NSNumber *)total andCurrent:(NSNumber *)current andClockwise:(BOOL)clockwise andShadow:(BOOL)hasBackgroundShadow
{
    self = [super initWithFrame:frame];

    if (self) {
        _total = total;
        _current = current;
        _strokeColor = PNFreshGreen;
        _duration = 1.0;
        _chartType = PNChartFormatTypePercent;

        CGFloat startAngle = clockwise ? -90.0f : 270.0f;
        CGFloat endAngle = clockwise ? -90.01f : 270.01f;

        _lineWidth = @8.0f;
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x, self.center.y) radius:self.frame.size.height * 0.5 startAngle:DEGREES_TO_RADIANS(startAngle) endAngle:DEGREES_TO_RADIANS(endAngle) clockwise:clockwise];

        _circle               = [CAShapeLayer layer];
        _circle.path          = circlePath.CGPath;
        _circle.lineCap       = kCALineCapRound;
        _circle.fillColor     = [UIColor clearColor].CGColor;
        _circle.lineWidth     = [_lineWidth floatValue];
        _circle.zPosition     = 1;

        _circleBG             = [CAShapeLayer layer];
        _circleBG.path        = circlePath.CGPath;
        _circleBG.lineCap     = kCALineCapRound;
        _circleBG.fillColor   = [UIColor clearColor].CGColor;
        _circleBG.lineWidth   = [_lineWidth floatValue];
        _circleBG.strokeColor = (hasBackgroundShadow ? PNLightYellow.CGColor : [UIColor clearColor].CGColor);
        _circleBG.strokeEnd   = 1.0;
        _circleBG.zPosition   = -1;

        [self.layer addSublayer:_circle];
        [self.layer addSublayer:_circleBG];

        _countingLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, 0, 100.0, 50.0)];
        [_countingLabel setTextAlignment:NSTextAlignmentCenter];
        [_countingLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [_countingLabel setTextColor:[UIColor grayColor]];
        [_countingLabel setCenter:CGPointMake(self.center.x, self.center.y)];
        _countingLabel.method = UILabelCountingMethodEaseInOut;
        [self addSubview:_countingLabel];;
    }

    return self;
}


- (void)strokeChart
{
    // Add counting label
    
    NSString *format;
    switch (self.chartType) {
      case PNChartFormatTypePercent:
        format = @"%d%%";
        break;
      case PNChartFormatTypeDollar:
        format = @"$%d";
        break;
      case PNChartFormatTypeNone:
      default:
        format = @"%d";
        break;
    }
    self.countingLabel.format = format;
    [self addSubview:self.countingLabel];


    // Add circle params

    _circle.lineWidth   = [_lineWidth floatValue];
    _circleBG.lineWidth = [_lineWidth floatValue];
    _circleBG.strokeEnd = 1.0;
    _circle.strokeColor = _strokeColor.CGColor;

    // Add Animation
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = self.duration;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @0.0f;
    pathAnimation.toValue = @([_current floatValue] / [_total floatValue]);
    [_circle addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    _circle.strokeEnd   = [_current floatValue] / [_total floatValue];

    [_countingLabel countFrom:0 to:[_current floatValue] withDuration:1.0];
}



- (void)growChartByAmount:(NSNumber *)growAmount
{
    NSNumber *updatedValue = [NSNumber numberWithFloat:[_current floatValue] + [growAmount floatValue]];
    
    // Add animation
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = self.duration;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @([_current floatValue] / [_total floatValue]);
    pathAnimation.toValue = @([updatedValue floatValue] / [_total floatValue]);
    _circle.strokeEnd   = [updatedValue floatValue] / [_total floatValue];
    [_circle addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    [self.countingLabel countFrom:fmin([_current floatValue], [_total floatValue]) to:fmin([_current floatValue] + [growAmount floatValue], [_total floatValue]) withDuration:self.duration];
    _current = updatedValue;
}

@end
