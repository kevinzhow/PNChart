//
//  PNBar.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNBar.h"
#import "PNColor.h"
#import <CoreText/CoreText.h>

@implementation PNBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
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
//    NSLog(@"New garde %f",grade);
  
    CGFloat startPosY = (1 - grade) * self.frame.size.height;

    UIBezierPath *progressline = [UIBezierPath bezierPath];

    [progressline moveToPoint:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height)];
    [progressline addLineToPoint:CGPointMake(self.frame.size.width / 2.0, startPosY)];

    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];


    if (_barColor) {
        _chartLine.strokeColor = [_barColor CGColor];
    }
    else {
        _chartLine.strokeColor = [PNGreen CGColor];
    }

    if (_grade) {
        
        CABasicAnimation * pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.fromValue = (id)_chartLine.path;
        pathAnimation.toValue = (id)[progressline CGPath];
        pathAnimation.duration = 0.5f;
        pathAnimation.autoreverses = NO;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [_chartLine addAnimation:pathAnimation forKey:@"animationKey"];
        
        _chartLine.path = progressline.CGPath;
        
        if (_barColorGradientStart) {
            
            // Add gradient
            [self.gradientMask addAnimation:pathAnimation forKey:@"animationKey"];
            self.gradientMask.path = progressline.CGPath;
            
            // add text
            [self setGradeFrame:grade startPosY:startPosY];
            CABasicAnimation* opacityAnimation = [self fadeAnimation];
            [self.textLayer addAnimation:opacityAnimation forKey:nil];

        }
        
    }else{
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 1.0;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @0.0f;
        pathAnimation.toValue = @1.0f;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartLine.strokeEnd = 1.0;
        
        _chartLine.path = progressline.CGPath;
        // Check if user wants to add a gradient from the start color to the bar color
        if (_barColorGradientStart) {
            
            // Add gradient
            self.gradientMask = [CAShapeLayer layer];
            self.gradientMask.fillColor = [[UIColor clearColor] CGColor];
            self.gradientMask.strokeColor = [[UIColor blackColor] CGColor];
            self.gradientMask.lineWidth    = self.frame.size.width;
            self.gradientMask.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            self.gradientMask.path = progressline.CGPath;
            
            
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
            
            [gradientLayer setMask:self.gradientMask];
            
            [_chartLine addSublayer:gradientLayer];
            
            self.gradientMask.strokeEnd = 1.0;
            [self.gradientMask addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            
            //set grade
            [self setGradeFrame:grade startPosY:startPosY];
            CABasicAnimation* opacityAnimation = [self fadeAnimation];
            [self.textLayer addAnimation:opacityAnimation forKey:nil];
        }
    }
    
    _grade = grade;

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
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
}


// add number display on the top of bar
-(CGPathRef)gradePath:(CGRect)rect
{
    return nil;
}

-(CATextLayer*)textLayer
{
    if (!_textLayer) {
        _textLayer = [[CATextLayer alloc]init];
        [_textLayer setString:@"0"];
        [_textLayer setAlignmentMode:kCAAlignmentCenter];
        [_textLayer setForegroundColor:[[UIColor grayColor] CGColor]];
    }

    return _textLayer;
}

-(void)setGradeFrame:(CGFloat)grade startPosY:(CGFloat)startPosY
{
    CGFloat textheigt = self.bounds.size.width;
    CGFloat textWidth = self.bounds.size.width;
    CGFloat textStartPosY;
    
    
    if (startPosY < textheigt) {
        textStartPosY = startPosY;
    }
    else {
        textStartPosY = startPosY - textheigt;
    }
    
    [_chartLine addSublayer:self.textLayer];
    [self.textLayer setFontSize:textheigt/2];
  
    [self.textLayer setString:[[NSString alloc]initWithFormat:@"%0.f",grade*100]];
    [self.textLayer setFrame:CGRectMake(0, textStartPosY, textWidth,  textheigt)];
    self.textLayer.contentsScale = [UIScreen mainScreen].scale;

}

-(CABasicAnimation*)fadeAnimation
{
    CABasicAnimation* fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    fadeAnimation.toValue = [NSNumber numberWithFloat:1.0];
    fadeAnimation.duration = 2.0;
    
    return fadeAnimation;
}

@end
