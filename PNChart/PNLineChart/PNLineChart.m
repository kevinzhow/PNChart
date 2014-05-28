//
//  PNLineChart.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNLineChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"


//------------------------------------------------------------------------------------------------
// private interface declaration
//------------------------------------------------------------------------------------------------
@interface PNLineChart ()

@property (nonatomic) NSMutableArray *chartLineArray;  // Array[CAShapeLayer]
@property (nonatomic) NSMutableArray *chartPointArray; // Array[CAShapeLayer] save the point layer

@property (nonatomic) NSMutableArray *chartPath;       // Array of line path, one for each line.
@property (nonatomic) NSMutableArray *pointPath;       // Array of point path, one for each line

- (void)setDefaultValues;

@end


//------------------------------------------------------------------------------------------------
// public interface implementation
//------------------------------------------------------------------------------------------------
@implementation PNLineChart

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


#pragma mark instance methods

- (void)setYLabels:(NSArray *)yLabels
{
    CGFloat yStep = (_yValueMax - _yValueMin) / _yLabelNum;
    CGFloat yStepHeight = _chartCavanHeight / _yLabelNum;


    NSInteger index = 0;
    NSInteger num = _yLabelNum + 1;

    while (num > 0) {
        PNChartLabel *label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0, (_chartCavanHeight - index * yStepHeight), _chartMargin, _yLabelHeight)];
        [label setTextAlignment:NSTextAlignmentRight];
        NSString *yLabelFormat = self.yLabelFormat ? self.yLabelFormat : @"%1.f";
        label.text = [NSString stringWithFormat:yLabelFormat, _yValueMin + (yStep * index)];
        [self addSubview:label];
        index += 1;
        num -= 1;
    }
}


- (void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    NSString *labelText;

    if (_showLabel) {
        _xLabelWidth = _chartCavanWidth / [xLabels count];

        for (int index = 0; index < xLabels.count; index++) {
            labelText = xLabels[index];
            PNChartLabel *label = [[PNChartLabel alloc] initWithFrame:CGRectMake(2 * _chartMargin +  (index * _xLabelWidth) - (_xLabelWidth / 2), _chartMargin + _chartCavanHeight, _xLabelWidth, _chartMargin)];
            [label setTextAlignment:NSTextAlignmentCenter];
            label.text = labelText;
            [self addSubview:label];
        }
    }
    else {
        _xLabelWidth = (self.frame.size.width) / [xLabels count];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchPoint:touches withEvent:event];
    [self touchKeyPoint:touches withEvent:event];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchPoint:touches withEvent:event];
    [self touchKeyPoint:touches withEvent:event];
}


- (void)touchPoint:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];

    for (int p = _pathPoints.count - 1; p >= 0; p--) {
        NSArray *linePointsArray = _pathPoints[p];

        for (int i = 0; i < linePointsArray.count - 1; i += 1) {
            CGPoint p1 = [linePointsArray[i] CGPointValue];
            CGPoint p2 = [linePointsArray[i + 1] CGPointValue];

            // Closest distance from point to line
            float distance = fabsf(((p2.x - p1.x) * (touchPoint.y - p1.y)) - ((p1.x - touchPoint.x) * (p1.y - p2.y)));
            distance /= hypot(p2.x - p1.x, p1.y - p2.y);

            if (distance <= 5.0) {
                // Conform to delegate parameters, figure out what bezier path this CGPoint belongs to.
                for (UIBezierPath *path in _chartPath) {
                    BOOL pointContainsPath = CGPathContainsPoint(path.CGPath, NULL, p1, NO);

                    if (pointContainsPath) {
                        [_delegate userClickedOnLinePoint:touchPoint lineIndex:[_chartPath indexOfObject:path]];
                        return;
                    }
                }
            }
        }
    }
}


- (void)touchKeyPoint:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];

    for (int p = _pathPoints.count - 1; p >= 0; p--) {
        NSArray *linePointsArray = _pathPoints[p];

        for (int i = 0; i < linePointsArray.count - 1; i += 1) {
            CGPoint p1 = [linePointsArray[i] CGPointValue];
            CGPoint p2 = [linePointsArray[i + 1] CGPointValue];

            float distanceToP1 = fabsf(hypot(touchPoint.x - p1.x, touchPoint.y - p1.y));
            float distanceToP2 = hypot(touchPoint.x - p2.x, touchPoint.y - p2.y);

            float distance = MIN(distanceToP1, distanceToP2);

            if (distance <= 10.0) {
                [_delegate userClickedOnLineKeyPoint:touchPoint
                                           lineIndex:p
                                       andPointIndex:(distance == distanceToP2 ? i + 1 : i)];
                return;
            }
        }
    }
}


- (void)strokeChart
{
    _chartPath = [[NSMutableArray alloc] init];
    _pointPath = [[NSMutableArray alloc] init];

    //Draw each line
    for (NSUInteger lineIndex = 0; lineIndex < self.chartData.count; lineIndex++) {
        PNLineChartData *chartData = self.chartData[lineIndex];
        CAShapeLayer *chartLine = (CAShapeLayer *)self.chartLineArray[lineIndex];
        CAShapeLayer *pointLayer = (CAShapeLayer *)self.chartPointArray[lineIndex];
        
        CGFloat yValue;
        CGFloat innerGrade;

        UIGraphicsBeginImageContext(self.frame.size);
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        [progressline setLineWidth:chartData.lineWidth];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        
        UIBezierPath *pointPath = [UIBezierPath bezierPath];
        [pointPath setLineWidth:chartData.lineWidth];
        
        [_chartPath addObject:progressline];
        [_pointPath addObject:pointPath];

        if (!_showLabel) {
            _chartCavanHeight = self.frame.size.height - 2 * _yLabelHeight;
            _chartCavanWidth = self.frame.size.width;
            _chartMargin = 0.0;
            _xLabelWidth = (_chartCavanWidth / ([_xLabels count] - 1));
        }

        NSMutableArray *linePointsArray = [[NSMutableArray alloc] init];

        int last_x = 0;
        int last_y = 0;
        CGFloat inflexionWidth = chartData.inflexionPointWidth;
        
        for (NSUInteger i = 0; i < chartData.itemCount; i++) {
            
            yValue = chartData.getData(i).y;

            innerGrade = (yValue - _yValueMin) / (_yValueMax - _yValueMin);
            
            int x = 2 * _chartMargin +  (i * _xLabelWidth);
            int y = _chartCavanHeight - (innerGrade * _chartCavanHeight) + (_yLabelHeight / 2);
            
            // cycle style point
            if (chartData.inflexionPointStyle == PNLineChartPointStyleCycle) {
                
                CGRect circleRect = CGRectMake(x-inflexionWidth/2, y-inflexionWidth/2, inflexionWidth,inflexionWidth);
                CGPoint circleCenter = CGPointMake(circleRect.origin.x + (circleRect.size.width / 2), circleRect.origin.y + (circleRect.size.height / 2));
                
                [pointPath moveToPoint:CGPointMake(circleCenter.x + (inflexionWidth/2), circleCenter.y)];
                [pointPath addArcWithCenter:circleCenter radius:inflexionWidth/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
                
                if ( i != 0 ) {
                    
                    // calculate the point for line
                    float distance = sqrt( pow(x-last_x, 2) + pow(y-last_y,2) );
                    float last_x1 = last_x + (inflexionWidth/2) / distance * (x-last_x);
                    float last_y1 = last_y + (inflexionWidth/2) / distance * (y-last_y);
                    float x1 = x - (inflexionWidth/2) / distance * (x-last_x);
                    float y1 = y - (inflexionWidth/2) / distance * (y-last_y);
                    
                    [progressline moveToPoint:CGPointMake(last_x1, last_y1)];
                    [progressline addLineToPoint:CGPointMake(x1, y1)];
                }
                
                last_x = x;
                last_y = y;
            }
            // Square style point
            else if (chartData.inflexionPointStyle == PNLineChartPointStyleSquare) {
                
                CGRect squareRect = CGRectMake(x-inflexionWidth/2, y-inflexionWidth/2, inflexionWidth,inflexionWidth);
                CGPoint squareCenter = CGPointMake(squareRect.origin.x + (squareRect.size.width / 2), squareRect.origin.y + (squareRect.size.height / 2));
                
                [pointPath moveToPoint:CGPointMake(squareCenter.x - (inflexionWidth/2), squareCenter.y - (inflexionWidth/2))];
                [pointPath addLineToPoint:CGPointMake(squareCenter.x + (inflexionWidth/2), squareCenter.y - (inflexionWidth/2))];
                [pointPath addLineToPoint:CGPointMake(squareCenter.x + (inflexionWidth/2), squareCenter.y + (inflexionWidth/2))];
                [pointPath addLineToPoint:CGPointMake(squareCenter.x - (inflexionWidth/2), squareCenter.y + (inflexionWidth/2))];
                [pointPath closePath];
                
                if ( i != 0 ) {
                    
                    // calculate the point for line
                    float distance = sqrt( pow(x-last_x, 2) + pow(y-last_y,2) );
                    float last_x1 = last_x + (inflexionWidth/2);
                    float last_y1 = last_y + (inflexionWidth/2) / distance * (y-last_y);
                    float x1 = x - (inflexionWidth/2);
                    float y1 = y - (inflexionWidth/2) / distance * (y-last_y);
                    
                    [progressline moveToPoint:CGPointMake(last_x1, last_y1)];
                    [progressline addLineToPoint:CGPointMake(x1, y1)];
                }
                
                last_x = x;
                last_y = y;
            }
            // Triangle style point
            else if (chartData.inflexionPointStyle == PNLineChartPointStyleTriangle) {
                
                if ( i != 0 ) {
                    [progressline addLineToPoint:CGPointMake(x, y)];
                }
                
                [progressline moveToPoint:CGPointMake(x, y)];
            } else {
                
                if ( i != 0 ) {
                    [progressline addLineToPoint:CGPointMake(x, y)];
                }
                
                [progressline moveToPoint:CGPointMake(x, y)];
            }
            
            [linePointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        }

        [_pathPoints addObject:[linePointsArray copy]];

        // setup the color of the chart line
        if (chartData.color) {
            chartLine.strokeColor = [chartData.color CGColor];
            pointLayer.strokeColor = [chartData.color CGColor];
        }
        else {
            chartLine.strokeColor = [PNGreen CGColor];
            pointLayer.strokeColor = [PNGreen CGColor];
        }

        [progressline stroke];

        chartLine.path = progressline.CGPath;
        pointLayer.path = pointPath.CGPath;
        
    
        [CATransaction begin];
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 1.0;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @0.0f;
        pathAnimation.toValue   = @1.0f;

        [chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        chartLine.strokeEnd = 1.0;
        
        if (chartData.inflexionPointStyle == PNLineChartPointStyleCycle) {
            [pointLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        }
        
        [CATransaction setCompletionBlock:^{
            //pointLayer.strokeEnd = 1.0f; // stroken point when animation end
        }];
        [CATransaction commit];

        UIGraphicsEndImageContext();
    }
}

- (void)setChartData:(NSArray *)data
{
    if (data != _chartData) {
        NSMutableArray *yLabelsArray = [NSMutableArray arrayWithCapacity:data.count];
        CGFloat yMax = 0.0f;
        CGFloat yMin = MAXFLOAT;
        CGFloat yValue;

        // remove all shape layers before adding new ones
        for (CALayer *layer in self.chartLineArray) {
            [layer removeFromSuperlayer];
        }
        for (CALayer *layer in self.chartPointArray) {
            [layer removeFromSuperlayer];
        }

        self.chartLineArray = [NSMutableArray arrayWithCapacity:data.count];
        self.chartPointArray = [NSMutableArray arrayWithCapacity:data.count];

        // set for point stoken
        float circle_stroke_width = 2.f;
        float line_width = 3.0f;
        
        for (PNLineChartData *chartData in data) {
            // create as many chart line layers as there are data-lines
            CAShapeLayer *chartLine = [CAShapeLayer layer];
            chartLine.lineCap       = kCALineCapButt;
            chartLine.lineJoin      = kCALineJoinMiter;
            chartLine.fillColor     = [[UIColor whiteColor] CGColor];
            chartLine.lineWidth     = line_width;
            chartLine.strokeEnd     = 0.0;
            [self.layer addSublayer:chartLine];
            [self.chartLineArray addObject:chartLine];

            // create point
            CAShapeLayer *pointLayer = [CAShapeLayer layer];
            pointLayer.strokeColor   = [chartData.color CGColor];
            pointLayer.lineCap       = kCALineCapRound;
            pointLayer.lineJoin      = kCALineJoinBevel;
            pointLayer.fillColor     = nil;
            pointLayer.lineWidth     = circle_stroke_width;
            [self.layer addSublayer:pointLayer];
            [self.chartPointArray addObject:pointLayer];
            
            for (NSUInteger i = 0; i < chartData.itemCount; i++) {
                yValue = chartData.getData(i).y;
                [yLabelsArray addObject:[NSString stringWithFormat:@"%2f", yValue]];
                yMax = fmaxf(yMax, yValue);
                yMin = fminf(yMin, yValue);
            }
        }

        // Min value for Y label
        if (yMax < 5) {
            yMax = 5.0f;
        }

        if (yMin < 0) {
            yMin = 0.0f;
        }

        _yValueMin = yMin;
        _yValueMax = yMax;

        _chartData = data;

        if (_showLabel) {
            [self setYLabels:yLabelsArray];
        }

        [self setNeedsDisplay];
    }
}

#define IOS7_OR_LATER [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

- (void)drawRect:(CGRect)rect
{
    if (self.isShowCoordinateAxis) {
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(ctx);
        CGContextSetLineWidth(ctx, self.axisWidth);
        CGContextSetStrokeColorWithColor(ctx, [self.axisColor CGColor]);

        // draw coordinate axis
        CGContextMoveToPoint(ctx, _chartMargin + 10, 0);
        CGContextAddLineToPoint(ctx, _chartMargin + 10, _chartMargin + _chartCavanHeight);
        CGContextAddLineToPoint(ctx, CGRectGetWidth(rect) - _chartMargin, _chartMargin + _chartCavanHeight);
        CGContextStrokePath(ctx);
        
        // draw y axis arrow
        CGContextMoveToPoint(ctx, _chartMargin + 6, 8);
        CGContextAddLineToPoint(ctx, _chartMargin + 10, 0);
        CGContextAddLineToPoint(ctx, _chartMargin + 14, 8);
        CGContextStrokePath(ctx);

        // draw x axis arrow
        CGContextMoveToPoint(ctx, CGRectGetWidth(rect) - _chartMargin - 8, _chartMargin + _chartCavanHeight - 4);
        CGContextAddLineToPoint(ctx, CGRectGetWidth(rect) - _chartMargin, _chartMargin + _chartCavanHeight);
        CGContextAddLineToPoint(ctx, CGRectGetWidth(rect) - _chartMargin - 8, _chartMargin + _chartCavanHeight + 4);
        CGContextStrokePath(ctx);
        
        UIFont *font = [UIFont systemFontOfSize:11];
        // draw y unit
        if ([self.yUnit length]) {
            CGFloat height = [PNLineChart heightOfString:self.yUnit withWidth:30.f font:font];
            CGRect drawRect = CGRectMake(_chartMargin + 10 + 5, 0, 30.f, height);
            [self drawTextInContext:ctx text:self.yUnit inRect:drawRect font:font];
        }

        // draw x unit
        if ([self.xUnit length]) {
            CGFloat height = [PNLineChart heightOfString:self.xUnit withWidth:30.f font:font];
            CGRect drawRect = CGRectMake(CGRectGetWidth(rect) - _chartMargin + 5, _chartMargin + _chartCavanHeight - height/2, 25.f, height);
            [self drawTextInContext:ctx text:self.xUnit inRect:drawRect font:font];
        }
    }
    
    [super drawRect:rect];
}

#pragma mark private methods

- (void)setDefaultValues
{
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds   = YES;
    self.chartLineArray  = [NSMutableArray new];
    _showLabel           = YES;
    _pathPoints = [[NSMutableArray alloc] init];
    self.userInteractionEnabled = YES;

    _yLabelNum = 5.0;
    _yLabelHeight = [[[[PNChartLabel alloc] init] font] pointSize];

    _chartMargin = 40;

    _chartCavanWidth = self.frame.size.width - _chartMargin * 2;
    _chartCavanHeight = self.frame.size.height - _chartMargin * 2;
    
    // Coordinate Axis Default Values
    _showCoordinateAxis = NO;
    _axisColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.f];
    _axisWidth = 1.f;
}

#pragma mark - tools

+ (float)heightOfString:(NSString *)text withWidth:(float)width font:(UIFont *)font
{
    NSInteger ch;
    CGSize size = CGSizeMake(width, MAXFLOAT);
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
        size =[text boundingRectWithSize:size
                                 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                              attributes:tdic
                                 context:nil].size;
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
    }
    ch = size.height;
    
    return ch;
}

- (void)drawTextInContext:(CGContextRef )ctx text:(NSString *)text inRect:(CGRect)rect font:(UIFont *)font
{
    if (IOS7_OR_LATER) {
        NSMutableParagraphStyle *priceParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        priceParagraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        priceParagraphStyle.alignment = NSTextAlignmentLeft;
        
        [text drawInRect:rect
          withAttributes:@{NSParagraphStyleAttributeName:priceParagraphStyle, NSFontAttributeName:font}];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [text drawInRect:rect
                            withFont:font
                       lineBreakMode:NSLineBreakByTruncatingTail
                           alignment:NSTextAlignmentLeft];
#pragma clang diagnostic pop
    }
}


@end
