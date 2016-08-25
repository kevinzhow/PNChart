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
@property (nonatomic, weak) NSMutableArray *verticalLineLayer;
@property (nonatomic, weak) NSMutableArray *horizentalLinepathLayer;

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

@property (nonatomic) BOOL isForUpdate;

@end


@implementation PNScatterChart

#pragma mark initialization

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

- (void) setup
{
    [self vectorXSetup];
    [self vectorYSetup];
}

- (void)setupDefaultValues
{
    [super setupDefaultValues];
    
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds   = YES;
    _showLabel           = YES;
    _isForUpdate         = NO;
    self.userInteractionEnabled = YES;
    
    // Coordinate Axis Default Values
    _showCoordinateAxis = YES;
    _axisColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.f];
    _axisWidth = 1.f;
    
    // Initialization code
    _AxisX_Margin = 30 ;
    _AxisY_Margin = 30 ;
    
//    self.frame = CGRectMake((SCREEN_WIDTH - self.frame.size.width) / 2, 200, self.frame.size.width, self.frame.size.height) ;
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
    
    NSString *LabelFormat = self.xLabelFormat ? : @"%1.f";
    CGFloat tempValue = minVal ;
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:LabelFormat,minVal] ;
    [_axisX_labels addObject:label];
    for (int i = 0 ; i < _AxisX_partNumber; i++) {
        tempValue = tempValue + _AxisX_step;
        UILabel *tempLabel = [[UILabel alloc] init];
        tempLabel.text = [NSString stringWithFormat:LabelFormat,tempValue] ;
        [_axisX_labels addObject:tempLabel];
    }
}

- (void) setAxisYWithMinimumValue:(CGFloat)minVal andMaxValue:(CGFloat)maxVal toTicks:(int)numberOfTicks
{
    _AxisY_minValue = minVal ;
    _AxisY_maxValue = maxVal ;
    _AxisY_partNumber = numberOfTicks - 1;
    _AxisY_step = (float)((maxVal - minVal)/_AxisY_partNumber);
    
    NSString *LabelFormat = self.yLabelFormat ? : @"%1.f";
    CGFloat tempValue = minVal ;
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:LabelFormat,minVal] ;
    [_axisY_labels addObject:label];
    for (int i = 0 ; i < _AxisY_partNumber; i++) {
        tempValue = tempValue + _AxisY_step;
        UILabel *tempLabel = [[UILabel alloc] init];
        tempLabel.text = [NSString stringWithFormat:LabelFormat,tempValue] ;
        [_axisY_labels addObject:tempLabel];
    }
}

- (NSArray*) getAxisMinMax:(NSArray*)xValues
{
    float min = [xValues[0] floatValue];
    float max = [xValues[0] floatValue];
    for (NSNumber *number in xValues)
    {
        if ([number floatValue] > max)
            max = [number floatValue];
        
        if ([number floatValue] < min)
            min = [number floatValue];
    }
    NSArray *result = @[[NSNumber numberWithFloat:min], [NSNumber numberWithFloat:max]];
   
    
    return result;
}

- (void)setAxisXLabel:(NSArray *)array {
    if(array.count == ++_AxisX_partNumber){
        [_axisX_labels removeAllObjects];
        for(int i=0;i<array.count;i++){
            UILabel *label = [[UILabel alloc] init];
            label.text = [array objectAtIndex:i];
            [_axisX_labels addObject:label];
        }
    }
}

- (void)setAxisYLabel:(NSArray *)array {
    if(array.count == ++_AxisY_partNumber){
        [_axisY_labels removeAllObjects];
        for(int i=0;i<array.count;i++){
            UILabel *label = [[UILabel alloc] init];
            label.text = [array objectAtIndex:i];
            [_axisY_labels addObject:label];
        }
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

- (void) showXLabel : (UILabel *) descriptionLabel InPosition : (CGPoint) point
{
    CGRect frame = CGRectMake(point.x, point.y, 30, 10);
    descriptionLabel.frame = frame;
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
    __block CGFloat yFinilizeValue , xFinilizeValue;
    __block CGFloat yValue , xValue;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.displayAnimated) {
            [NSThread sleepForTimeInterval:1];
        }
        // update UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
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
                    self.pathLayer = shape ;
                    [self.layer addSublayer:self.pathLayer];
                    
                    [self addAnimationIfNeeded];
                }
            }
        });
    });
}

- (void)addAnimationIfNeeded{
    
    if (self.displayAnimated) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        pathAnimation.duration = _duration;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @(0.0f);
        pathAnimation.toValue = @(1.0f);
        pathAnimation.fillMode = kCAFillModeForwards;
        self.layer.opacity = 1;
        [self.pathLayer addAnimation:pathAnimation forKey:@"fade"];
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

#pragma mark - Update Chart Data

- (void)updateChartData:(NSArray *)data
{
    _chartData = data;

    // will be work in future.
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
        //drawing x steps vector and putting axis x labels
        float temp = _startPointVectorX.x + (_vectorX_Steps / 2) ;
        for (int i = 0; i < _axisX_labels.count; i++) {
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(temp, _startPointVectorX.y - 2)];
            [path addLineToPoint:CGPointMake(temp, _startPointVectorX.y + 3)];
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.path = [path CGPath];
            shapeLayer.strokeColor = [_axisColor CGColor];
            shapeLayer.lineWidth = _axisWidth;
            shapeLayer.fillColor = [_axisColor CGColor];
            [self.horizentalLinepathLayer addObject:shapeLayer];
            [self.layer addSublayer:shapeLayer];
            UILabel *lb = [_axisX_labels objectAtIndex:i] ;
            [self showXLabel:lb InPosition:CGPointMake(temp - 15, _startPointVectorX.y + 10 )];
            temp = temp + _vectorX_Steps ;
        }
        //drawing y steps vector and putting axis x labels
        temp = _startPointVectorY.y - (_vectorY_Steps / 2) ;
        for (int i = 0; i < _axisY_labels.count; i++) {
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(_startPointVectorY.x - 3, temp)];
            [path addLineToPoint:CGPointMake( _startPointVectorY.x + 2, temp)];
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.path = [path CGPath];
            shapeLayer.strokeColor = [_axisColor CGColor];
            shapeLayer.lineWidth = _axisWidth;
            shapeLayer.fillColor = [_axisColor CGColor];
            [self.verticalLineLayer addObject:shapeLayer];
            [self.layer addSublayer:shapeLayer];
            UILabel *lb = [_axisY_labels objectAtIndex:i];
            [self showXLabel:lb InPosition:CGPointMake(_startPointVectorY.x - 30, temp - 5)];
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
        // Configure the appearence of the circle
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
        // you cann add your own scatter chart point here
    }
    return nil ;
}

- (void) drawLineFromPoint : (CGPoint) startPoint ToPoint : (CGPoint) endPoint WithLineWith : (CGFloat) lineWidth AndWithColor : (UIColor*) color{
    
    // call the same method on a background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.displayAnimated) {
            [NSThread sleepForTimeInterval:2];
        }
        // calculating start and end point
        __block CGFloat startX = [self mappingIsForAxisX:true WithValue:startPoint.x];
        __block CGFloat startY = [self mappingIsForAxisX:false WithValue:startPoint.y];
        __block CGFloat endX = [self mappingIsForAxisX:true WithValue:endPoint.x];
        __block CGFloat endY = [self mappingIsForAxisX:false WithValue:endPoint.y];
        // update UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
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
            [self addStrokeEndAnimationIfNeededToLayer:shapeLayer];
            [self.layer addSublayer:shapeLayer];
        });
    });
}

- (void)addStrokeEndAnimationIfNeededToLayer:(CAShapeLayer *)shapeLayer{
    
    if (self.displayAnimated) {
        CABasicAnimation *animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animateStrokeEnd.duration  = _duration;
        animateStrokeEnd.fromValue = [NSNumber numberWithFloat:0.0f];
        animateStrokeEnd.toValue   = [NSNumber numberWithFloat:1.0f];
        [shapeLayer addAnimation:animateStrokeEnd forKey:nil];
    }
}

@end
