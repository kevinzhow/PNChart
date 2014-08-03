//
//  PNBar.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNBar.h"
#import "PNColor.h"

@implementation PNBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        // Initialization code
        _chartLine              = [CAShapeLayer layer];
        _chartLine.lineCap      = kCALineCapButt;
        _chartLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth    = self.frame.size.width;
        _chartLine.strokeEnd    = 0.0;
        self.clipsToBounds      = YES;
        [self.layer addSublayer:_chartLine];
        self.barRadius = 2.0;
    }

    return self;
}

-(void)setBarRadius:(CGFloat)barRadius
{
    _barRadius = barRadius;
    self.layer.cornerRadius = _barRadius;
}


- (void)setGrade:(float)grade
{
    _grade = grade;
    UIBezierPath *progressline = [UIBezierPath bezierPath];

    [progressline moveToPoint:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height)];
    [progressline addLineToPoint:CGPointMake(self.frame.size.width / 2.0, (1 - grade) * self.frame.size.height)];

    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
    _chartLine.path = progressline.CGPath;

    if (_barColor) {
        _chartLine.strokeColor = [_barColor CGColor];
    }
    else {
        _chartLine.strokeColor = [PNGreen CGColor];
    }

    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @0.0f;
    pathAnimation.toValue = @1.0f;
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];

    _chartLine.strokeEnd = 1.0;
    
    // Check if user wants to add a gradient from the start color to the bar color
    if (_barColorGradientStart) {
        
        // Add gradient
        CAShapeLayer *gradientMask = [CAShapeLayer layer];
        gradientMask.fillColor = [[UIColor clearColor] CGColor];
        gradientMask.strokeColor = [[UIColor blackColor] CGColor];
        //gradientMask.lineWidth = 4;
        gradientMask.lineWidth    = self.frame.size.width;
        gradientMask.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        gradientMask.path = progressline.CGPath;
        
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0.5,1.0);
        gradientLayer.endPoint = CGPointMake(0.5,0.0);
        gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        UIColor *endColor = (_barColor ? _barColor : [UIColor greenColor]);
        NSArray *colors = @[
                            (id)_barColorGradientStart.CGColor,
                            (id)endColor.CGColor
                            ];
        gradientLayer.colors = colors;
        
        [gradientLayer setMask:gradientMask];
        
        [_chartLine addSublayer:gradientLayer];
        
        gradientMask.strokeEnd = 1.0;
        [gradientMask addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    }

}


- (void)rollBack
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations: ^{
        _chartLine.strokeColor = [UIColor clearColor].CGColor;
    } completion:nil];
}

- (void)setBarColorGradientStart:(UIColor *)barColorGradientStart
{
    // Set gradient color, remove any existing sublayer first
    for (CALayer *sublayer in [_chartLine sublayers]) {
        [sublayer removeFromSuperlayer];
    }
    _barColorGradientStart = barColorGradientStart;
    
    [self setGrade:_grade];
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //Draw BG
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
}


@end
