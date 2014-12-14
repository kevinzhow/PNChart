//
//  PNScatterChart.m
//  PNChartDemo
//
//  Created by Alireza Arabi on 12/4/14.
//  Copyright (c) 2014 kevinzhow. All rights reserved.
//

#import "PNScatterChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"
#import "PNScatterChartData.h"
#import "PNScatterChartDataItem.h"

@interface PNScatterChart ()

@property (nonatomic, weak) CAShapeLayer *pathLayer;

@property (nonatomic) CGPoint startPoint;

@property (nonatomic) CGPoint startPointVectorX;
@property (nonatomic) CGPoint endPointVecotrX;

@property (nonatomic) CGPoint startPointVectorY;
@property (nonatomic) CGPoint endPointVecotrY;

@property (nonatomic) CGFloat vectorX_Steps;
@property (nonatomic) CGFloat vectorY_Steps;

@property (nonatomic) CGFloat vectorX_Size;
@property (nonatomic) CGFloat vectorY_Size;

@property (nonatomic) NSMutableArray *axisX_labels;
@property (nonatomic) NSMutableArray *axisY_labels;

@property (nonatomic) int AxisX_partNumber ;
@property (nonatomic) int AxisY_partNumber ;

@property (nonatomic) CGFloat AxisX_step ;
@property (nonatomic) CGFloat AxisY_step ;

@property (nonatomic) CGFloat AxisX_Margin;
@property (nonatomic) CGFloat AxisY_Margin;

- (void)setDefaultValues;

@end


@implementation PNScatterChart

#pragma mark initialization

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        [self setDefaultValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setDefaultValues];
    }
    return self;
}

- (void) setup
{
    [self vectorXSetup];
    [self vectorYSetup];
}

- (void)setDefaultValues
{
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds   = YES;
    _showLabel           = YES;
    self.userInteractionEnabled = YES;
    
    // Coordinate Axis Default Values
    _showCoordinateAxis = YES;
    _axisColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.f];
    _axisWidth = 1.f;
    
    // Initialization code
    _AxisX_Margin = 30 ;
    _AxisY_Margin = 30 ;
    
    self.frame = CGRectMake((SCREEN_WIDTH - self.frame.size.width) / 2, 200, self.frame.size.width, self.frame.size.height) ;
    self.backgroundColor = [UIColor clearColor];
    
    _startPoint.y = self.frame.size.height - self.AxisY_Margin ;
    _startPoint.x = self.AxisX_Margin ;
    
    _axisX_labels = [NSMutableArray array];
    _axisY_labels = [NSMutableArray array];
    
    _descriptionTextColor = [UIColor blackColor];
    _descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:9.0];
    _descriptionTextShadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _descriptionTextShadowOffset =  CGSizeMake(0, 1);
    _duration = 1.0;
    
}

#pragma mark calculating axis

- (void) setAxisXWithMinimumValue:(CGFloat)minVal andMaxValue:(CGFloat)maxVal toTicks:(int)numberOfTicks
{
    _AxisX_minValue = minVal ;
    _AxisX_maxValue = maxVal ;
    _AxisX_partNumber = numberOfTicks - 1;
    _AxisX_step = (float)((maxVal - minVal)/_AxisX_partNumber);
    
    NSString *LabelFormat = self.yLabelFormat ? : @"%1.f";
    CGFloat tempValue = minVal ;
    [_axisX_labels addObject:[NSString stringWithFormat:LabelFormat,minVal]];
    for (int i = 0 ; i < _AxisX_partNumber; i++) {
        tempValue = tempValue + _AxisX_step;
        [_axisX_labels addObject:[NSString stringWithFormat:LabelFormat,tempValue]];
    }
}

- (void) setAxisYWithMinimumValue:(CGFloat)minVal andMaxValue:(CGFloat)maxVal toTicks:(int)numberOfTicks
{
    _AxisY_minValue = minVal ;
    _AxisY_maxValue = maxVal ;
    _AxisY_partNumber = numberOfTicks - 1;
    _AxisY_step = (float)((maxVal - minVal)/_AxisY_partNumber);
    
    _axisY_labels = [NSMutableArray array];
    NSString *LabelFormat = self.yLabelFormat ? : @"%1.f";
    CGFloat tempValue = minVal ;
    [_axisY_labels addObject:[NSString stringWithFormat:LabelFormat,minVal]];
    for (int i = 0 ; i < _AxisY_partNumber; i++) {
        tempValue = tempValue + _AxisY_step;
        [_axisY_labels addObject:[NSString stringWithFormat:LabelFormat,tempValue]];
    }
}

- (void) vectorXSetup
{
    _AxisX_partNumber += 1;
    _vectorX_Size = self.frame.size.width - (_AxisX_Margin) - 15 ;
    _vectorX_Steps = (_vectorX_Size) / (_AxisX_partNumber) ;
    _endPointVecotrX = CGPointMake(_startPoint.x + _vectorX_Size, _startPoint.y) ;
    _startPointVectorX = _startPoint ;
}

- (void) vectorYSetup
{
    _AxisY_partNumber += 1;
    _vectorY_Size = self.frame.size.height - (_AxisY_Margin) - 15;
    _vectorY_Steps = (_vectorY_Size) / (_AxisY_partNumber);
    _endPointVecotrY = CGPointMake(_startPoint.x, _startPoint.y - _vectorY_Size) ;
    _startPointVectorY = _startPoint ;
}

- (void) showXLabelsInPosition : (CGPoint) point AndWithText : (NSString *) title
{
    CGRect frame = CGRectMake(point.x, point.y, 30, 10);
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:frame];
    descriptionLabel.text = title;
    descriptionLabel.font = _descriptionTextFont;
    descriptionLabel.textColor = _descriptionTextColor;
    descriptionLabel.shadowColor = _descriptionTextShadowColor;
    descriptionLabel.shadowOffset = _descriptionTextShadowOffset;
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:descriptionLabel];
}

- (void)setChartData:(NSArray *)data
{
    if (data != _chartData) {
        CGFloat yFinilizeValue , xFinilizeValue;
        CGFloat yValue , xValue;
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        pathAnimation.duration = _duration;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @(0.0f);
        pathAnimation.toValue = @(1.0f);
        pathAnimation.fillMode = kCAFillModeForwards;
        self.layer.opacity = 1;
        
        for (PNScatterChartData *chartData in data) {
            for (NSUInteger i = 0; i < chartData.itemCount; i++) {
                yValue = chartData.getData(i).y;
                xValue = chartData.getData(i).x;
                if (!(xValue >= _AxisX_minValue && xValue <= _AxisX_maxValue) || !(yValue >= _AxisY_minValue && yValue <= _AxisY_maxValue)) {
                    NSLog(@"input is not in correct range.");
                    exit(0);
                }
                xFinilizeValue = [self mappingIsForAxisX:true WithValue:xValue];
                yFinilizeValue = [self mappingIsForAxisX:false WithValue:yValue];
                CAShapeLayer *shape = [self drawingPointsForChartData:chartData AndWithX:xFinilizeValue AndWithY:yFinilizeValue];
                [self.layer addSublayer:shape];
                self.pathLayer = shape ;
                [self.pathLayer addAnimation:pathAnimation forKey:@"fade"];
            }
        }
    }
}

- (CGFloat) mappingIsForAxisX : (BOOL) isForAxisX WithValue : (CGFloat) value{
    
    if (isForAxisX) {
        float temp = _startPointVectorX.x + (_vectorX_Steps / 2) ;
        CGFloat xPos = temp + (((value - _AxisX_minValue)/_AxisX_step) * _vectorX_Steps) ;
        return xPos;
    }
    else {
        float temp = _startPointVectorY.y - (_vectorY_Steps / 2) ;
        CGFloat yPos = temp - (((value - _AxisY_minValue) /_AxisY_step) * _vectorY_Steps);
        return yPos;
    }
    return 0;
}

#pragma drawing methods

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (_showCoordinateAxis) {
        CGContextSetStrokeColorWithColor(context, [_axisColor CGColor]);
        CGContextSetLineWidth(context, _axisWidth);
        //drawing x vector
        CGContextMoveToPoint(context, _startPoint.x, _startPoint.y);
        CGContextAddLineToPoint(context, _endPointVecotrX.x, _endPointVecotrX.y);
        //drawing y vector
        CGContextMoveToPoint(context, _startPoint.x, _startPoint.y);
        CGContextAddLineToPoint(context, _endPointVecotrY.x, _endPointVecotrY.y);
        //drawing x arrow vector
        CGContextMoveToPoint(context, _endPointVecotrX.x, _endPointVecotrX.y);
        CGContextAddLineToPoint(context, _endPointVecotrX.x - 5, _endPointVecotrX.y + 3);
        CGContextMoveToPoint(context, _endPointVecotrX.x, _endPointVecotrX.y);
        CGContextAddLineToPoint(context, _endPointVecotrX.x - 5, _endPointVecotrX.y - 3);
        //drawing y arrow vector
        CGContextMoveToPoint(context, _endPointVecotrY.x, _endPointVecotrY.y);
        CGContextAddLineToPoint(context, _endPointVecotrY.x - 3, _endPointVecotrY.y + 5);
        CGContextMoveToPoint(context, _endPointVecotrY.x, _endPointVecotrY.y);
        CGContextAddLineToPoint(context, _endPointVecotrY.x + 3, _endPointVecotrY.y + 5);
    }
    
    if (_showLabel) {
        NSString *str;
        //drawing x steps vector and putting axis x labels
        float temp = _startPointVectorX.x + (_vectorX_Steps / 2) ;
        for (int i = 0; i < _AxisX_partNumber; i++) {
            CGContextMoveToPoint(context, temp, _startPointVectorX.y - 2);
            CGContextAddLineToPoint(context, temp, _startPointVectorX.y + 3);
            str = [_axisX_labels objectAtIndex:i];
            [self showXLabelsInPosition:CGPointMake(temp - 15, _startPointVectorX.y + 10 ) AndWithText:str];
            temp = temp + _vectorX_Steps ;
        }
        //drawing y steps vector and putting axis x labels
        temp = _startPointVectorY.y - (_vectorY_Steps / 2) ;
        for (int i = 0; i < _AxisY_partNumber; i++) {
            CGContextMoveToPoint(context, _startPointVectorY.x - 3, temp);
            CGContextAddLineToPoint(context, _startPointVectorY.x + 2, temp);
            str = [_axisY_labels objectAtIndex:i];
            [self showXLabelsInPosition:CGPointMake(_startPointVectorY.x - 30, temp - 5) AndWithText:str];
            temp = temp - _vectorY_Steps ;
        }
    }
    CGContextDrawPath(context, kCGPathStroke);
}

- (CAShapeLayer*) drawingPointsForChartData : (PNScatterChartData *) chartData AndWithX : (CGFloat) X AndWithY : (CGFloat) Y
{
    if (chartData.inflexionPointStyle == PNScatterChartPointStyleCircle) {
        float radius = chartData.size;
        CAShapeLayer *circle = [CAShapeLayer layer];
        // Make a circular shape
        circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(X - radius, Y - radius, 2.0*radius, 2.0*radius)
                                                 cornerRadius:radius].CGPath;
        // Configure the apperence of the circle
        circle.fillColor = [chartData.fillColor CGColor];
        circle.strokeColor = [chartData.strokeColor CGColor];
        circle.lineWidth = 1;
        
        // Add to parent layer
        return circle;
    }
    else if (chartData.inflexionPointStyle == PNScatterChartPointStyleSquare) {
        float side = chartData.size;
        CAShapeLayer *square = [CAShapeLayer layer];
        // Make a circular shape
        square.path = [UIBezierPath bezierPathWithRect:CGRectMake(X - (side/2) , Y - (side/2), side, side)].CGPath ;
        // Configure the apperence of the circle
        square.fillColor = [chartData.fillColor CGColor];
        square.strokeColor = [chartData.strokeColor CGColor];
        square.lineWidth = 1;
        
        // Add to parent layer
        return square;
    }
    else {
        // you cann add your own scatter chart poin here
    }
    return nil ;
}

- (void) drawLineFromPoint : (CGPoint) startPoint ToPoint : (CGPoint) endPoint WithLineWith : (CGFloat) lineWidth AndWithColor : (UIColor*) color{
    // calculating start and end point
    CGFloat startX = [self mappingIsForAxisX:true WithValue:startPoint.x];
    CGFloat startY = [self mappingIsForAxisX:false WithValue:startPoint.y];
    CGFloat endX = [self mappingIsForAxisX:true WithValue:endPoint.x];
    CGFloat endY = [self mappingIsForAxisX:false WithValue:endPoint.y];
    // drawing path between two points
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(startX, startY)];
    [path addLineToPoint:CGPointMake(endX, endY)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [color CGColor];
    shapeLayer.lineWidth = lineWidth;
    shapeLayer.fillColor = [color CGColor];
    // adding animation to path
    CABasicAnimation *animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animateStrokeEnd.duration  = _duration;
    animateStrokeEnd.fromValue = [NSNumber numberWithFloat:0.0f];
    animateStrokeEnd.toValue   = [NSNumber numberWithFloat:1.0f];
    [shapeLayer addAnimation:animateStrokeEnd forKey:nil];
    [self.layer addSublayer:shapeLayer];
}

@end
