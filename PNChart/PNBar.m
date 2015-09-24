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

@interface PNBar ()

@property (nonatomic) float copyGrade;

@end

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
    _copyGrade = grade;
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
            gradientLayer.startPoint = CGPointMake(0.0,0.0);
            gradientLayer.endPoint = CGPointMake(1.0 ,0.0);
            gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            UIColor *middleColor = [UIColor colorWithWhite:255/255 alpha:0.8];
            NSArray *colors = @[
                                (__bridge id)self.barColor.CGColor,
                                (__bridge id)middleColor.CGColor,
                                (__bridge id)self.barColor.CGColor
                                ];
            gradientLayer.colors = colors;
            
            [gradientLayer setMask:self.gradientMask];
            
            [_chartLine addSublayer:gradientLayer];
            
            self.gradientMask.strokeEnd = 1.0;
            [self.gradientMask addAnimation:pathAnimation forKey:@"strokeEndAnimation"];

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
        [_textLayer setForegroundColor:[_labelTextColor CGColor]];
       _textLayer.hidden = YES;

    }

    return _textLayer;
}

- (void) setLabelTextColor:(UIColor *)labelTextColor {
    _labelTextColor = labelTextColor;
    [_textLayer setForegroundColor:[_labelTextColor CGColor]];
}

-(void)setGradeFrame:(CGFloat)grade startPosY:(CGFloat)startPosY
{
    CGFloat textheigt = self.bounds.size.height*self.grade;
  
    CGFloat topSpace = self.bounds.size.height * (1-self.grade);
    CGFloat textWidth = self.bounds.size.width;
  
    [_chartLine addSublayer:self.textLayer];
    [self.textLayer setFontSize:18.0];
  
    [self.textLayer setString:[[NSString alloc]initWithFormat:@"%0.f",grade*self.maxDivisor]];
  
    CGSize size = CGSizeMake(320,2000); //设置一个行高上限
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0]};
    size = [self.textLayer.string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float verticalY ;
  
    if (size.height>=textheigt) {
      
      verticalY = topSpace - size.height;
    } else {
      verticalY = topSpace +  (textheigt-size.height)/2.0;
    }
  
    [self.textLayer setFrame:CGRectMake((textWidth-size.width)/2.0,verticalY, size.width,size.height)];
    self.textLayer.contentsScale = [UIScreen mainScreen].scale;

}

- (void)setIsShowNumber:(BOOL)isShowNumber{
  if (isShowNumber) {
    self.textLayer.hidden = NO;
    [self setGradeFrame:_copyGrade startPosY:0];
  }else{
    self.textLayer.hidden = YES;
  }
}
- (void)setIsNegative:(BOOL)isNegative{
  if (isNegative) {
    [self.textLayer setString:[[NSString alloc]initWithFormat:@"- %1.f",_grade*self.maxDivisor]];
    
    CGSize size = CGSizeMake(320,2000); //设置一个行高上限
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0]};
    size = [self.textLayer.string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    CGRect frame = self.textLayer.frame;
    frame.origin.x = (self.bounds.size.width - size.width)/2.0;
    frame.size = size;
    self.textLayer.frame = frame;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = 0.1;
    rotationAnimation.repeatCount = 0;//你可以设置到最大的整数值
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.textLayer addAnimation:rotationAnimation forKey:@"Rotation"];
    
  }
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
