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

@interface PNLineChart ()

@property(nonatomic) NSMutableArray *chartLineArray;  // Array[CAShapeLayer]
@property(nonatomic) NSMutableArray *chartPointArray; // Array[CAShapeLayer] save the point layer

@property(nonatomic) NSMutableArray *chartPath;       // Array of line path, one for each line.
@property(nonatomic) NSMutableArray *pointPath;       // Array of point path, one for each line
@property(nonatomic) NSMutableArray *endPointsOfPath;      // Array of start and end points of each line path, one for each line

@property(nonatomic) CABasicAnimation *pathAnimation; // will be set to nil if _displayAnimation is NO

// display grade
@property(nonatomic) NSMutableArray *gradeStringPaths;
@property(nonatomic) NSMutableArray *progressLinePathsColors; //Array of colors when drawing each line.if chartData.rangeColors is set then different colors will be

@end

@implementation PNLineChart

@synthesize pathAnimation = _pathAnimation;

#pragma mark initialization

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];

    if (self) {
        [self setupDefaultValues];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self setupDefaultValues];
    }

    return self;
}


#pragma mark instance methods

- (void)setYLabels {
    CGFloat yStep = (_yValueMax - _yValueMin) / _yLabelNum;
    CGFloat yStepHeight = _chartCavanHeight / _yLabelNum;

    if (_yChartLabels) {
        for (PNChartLabel *label in _yChartLabels) {
            [label removeFromSuperview];
        }
    } else {
        _yChartLabels = [NSMutableArray new];
    }

    if (yStep == 0.0) {
        PNChartLabel *minLabel = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0, (NSInteger) _chartCavanHeight, (NSInteger) _chartMarginBottom, (NSInteger) _yLabelHeight)];
        minLabel.text = [self formatYLabel:0.0];
        [self setCustomStyleForYLabel:minLabel];
        [self addSubview:minLabel];
        [_yChartLabels addObject:minLabel];

        PNChartLabel *midLabel = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0, (NSInteger) (_chartCavanHeight / 2), (NSInteger) _chartMarginBottom, (NSInteger) _yLabelHeight)];
        midLabel.text = [self formatYLabel:_yValueMax];
        [self setCustomStyleForYLabel:midLabel];
        [self addSubview:midLabel];
        [_yChartLabels addObject:midLabel];

        PNChartLabel *maxLabel = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (NSInteger) _chartMarginBottom, (NSInteger) _yLabelHeight)];
        maxLabel.text = [self formatYLabel:_yValueMax * 2];
        [self setCustomStyleForYLabel:maxLabel];
        [self addSubview:maxLabel];
        [_yChartLabels addObject:maxLabel];

    } else {
        NSInteger index = 0;
        NSInteger num = _yLabelNum + 1;

        while (num > 0) {
            CGRect labelFrame = CGRectMake(0.0,
                    (NSInteger) (_chartCavanHeight + _chartMarginTop - index * yStepHeight),
                    (CGFloat) ((NSInteger) _chartMarginLeft * 0.9),
                    (NSInteger) _yLabelHeight);
            PNChartLabel *label = [[PNChartLabel alloc] initWithFrame:labelFrame];
            [label setTextAlignment:NSTextAlignmentRight];
            label.text = [self formatYLabel:_yValueMin + (yStep * index)];
            [self setCustomStyleForYLabel:label];
            [self addSubview:label];
            [_yChartLabels addObject:label];
            index += 1;
            num -= 1;
        }
    }
}

- (void)setYLabels:(NSArray *)yLabels {
    _showGenYLabels = NO;
    _yLabelNum = yLabels.count - 1;

    CGFloat yLabelHeight;
    if (_showLabel) {
        yLabelHeight = _chartCavanHeight / [yLabels count];
    } else {
        yLabelHeight = (self.frame.size.height) / [yLabels count];
    }

    return [self setYLabels:yLabels withHeight:yLabelHeight];
}

- (void)setYLabels:(NSArray *)yLabels withHeight:(CGFloat)height {
    _yLabels = yLabels;
    _yLabelHeight = height;
    if (_yChartLabels) {
        for (PNChartLabel *label in _yChartLabels) {
            [label removeFromSuperview];
        }
    } else {
        _yChartLabels = [NSMutableArray new];
    }

    NSString *labelText;

    if (_showLabel) {
        CGFloat yStepHeight = _chartCavanHeight / _yLabelNum;

        for (int index = 0; index < yLabels.count; index++) {
            labelText = yLabels[(NSUInteger) index];

            NSInteger y = (NSInteger) (_chartCavanHeight + _chartMarginTop - index * yStepHeight);

            PNChartLabel *label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0, y - (NSInteger) _chartMarginBottom / 2, (CGFloat) ((NSInteger) _chartMarginLeft * 0.9), (NSInteger) _yLabelHeight)];
            [label setTextAlignment:NSTextAlignmentRight];
            label.text = labelText;
            [self setCustomStyleForYLabel:label];
            [self addSubview:label];
            [_yChartLabels addObject:label];
        }
    }
}

- (CGFloat)computeEqualWidthForXLabels:(NSArray *)xLabels {
    CGFloat xLabelWidth;

    if (_showLabel) {
        xLabelWidth = _chartCavanWidth / [xLabels count];
    } else {
        xLabelWidth = (self.frame.size.width) / [xLabels count];
    }

    return xLabelWidth;
}


- (void)setXLabels:(NSArray *)xLabels {
    CGFloat xLabelWidth;

    if (_showLabel) {
        xLabelWidth = _chartCavanWidth / [xLabels count];
    } else {
        xLabelWidth = (self.frame.size.width - _chartMarginLeft - _chartMarginRight) / [xLabels count];
    }

    return [self setXLabels:xLabels withWidth:xLabelWidth];
}

- (void)setXLabels:(NSArray *)xLabels withWidth:(CGFloat)width {
    _xLabels = xLabels;
    _xLabelWidth = width;
    if (_xChartLabels) {
        for (PNChartLabel *label in _xChartLabels) {
            [label removeFromSuperview];
        }
    } else {
        _xChartLabels = [NSMutableArray new];
    }

    NSString *labelText;

    if (_showLabel) {
        for (NSUInteger index = 0; index < xLabels.count; index++) {
            labelText = xLabels[index];

            NSInteger x = (NSInteger) (index * _xLabelWidth + _chartMarginLeft);
            NSInteger y = (NSInteger) (_chartMarginBottom + _chartCavanHeight);

            PNChartLabel *label = [[PNChartLabel alloc] initWithFrame:CGRectMake(x, y, (NSInteger) _xLabelWidth, (NSInteger) _chartMarginBottom)];
            [label setTextAlignment:NSTextAlignmentCenter];
            label.text = labelText;
            [self setCustomStyleForXLabel:label];
            [self addSubview:label];
            [_xChartLabels addObject:label];
        }
    }
}

- (void)setCustomStyleForXLabel:(UILabel *)label {
    if (_xLabelFont) {
        label.font = _xLabelFont;
    }

    if (_xLabelColor) {
        label.textColor = _xLabelColor;
    }

}

- (void)setCustomStyleForYLabel:(UILabel *)label {
    if (_yLabelFont) {
        label.font = _yLabelFont;
    }

    if (_yLabelColor) {
        label.textColor = _yLabelColor;
    }
}

#pragma mark - Touch at point

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchPoint:touches withEvent:event];
    [self touchKeyPoint:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchPoint:touches withEvent:event];
    [self touchKeyPoint:touches withEvent:event];
}

- (void)touchPoint:(NSSet *)touches withEvent:(UIEvent *)event {
    // Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];

    for (NSUInteger p = 0; p < _pathPoints.count; p++) {
        NSArray *linePointsArray = _endPointsOfPath[p];

        for (NSUInteger i = 0; i < (int) linePointsArray.count - 1; i += 2) {
            CGPoint p1 = [linePointsArray[i] CGPointValue];
            CGPoint p2 = [linePointsArray[i + 1] CGPointValue];

            // Closest distance from point to line
            float distance = (float) fabs(((p2.x - p1.x) * (touchPoint.y - p1.y)) - ((p1.x - touchPoint.x) * (p1.y - p2.y)));
            distance /= hypot(p2.x - p1.x, p1.y - p2.y);

            if (distance <= 5.0) {
                // Conform to delegate parameters, figure out what bezier path this CGPoint belongs to.
                NSUInteger lineIndex = 0;
                for (NSArray<UIBezierPath *> *paths in _chartPath) {
                    for (UIBezierPath *path in paths) {
                        BOOL pointContainsPath = CGPathContainsPoint(path.CGPath, NULL, p1, NO);
                        if (pointContainsPath) {
                            [_delegate userClickedOnLinePoint:touchPoint lineIndex:lineIndex];
                            return;
                        }
                    }
                    lineIndex++;
                }
            }
        }
    }
}

- (void)touchKeyPoint:(NSSet *)touches withEvent:(UIEvent *)event {
    // Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];

    for (NSUInteger p = 0; p < _pathPoints.count; p++) {
        NSArray *linePointsArray = _pathPoints[p];

        for (NSUInteger i = 0; i < (int) linePointsArray.count - 1; i += 1) {
            CGPoint p1 = [linePointsArray[i] CGPointValue];
            CGPoint p2 = [linePointsArray[i + 1] CGPointValue];

            float distanceToP1 = (float) fabs(hypot(touchPoint.x - p1.x, touchPoint.y - p1.y));
            float distanceToP2 = (float) hypot(touchPoint.x - p2.x, touchPoint.y - p2.y);

            float distance = MIN(distanceToP1, distanceToP2);

            if (distance <= 10.0) {
                [_delegate userClickedOnLineKeyPoint:touchPoint
                                           lineIndex:p
                                          pointIndex:(distance == distanceToP2 ? i + 1 : i)];

                return;
            }
        }
    }
}

#pragma mark - Draw Chart

- (void)populateChartLines {
    for (NSUInteger lineIndex = 0; lineIndex < self.chartData.count; lineIndex++) {
        NSArray<UIBezierPath *> *progressLines = self.chartPath[lineIndex];
        // each chart line can be divided into multiple paths because
        // we need ot draw each path with different color
        // if there is not rangeColors then there is only one progressLinePath per chart
        NSArray<UIColor *> *progressLineColors = self.progressLinePathsColors[lineIndex];
        [self.chartLineArray[lineIndex] removeAllObjects];
        NSUInteger progressLineIndex = 0;;
        for (UIBezierPath *progressLinePath in progressLines) {
            PNLineChartData *chartData = self.chartData[lineIndex];
            CAShapeLayer *chartLine = [CAShapeLayer layer];
            chartLine.lineCap = kCALineCapButt;
            chartLine.lineJoin = kCALineJoinMiter;
            chartLine.fillColor = self.backgroundColor.CGColor;
            chartLine.lineWidth = chartData.lineWidth;
            chartLine.path = progressLinePath.CGPath;
            chartLine.strokeEnd = 0.0;
            chartLine.strokeColor = progressLineColors[progressLineIndex].CGColor;
            [self.layer addSublayer:chartLine];
            [self.chartLineArray[lineIndex] addObject:chartLine];
            progressLineIndex++;
        }
    }
}

/*
 * strokeChart should remove the previously drawn chart lines and points
 * and then proceed to draw the new lines
 */
- (void)strokeChart {
    [self removeLayers];
    // remove all shape layers before adding new ones
    [self recreatePointLayers];
    // Cavan height and width needs to be set before
    // setNeedsDisplay is invoked because setNeedsDisplay
    // will invoke drawRect and if Cavan dimensions is not
    // set the chart will be misplaced
    [self resetCavanHeight];
    [self prepareYLabelsWithData:_chartData];

    _chartPath = [[NSMutableArray alloc] init];
    _pointPath = [[NSMutableArray alloc] init];
    _gradeStringPaths = [NSMutableArray array];
    _progressLinePathsColors = [[NSMutableArray alloc] init];

    [self calculateChartPath:_chartPath
               andPointsPath:_pointPath
            andPathKeyPoints:_pathPoints
       andPathStartEndPoints:_endPointsOfPath
  andProgressLinePathsColors:_progressLinePathsColors];
    [self populateChartLines];
    // Draw each line
    for (NSUInteger lineIndex = 0; lineIndex < self.chartData.count; lineIndex++) {
        PNLineChartData *chartData = self.chartData[lineIndex];
        NSArray<CAShapeLayer *> *chartLines =self.chartLineArray[lineIndex];
        CAShapeLayer *pointLayer = (CAShapeLayer *) self.chartPointArray[lineIndex];
        UIGraphicsBeginImageContext(self.frame.size);
        if (chartData.inflexionPointColor) {
            pointLayer.strokeColor = [[chartData.inflexionPointColor
                    colorWithAlphaComponent:chartData.alpha] CGColor];
        } else {
            pointLayer.strokeColor = [PNGreen CGColor];
        }
        // setup the color of the chart line
        NSArray<UIBezierPath *> *progressLines = _chartPath[lineIndex];
        UIBezierPath *pointPath = _pointPath[lineIndex];

        pointLayer.path = pointPath.CGPath;

        [CATransaction begin];
        for (NSUInteger index = 0; index < progressLines.count; index++) {
            CAShapeLayer *chartLine = chartLines[index];
            //chartLine strokeColor is already set. no need to override here
            [chartLine addAnimation:self.pathAnimation forKey:@"strokeEndAnimation"];
            chartLine.strokeEnd = 1.0;
        }

        // if you want cancel the point animation, comment this code, the point will show immediately
        if (chartData.inflexionPointStyle != PNLineChartPointStyleNone) {
            [pointLayer addAnimation:self.pathAnimation forKey:@"strokeEndAnimation"];
        }

        [CATransaction commit];

        NSMutableArray *textLayerArray = self.gradeStringPaths[lineIndex];
        for (CATextLayer *textLayer in textLayerArray) {
            CABasicAnimation *fadeAnimation = [self fadeAnimation];
            [textLayer addAnimation:fadeAnimation forKey:nil];
        }

        UIGraphicsEndImageContext();
    }
    [self setNeedsDisplay];
}


- (void)calculateChartPath:(NSMutableArray *)chartPath
             andPointsPath:(NSMutableArray *)pointsPath
          andPathKeyPoints:(NSMutableArray *)pathPoints
     andPathStartEndPoints:(NSMutableArray *)pointsOfPath
andProgressLinePathsColors:(NSMutableArray *)progressLinePathsColors {

    // remove old point label
    for (NSArray *ary in _gradeStringPaths) {
        @autoreleasepool {
            for (CATextLayer *textLayer in ary) {
                [textLayer removeFromSuperlayer];
            }
        }
    }
    [self.gradeStringPaths removeAllObjects];
    
    
    // Draw each line

    for (NSUInteger lineIndex = 0; lineIndex < self.chartData.count; lineIndex++) {
        PNLineChartData *chartData = self.chartData[lineIndex];

        CGFloat yValue;
        NSMutableArray<UIBezierPath *> *progressLines = [NSMutableArray new];
        NSMutableArray<UIColor *> *progressLineColors = [NSMutableArray new];

        UIBezierPath *pointPath = [UIBezierPath bezierPath];


        [chartPath insertObject:progressLines atIndex:lineIndex];
        [pointsPath insertObject:pointPath atIndex:lineIndex];
        [progressLinePathsColors insertObject:progressLineColors atIndex:lineIndex];


        NSMutableArray *gradePathArray = [NSMutableArray array];
        [self.gradeStringPaths addObject:gradePathArray];

        NSMutableArray *linePointsArray = [[NSMutableArray alloc] init];
        NSMutableArray *lineStartEndPointsArray = [[NSMutableArray alloc] init];
        int last_x = 0;
        int last_y = 0;
        NSMutableArray<NSDictionary<NSString *, NSValue *> *> *progressLinePaths = [NSMutableArray new];
        UIColor *defaultColor = chartData.color != nil ? chartData.color : [UIColor greenColor];
        CGFloat inflexionWidth = chartData.inflexionPointWidth;

        for (NSUInteger i = 0; i < chartData.itemCount; i++) {

            NSValue *from = nil;
            NSValue *to = nil;

            yValue = chartData.getData(i).y;

            int x = (int) (i * _xLabelWidth + _chartMarginLeft + _xLabelWidth / 2.0);
            int y = (int)[self yValuePositionInLineChart:yValue];

            // Circular point
            if (chartData.inflexionPointStyle == PNLineChartPointStyleCircle) {

                CGRect circleRect = CGRectMake(x - inflexionWidth / 2, y - inflexionWidth / 2, inflexionWidth, inflexionWidth);
                CGPoint circleCenter = CGPointMake(circleRect.origin.x + (circleRect.size.width / 2), circleRect.origin.y + (circleRect.size.height / 2));

                [pointPath moveToPoint:CGPointMake(circleCenter.x + (inflexionWidth / 2), circleCenter.y)];
                [pointPath addArcWithCenter:circleCenter radius:inflexionWidth / 2 startAngle:0 endAngle:(CGFloat) (2 * M_PI) clockwise:YES];

                //jet text display text
                if (chartData.showPointLabel) {
                    [gradePathArray addObject:[self createPointLabelFor:chartData.getData(i).rawY pointCenter:circleCenter width:inflexionWidth withChartData:chartData]];
                }

                if (i > 0) {

                    // calculate the point for line
                    float distance = (float) sqrt(pow(x - last_x, 2) + pow(y - last_y, 2));
                    float last_x1 = last_x + (inflexionWidth / 2) / distance * (x - last_x);
                    float last_y1 = last_y + (inflexionWidth / 2) / distance * (y - last_y);
                    float x1 = x - (inflexionWidth / 2) / distance * (x - last_x);
                    float y1 = y - (inflexionWidth / 2) / distance * (y - last_y);
                    from = [NSValue valueWithCGPoint:CGPointMake(last_x1, last_y1)];
                    to = [NSValue valueWithCGPoint:CGPointMake(x1, y1)];
                }
            }
                // Square point
            else if (chartData.inflexionPointStyle == PNLineChartPointStyleSquare) {

                CGRect squareRect = CGRectMake(x - inflexionWidth / 2, y - inflexionWidth / 2, inflexionWidth, inflexionWidth);
                CGPoint squareCenter = CGPointMake(squareRect.origin.x + (squareRect.size.width / 2), squareRect.origin.y + (squareRect.size.height / 2));

                [pointPath moveToPoint:CGPointMake(squareCenter.x - (inflexionWidth / 2), squareCenter.y - (inflexionWidth / 2))];
                [pointPath addLineToPoint:CGPointMake(squareCenter.x + (inflexionWidth / 2), squareCenter.y - (inflexionWidth / 2))];
                [pointPath addLineToPoint:CGPointMake(squareCenter.x + (inflexionWidth / 2), squareCenter.y + (inflexionWidth / 2))];
                [pointPath addLineToPoint:CGPointMake(squareCenter.x - (inflexionWidth / 2), squareCenter.y + (inflexionWidth / 2))];
                [pointPath closePath];

                // text display text
                if (chartData.showPointLabel) {
                    [gradePathArray addObject:[self createPointLabelFor:chartData.getData(i).rawY pointCenter:squareCenter width:inflexionWidth withChartData:chartData]];
                }

                if (i > 0) {

                    // calculate the point for line
                    float distance = (float) sqrt(pow(x - last_x, 2) + pow(y - last_y, 2));
                    float last_x1 = last_x + (inflexionWidth / 2);
                    float last_y1 = last_y + (inflexionWidth / 2) / distance * (y - last_y);
                    float x1 = x - (inflexionWidth / 2);
                    float y1 = y - (inflexionWidth / 2) / distance * (y - last_y);
                    from = [NSValue valueWithCGPoint:CGPointMake(last_x1, last_y1)];
                    to = [NSValue valueWithCGPoint:CGPointMake(x1, y1)];
                }
            }
                // Triangle point
            else if (chartData.inflexionPointStyle == PNLineChartPointStyleTriangle) {

                CGRect squareRect = CGRectMake(x - inflexionWidth / 2, y - inflexionWidth / 2, inflexionWidth, inflexionWidth);

                CGPoint startPoint = CGPointMake(squareRect.origin.x, squareRect.origin.y + squareRect.size.height);
                CGPoint endPoint = CGPointMake(squareRect.origin.x + (squareRect.size.width / 2), squareRect.origin.y);
                CGPoint middlePoint = CGPointMake(squareRect.origin.x + (squareRect.size.width), squareRect.origin.y + squareRect.size.height);

                [pointPath moveToPoint:startPoint];
                [pointPath addLineToPoint:middlePoint];
                [pointPath addLineToPoint:endPoint];
                [pointPath closePath];

                // text display text
                if (chartData.showPointLabel) {
                    [gradePathArray addObject:[self createPointLabelFor:chartData.getData(i).rawY pointCenter:middlePoint width:inflexionWidth withChartData:chartData]];
                }

                if (i > 0) {
                    // calculate the point for triangle
                    float distance = (float) (sqrt(pow(x - last_x, 2) + pow(y - last_y, 2)) * 1.4);
                    float last_x1 = last_x + (inflexionWidth / 2) / distance * (x - last_x);
                    float last_y1 = last_y + (inflexionWidth / 2) / distance * (y - last_y);
                    float x1 = x - (inflexionWidth / 2) / distance * (x - last_x);
                    float y1 = y - (inflexionWidth / 2) / distance * (y - last_y);
                    from = [NSValue valueWithCGPoint:CGPointMake(last_x1, last_y1)];
                    to = [NSValue valueWithCGPoint:CGPointMake(x1, y1)];
                }
            } else {

                if (i > 0) {
                    from = [NSValue valueWithCGPoint:CGPointMake(last_x, last_y)];
                    to = [NSValue valueWithCGPoint:CGPointMake(x, y)];
                }
            }
            if(from != nil && to != nil) {
                [progressLinePaths addObject:@{@"from": from,  @"to":to}];
                [lineStartEndPointsArray addObject:from];
                [lineStartEndPointsArray addObject:to];
            }
            [linePointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
            last_x = x;
            last_y = y;
        }

        [pointsOfPath addObject:[lineStartEndPointsArray copy]];
        [pathPoints addObject:[linePointsArray copy]];
        // if rangeColors is not nil then it means we need to draw the chart
        // with different colors. colorRangesBetweenP1.. function takes care of
        // partitioning the p1->p2 into segments from which we can create UIBezierPath
        if (self.showSmoothLines && chartData.itemCount >= 4) {
            for (NSDictionary<NSString *, NSValue *> *item in progressLinePaths) {
                NSArray<NSDictionary *> *calculatedRanges =
                        [self colorRangesBetweenP1:[item[@"from"] CGPointValue]
                                                P2:[item[@"to"] CGPointValue]
                                       rangeColors:chartData.rangeColors
                                      defaultColor:defaultColor];
                for (NSDictionary *range in calculatedRanges) {
//                    NSLog(@"range : %@ range: %@ color %@", range[@"from"], range[@"to"], range[@"color"]);
                    UIBezierPath *currentProgressLine = [UIBezierPath bezierPath];
                    CGPoint segmentP1 = [range[@"from"] CGPointValue];
                    CGPoint segmentP2 = [range[@"to"] CGPointValue];
                    [currentProgressLine moveToPoint:segmentP1];
                    CGPoint midPoint = [PNLineChart midPointBetweenPoint1:segmentP1 andPoint2:segmentP2];
                    [currentProgressLine addQuadCurveToPoint:midPoint
                                                controlPoint:[PNLineChart controlPointBetweenPoint1:midPoint andPoint2:segmentP1]];
                    [currentProgressLine addQuadCurveToPoint:segmentP2
                                                controlPoint:[PNLineChart controlPointBetweenPoint1:midPoint andPoint2:segmentP2]];
                    [progressLines addObject:currentProgressLine];
                    [progressLineColors addObject:range[@"color"]];
                }
            }
        } else {
            for (NSDictionary<NSString *, NSValue *> *item in progressLinePaths) {
                NSArray<NSDictionary *> *calculatedRanges =
                        [self colorRangesBetweenP1:[item[@"from"] CGPointValue]
                                                P2:[item[@"to"] CGPointValue]
                                       rangeColors:chartData.rangeColors
                                      defaultColor:defaultColor];
                for (NSDictionary *range in calculatedRanges) {
//                    NSLog(@"range : %@ range: %@ color %@", range[@"from"], range[@"to"], range[@"color"]);
                    UIBezierPath *currentProgressLine = [UIBezierPath bezierPath];
                    [currentProgressLine moveToPoint:[range[@"from"] CGPointValue]];
                    [currentProgressLine addLineToPoint:[range[@"to"] CGPointValue]];
                    [progressLines addObject:currentProgressLine];
                    [progressLineColors addObject:range[@"color"]];
                }
            }
        }
    }
}

#pragma mark - Set Chart Data

- (void)setChartData:(NSArray *)data {
    if (data != _chartData) {
        _chartData = data;
    }
}


- (void)removeLayers {
    for (NSArray<CALayer *> *layers in self.chartLineArray) {
        for (CALayer *layer in layers) {
            [layer removeFromSuperlayer];
        }
    }
    for (CALayer *layer in self.chartPointArray) {
        [layer removeFromSuperlayer];
    }
    self.chartLineArray = [NSMutableArray arrayWithCapacity:_chartData.count];
    self.chartPointArray = [NSMutableArray arrayWithCapacity:_chartData.count];
}

-(void) resetCavanHeight {
    _chartCavanHeight = self.frame.size.height - _chartMarginBottom - _chartMarginTop;
    if (!_showLabel) {
        _chartCavanHeight = self.frame.size.height - 2 * _yLabelHeight;
        _chartCavanWidth = self.frame.size.width;
        //_chartMargin = chartData.inflexionPointWidth;
        _xLabelWidth = (_chartCavanWidth / ([_xLabels count]));
    }
}

- (void)recreatePointLayers {
    for (PNLineChartData *chartData in _chartData) {
        // create as many chart line layers as there are data-lines
        [self.chartLineArray addObject:[NSMutableArray new]];

        // create point
        CAShapeLayer *pointLayer = [CAShapeLayer layer];
        pointLayer.strokeColor = [[chartData.color colorWithAlphaComponent:chartData.alpha] CGColor];
        pointLayer.lineCap = kCALineCapRound;
        pointLayer.lineJoin = kCALineJoinBevel;
        pointLayer.fillColor = nil;
        pointLayer.lineWidth = chartData.lineWidth;
        [self.layer addSublayer:pointLayer];
        [self.chartPointArray addObject:pointLayer];
    }
}

- (void)prepareYLabelsWithData:(NSArray *)data {
    CGFloat yMax = 0.0f;
    CGFloat yMin = MAXFLOAT;
    NSMutableArray *yLabelsArray = [NSMutableArray new];

    for (PNLineChartData *chartData in data) {
        // create as many chart line layers as there are data-lines

        for (NSUInteger i = 0; i < chartData.itemCount; i++) {
            CGFloat yValue = chartData.getData(i).y;
            [yLabelsArray addObject:[NSString stringWithFormat:@"%2f", yValue]];
            yMax = fmaxf(yMax, yValue);
            yMin = fminf(yMin, yValue);
        }
    }


    if (_yValueMin == -FLT_MAX) {
        _yValueMin = (_yFixedValueMin > -FLT_MAX) ? _yFixedValueMin : yMin;
    }
    if (_yValueMax == -FLT_MAX) {
        _yValueMax = (CGFloat) ((_yFixedValueMax > -FLT_MAX) ? _yFixedValueMax : yMax + yMax / 10.0);
    }

    if (_showGenYLabels) {
        [self setYLabels];
    }

}

#pragma mark - Update Chart Data

- (void)updateChartData:(NSArray *)data {
    _chartData = data;

    [self prepareYLabelsWithData:data];

    [self calculateChartPath:_chartPath
               andPointsPath:_pointPath
            andPathKeyPoints:_pathPoints
       andPathStartEndPoints:_endPointsOfPath
  andProgressLinePathsColors:_progressLinePathsColors];

    for (NSUInteger lineIndex = 0; lineIndex < self.chartData.count; lineIndex++) {

        CAShapeLayer *chartLine = (CAShapeLayer *) self.chartLineArray[lineIndex];
        CAShapeLayer *pointLayer = (CAShapeLayer *) self.chartPointArray[lineIndex];


        NSArray<UIBezierPath *> *progressLines = _chartPath[lineIndex];
        UIBezierPath *pointPath = _pointPath[lineIndex];

        for(UIBezierPath *progressLine in progressLines) {
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
            pathAnimation.fromValue = (id) chartLine.path;
            pathAnimation.toValue = (__bridge id) [progressLine CGPath];
            pathAnimation.duration = 0.5f;
            pathAnimation.autoreverses = NO;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [chartLine addAnimation:pathAnimation forKey:@"animationKey"];
            chartLine.path = progressLine.CGPath;
        }

        CABasicAnimation *pointPathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pointPathAnimation.fromValue = (id) pointLayer.path;
        pointPathAnimation.toValue = (__bridge id) [pointPath CGPath];
        pointPathAnimation.duration = 0.5f;
        pointPathAnimation.autoreverses = NO;
        pointPathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [pointLayer addAnimation:pointPathAnimation forKey:@"animationKey"];

        pointLayer.path = pointPath.CGPath;


    }

}

#define IOS7_OR_LATER [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

- (void)drawRect:(CGRect)rect {
    if (self.isShowCoordinateAxis) {
        CGFloat yAxisOffset = 10.f;

        CGContextRef ctx = UIGraphicsGetCurrentContext();
        UIGraphicsPopContext();
        UIGraphicsPushContext(ctx);
        CGContextSetLineWidth(ctx, self.axisWidth);
        CGContextSetStrokeColorWithColor(ctx, [self.axisColor CGColor]);

        CGFloat xAxisWidth = CGRectGetWidth(rect) - (_chartMarginLeft + _chartMarginRight) / 2;
        CGFloat yAxisHeight = _chartMarginBottom + _chartCavanHeight;

        // draw coordinate axis
        CGContextMoveToPoint(ctx, _chartMarginBottom + yAxisOffset, 0);
        CGContextAddLineToPoint(ctx, _chartMarginBottom + yAxisOffset, yAxisHeight);
        CGContextAddLineToPoint(ctx, xAxisWidth, yAxisHeight);
        CGContextStrokePath(ctx);

        // draw y axis arrow
        CGContextMoveToPoint(ctx, _chartMarginBottom + yAxisOffset - 3, 6);
        CGContextAddLineToPoint(ctx, _chartMarginBottom + yAxisOffset, 0);
        CGContextAddLineToPoint(ctx, _chartMarginBottom + yAxisOffset + 3, 6);
        CGContextStrokePath(ctx);

        // draw x axis arrow
        CGContextMoveToPoint(ctx, xAxisWidth - 6, yAxisHeight - 3);
        CGContextAddLineToPoint(ctx, xAxisWidth, yAxisHeight);
        CGContextAddLineToPoint(ctx, xAxisWidth - 6, yAxisHeight + 3);
        CGContextStrokePath(ctx);

        if (self.showLabel) {

            // draw x axis separator
            CGPoint point;
            for (NSUInteger i = 0; i < [self.xLabels count]; i++) {
                point = CGPointMake(2 * _chartMarginLeft + (i * _xLabelWidth), _chartMarginBottom + _chartCavanHeight);
                CGContextMoveToPoint(ctx, point.x, point.y - 2);
                CGContextAddLineToPoint(ctx, point.x, point.y);
                CGContextStrokePath(ctx);
            }

            // draw y axis separator
            CGFloat yStepHeight = _chartCavanHeight / _yLabelNum;
            for (NSUInteger i = 0; i < [self.xLabels count]; i++) {
                point = CGPointMake(_chartMarginBottom + yAxisOffset, (_chartCavanHeight - i * yStepHeight + _yLabelHeight / 2));
                CGContextMoveToPoint(ctx, point.x, point.y);
                CGContextAddLineToPoint(ctx, point.x + 2, point.y);
                CGContextStrokePath(ctx);
            }
        }

        UIFont *font = [UIFont systemFontOfSize:11];

        // draw y unit
        if ([self.yUnit length]) {
            CGFloat height = [PNLineChart sizeOfString:self.yUnit withWidth:30.f font:font].height;
            CGRect drawRect = CGRectMake(_chartMarginLeft + 10 + 5, 0, 30.f, height);
            [self drawTextInContext:ctx text:self.yUnit inRect:drawRect font:font color:self.yLabelColor];
        }

        // draw x unit
        if ([self.xUnit length]) {
            CGFloat height = [PNLineChart sizeOfString:self.xUnit withWidth:30.f font:font].height;
            CGRect drawRect = CGRectMake(CGRectGetWidth(rect) - _chartMarginLeft + 5, _chartMarginBottom + _chartCavanHeight - height / 2, 25.f, height);
            [self drawTextInContext:ctx text:self.xUnit inRect:drawRect font:font color:self.xLabelColor];
        }
    }
    if (self.showYGridLines) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGFloat yAxisOffset = _showLabel ? 10.f : 0.0f;
        CGPoint point;
        CGFloat yStepHeight = _chartCavanHeight / _yLabelNum;
        if (self.yGridLinesColor) {
            CGContextSetStrokeColorWithColor(ctx, self.yGridLinesColor.CGColor);
        } else {
            CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
        }
        for (NSUInteger i = 0; i < _yLabelNum; i++) {
            point = CGPointMake(_chartMarginLeft + yAxisOffset, (_chartCavanHeight - i * yStepHeight + _yLabelHeight / 2));
            CGContextMoveToPoint(ctx, point.x, point.y);
            // add dotted style grid
            CGFloat dash[] = {6, 5};
            // dot diameter is 20 points
            CGContextSetLineWidth(ctx, 0.5);
            CGContextSetLineCap(ctx, kCGLineCapRound);
            CGContextSetLineDash(ctx, 0.0, dash, 2);
            CGContextAddLineToPoint(ctx, CGRectGetWidth(rect) - _chartMarginLeft + 5, point.y);
            CGContextStrokePath(ctx);
        }
    }

    [super drawRect:rect];
}

#pragma mark private methods

/*
 * helper function that maps a y value ( from chartData) to
 * a position in the chart ( between _yValueMin and _yValueMax)
 */
- (CGFloat)yValuePositionInLineChart:(CGFloat)y {
    CGFloat innerGrade;
    if (!(_yValueMax - _yValueMin)) {
        innerGrade = 0.5;
    } else {
        innerGrade = ((CGFloat) y - _yValueMin) / (_yValueMax - _yValueMin);
    }
    return _chartCavanHeight - (innerGrade * _chartCavanHeight) - (_yLabelHeight / 2) + _chartMarginTop;
}

/**
 * return array of segments which represents the color and path
 * for each segments.
 * for instance if p1.y=1 and p2.y=10
 * and rangeColor = use blue for 2<y<3 and red for 4<y<6
 * then this function divides the space between p1 and p2 into three segments
 *  segment #1 : 1-2 : default color
 *  segment #2 : 2-3 : blue
 *  segment #3 : 3-4 : default color
 *  segment #4 : 4-6 : red
 *  segment #5: 6-10 : default color
 *
 *  keep in mind that the rangeColors values are based on the chartData so it needs to
 *  convert those values to coordinates which are valid between yValueMin and yValueMax
 *
 *  in order to find whether there is an overlap between any of the rangeColors and the
 *  p1-p2 it uses NSIntersectionRange to intersect their yValues.
 *
 * @param p1
 * @param p2
 * @param rangeColors
 * @param defaultColor
 * @return
 */
- (NSArray *)colorRangesBetweenP1:(CGPoint)p1 P2:(CGPoint)p2
                      rangeColors:(NSArray<PNLineChartColorRange *> *)rangeColors
                     defaultColor:(UIColor *)defaultColor {
    PNLineChartColorRange* bestMatchColorForRangeInfo = nil;
    if (rangeColors && rangeColors.count > 0 && p2.x > p1.x) {
        for (PNLineChartColorRange* aColorForRangeInfo in rangeColors) {
//            NSArray *remainingRanges = nil;
            // tRange : convert the rangeColors.range values to value between yValueMin and yValueMax
            CGFloat transformedStart = [self yValuePositionInLineChart:(CGFloat)
                                        aColorForRangeInfo.range.location];
            CGFloat transformedEnd = [self yValuePositionInLineChart:(CGFloat)
                                      (aColorForRangeInfo.range.location + aColorForRangeInfo.range.length)];
            
            NSRange pathRange = NSMakeRange((NSUInteger) fmin(p1.y, p2.y), (NSUInteger) fabs(p2.y - p1.y));
            NSRange tRange = NSMakeRange((NSUInteger) fmin(transformedStart, transformedEnd),
                                         (NSUInteger) fabs(transformedEnd - transformedStart));
            if (NSIntersectionRange(tRange, pathRange).length > 0) {
                bestMatchColorForRangeInfo = aColorForRangeInfo;
                CGPoint partition1EndPoint;
                CGPoint partition2EndPoint;
                NSArray *partition1 = @[];
                NSDictionary *partition2 = nil;
                NSArray *partition3 = @[];
                if (p2.y >= p1.y) {
                    partition1EndPoint = CGPointMake([PNLineChart xOfY:(CGFloat) fmax(p1.y, tRange.location)
                                                         betweenPoint1:p1
                                                             andPoint2:p2], (CGFloat) fmax(p1.y, tRange.location));
                    partition2EndPoint = CGPointMake([PNLineChart xOfY:(CGFloat) fmin(p2.y, tRange.location + tRange.length)
                                                         betweenPoint1:p1
                                                             andPoint2:p2], (CGFloat) fmin(p2.y, tRange.location + tRange.length));
                } else {
                    partition1EndPoint = CGPointMake([PNLineChart xOfY:(CGFloat) fmin(p1.y, tRange.location + tRange.length)
                                                         betweenPoint1:p1
                                                             andPoint2:p2], (CGFloat) fmin(p1.y, tRange.location + tRange.length));
                    partition2EndPoint = CGPointMake([PNLineChart xOfY:(CGFloat) fmax(p2.y, tRange.location)
                                                         betweenPoint1:p1
                                                             andPoint2:p2], (CGFloat) fmax(p2.y, tRange.location));
                }
                if (p1.y != partition1EndPoint.y) {
                    partition1 = [self colorRangesBetweenP1:p1
                                                         P2:partition1EndPoint
                                                rangeColors:rangeColors
                                               defaultColor:defaultColor];
                }
                partition2 = @{
                               @"color": aColorForRangeInfo.color,
                               @"from": [NSValue valueWithCGPoint:partition1EndPoint],
                               @"to": [NSValue valueWithCGPoint:partition2EndPoint]};
                if (p2.y != partition2EndPoint.y) {
                    partition3 = [self colorRangesBetweenP1:partition2EndPoint
                                                         P2:p2
                                                rangeColors:rangeColors
                                               defaultColor:defaultColor];
                }
                return [[partition1 arrayByAddingObject:partition2] arrayByAddingObjectsFromArray:partition3];
            }
        }
    }

    return @[@{
                 @"color": defaultColor,
                 @"from": [NSValue valueWithCGPoint:p1],
                 @"to": [NSValue valueWithCGPoint:p2]}];

}


- (void)setupDefaultValues {
    [super setupDefaultValues];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    self.chartLineArray = [NSMutableArray new];
    _showLabel = YES;
    _showGenYLabels = YES;
    _pathPoints = [[NSMutableArray alloc] init];
    _endPointsOfPath = [[NSMutableArray alloc] init];
    self.userInteractionEnabled = YES;

    _yFixedValueMin = -FLT_MAX;
    _yFixedValueMax = -FLT_MAX;
    _yValueMax = -FLT_MAX;
    _yValueMin = -FLT_MAX;
    _yLabelNum = 5;
    _yLabelHeight = [[[[PNChartLabel alloc] init] font] pointSize];

//    _chartMargin = 40;

    _chartMarginLeft = 25.0;
    _chartMarginRight = 25.0;
    _chartMarginTop = 25.0;
    _chartMarginBottom = 25.0;

    _yLabelFormat = @"%1.f";

    _chartCavanWidth = self.frame.size.width - _chartMarginLeft - _chartMarginRight;
    _chartCavanHeight = self.frame.size.height - _chartMarginBottom - _chartMarginTop;

    // Coordinate Axis Default Values
    _showCoordinateAxis = NO;
    _axisColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.f];
    _axisWidth = 1.f;

    // do not create curved line chart by default
    _showSmoothLines = NO;

}

#pragma mark - tools

+ (CGSize)sizeOfString:(NSString *)text withWidth:(float)width font:(UIFont *)font {
    CGSize size = CGSizeMake(width, MAXFLOAT);

    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *tdic = @{NSFontAttributeName: font};
        size = [text boundingRectWithSize:size
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:tdic
                                  context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
    }

    return size;
}

+ (CGPoint)midPointBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2 {
    return CGPointMake((point1.x + point2.x) / 2, (point1.y + point2.y) / 2);
}

+ (CGFloat)xOfY:(CGFloat)y betweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2 {
    CGFloat m = (point2.y - point1.y) / (point2.x - point1.x);
    // formulate = y - y1 = m (x - x1) = mx - mx1 -> mx = y - y1 + mx1 ->
    // x = (y - y1 + mx1) / m
    return (y - point1.y + m * point1.x) / m;
}


+ (CGPoint)controlPointBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2 {
    CGPoint controlPoint = [self midPointBetweenPoint1:point1 andPoint2:point2];
    CGFloat diffY = abs((int) (point2.y - controlPoint.y));
    if (point1.y < point2.y)
        controlPoint.y += diffY;
    else if (point1.y > point2.y)
        controlPoint.y -= diffY;
    return controlPoint;
}

- (void)drawTextInContext:(CGContextRef)ctx text:(NSString *)text inRect:(CGRect)rect font:(UIFont *)font color:(UIColor *)color {
    if (IOS7_OR_LATER) {
        NSMutableParagraphStyle *priceParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        priceParagraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        priceParagraphStyle.alignment = NSTextAlignmentLeft;

        if (color != nil) {
            [text drawInRect:rect
              withAttributes:@{NSParagraphStyleAttributeName: priceParagraphStyle, NSFontAttributeName: font,
                      NSForegroundColorAttributeName: color}];
        } else {
            [text drawInRect:rect
              withAttributes:@{NSParagraphStyleAttributeName: priceParagraphStyle, NSFontAttributeName: font}];
        }
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

- (NSString *)formatYLabel:(double)value {

    if (self.yLabelBlockFormatter) {
        return self.yLabelBlockFormatter((CGFloat) value);
    } else {
        if (!self.thousandsSeparator) {
            NSString *format = self.yLabelFormat ?: @"%1.f";
            return [NSString stringWithFormat:format, value];
        }

        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        return [numberFormatter stringFromNumber:@(value)];
    }
}

- (UIView *)getLegendWithMaxWidth:(CGFloat)mWidth {
    if ([self.chartData count] < 1) {
        return nil;
    }

    /* This is a short line that refers to the chart data */
    CGFloat legendLineWidth = 40;

    /* x and y are the coordinates of the starting point of each legend item */
    CGFloat x = 0;
    CGFloat y = 0;

    /* accumulated height */
    CGFloat totalHeight = 0;
    CGFloat totalWidth = 0;

    NSMutableArray *legendViews = [[NSMutableArray alloc] init];

    /* Determine the max width of each legend item */
    CGFloat maxLabelWidth;
    if (self.legendStyle == PNLegendItemStyleStacked) {
        maxLabelWidth = mWidth - legendLineWidth;
    } else {
        maxLabelWidth = MAXFLOAT;
    }

    /* this is used when labels wrap text and the line
     * should be in the middle of the first row */
    CGFloat singleRowHeight = [PNLineChart sizeOfString:@"Test"
                                              withWidth:MAXFLOAT
                                                   font:self.legendFont ? self.legendFont : [UIFont systemFontOfSize:12.0f]].height;

    NSUInteger counter = 0;
    NSUInteger rowWidth = 0;
    NSUInteger rowMaxHeight = 0;

    for (PNLineChartData *pdata in self.chartData) {
        /* Expected label size*/
        CGSize labelsize = [PNLineChart sizeOfString:pdata.dataTitle
                                           withWidth:maxLabelWidth
                                                font:self.legendFont ? self.legendFont : [UIFont systemFontOfSize:12.0f]];

        /* draw lines */
        if ((rowWidth + labelsize.width + legendLineWidth > mWidth) && (self.legendStyle == PNLegendItemStyleSerial)) {
            rowWidth = 0;
            x = 0;
            y += rowMaxHeight;
            rowMaxHeight = 0;
        }
        rowWidth += labelsize.width + legendLineWidth;
        totalWidth = self.legendStyle == PNLegendItemStyleSerial ? fmaxf(rowWidth, totalWidth) : fmaxf(totalWidth, labelsize.width + legendLineWidth);

        /* If there is inflection decorator, the line is composed of two lines
         * and this is the space that separates two lines in order to put inflection
         * decorator */

        CGFloat inflexionWidthSpacer = pdata.inflexionPointStyle == PNLineChartPointStyleTriangle ? pdata.inflexionPointWidth / 2 : pdata.inflexionPointWidth;

        CGFloat halfLineLength;

        if (pdata.inflexionPointStyle != PNLineChartPointStyleNone) {
            halfLineLength = (CGFloat) ((legendLineWidth * 0.8 - inflexionWidthSpacer) / 2);
        } else {
            halfLineLength = (CGFloat) (legendLineWidth * 0.8);
        }

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake((CGFloat) (x + legendLineWidth * 0.1), y + (singleRowHeight - pdata.lineWidth) / 2, halfLineLength, pdata.lineWidth)];

        line.backgroundColor = pdata.color;
        line.alpha = pdata.alpha;
        [legendViews addObject:line];

        if (pdata.inflexionPointStyle != PNLineChartPointStyleNone) {
            line = [[UIView alloc] initWithFrame:CGRectMake((CGFloat) (x + legendLineWidth * 0.1 + halfLineLength + inflexionWidthSpacer), y + (singleRowHeight - pdata.lineWidth) / 2, halfLineLength, pdata.lineWidth)];
            line.backgroundColor = pdata.color;
            line.alpha = pdata.alpha;
            [legendViews addObject:line];
        }

        // Add inflexion type
        UIColor *inflexionPointColor = pdata.inflexionPointColor;
        if (!inflexionPointColor) {
            inflexionPointColor = pdata.color;
        }
        [legendViews addObject:[self drawInflexion:pdata.inflexionPointWidth
                                            center:CGPointMake(x + legendLineWidth / 2, y + singleRowHeight / 2)
                                       strokeWidth:pdata.lineWidth
                                    inflexionStyle:pdata.inflexionPointStyle
                                          andColor:inflexionPointColor
                                          andAlpha:pdata.alpha]];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x + legendLineWidth, y, labelsize.width, labelsize.height)];
        label.text = pdata.dataTitle;
        label.textColor = self.legendFontColor ? self.legendFontColor : [UIColor blackColor];
        label.font = self.legendFont ? self.legendFont : [UIFont systemFontOfSize:12.0f];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;

        rowMaxHeight = (NSUInteger) fmaxf(rowMaxHeight, labelsize.height);
        x += self.legendStyle == PNLegendItemStyleStacked ? 0 : labelsize.width + legendLineWidth;
        y += self.legendStyle == PNLegendItemStyleStacked ? labelsize.height : 0;


        totalHeight = self.legendStyle == PNLegendItemStyleSerial ? fmaxf(totalHeight, rowMaxHeight + y) : totalHeight + labelsize.height;

        [legendViews addObject:label];
        counter++;
    }

    UIView *legend = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mWidth, totalHeight)];

    for (UIView *v in legendViews) {
        [legend addSubview:v];
    }
    return legend;
}


- (UIImageView *)drawInflexion:(CGFloat)size center:(CGPoint)center strokeWidth:(CGFloat)sw inflexionStyle:(PNLineChartPointStyle)type andColor:(UIColor *)color andAlpha:(CGFloat)alfa {
    //Make the size a little bigger so it includes also border stroke
    CGSize aSize = CGSizeMake(size + sw, size + sw);


    UIGraphicsBeginImageContextWithOptions(aSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();


    if (type == PNLineChartPointStyleCircle) {
        CGContextAddArc(context, (size + sw) / 2, (size + sw) / 2, size / 2, 0, (CGFloat) (M_PI * 2), YES);
    } else if (type == PNLineChartPointStyleSquare) {
        CGContextAddRect(context, CGRectMake(sw / 2, sw / 2, size, size));
    } else if (type == PNLineChartPointStyleTriangle) {
        CGContextMoveToPoint(context, sw / 2, size + sw / 2);
        CGContextAddLineToPoint(context, size + sw / 2, size + sw / 2);
        CGContextAddLineToPoint(context, size / 2 + sw / 2, sw / 2);
        CGContextAddLineToPoint(context, sw / 2, size + sw / 2);
        CGContextClosePath(context);
    }

    //Set some stroke properties
    CGContextSetLineWidth(context, sw);
    CGContextSetAlpha(context, alfa);
    CGContextSetStrokeColorWithColor(context, color.CGColor);

    //Finally draw
    CGContextDrawPath(context, kCGPathStroke);

    //now get the image from the context
    UIImage *squareImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    //// Translate origin
    CGFloat originX = (CGFloat) (center.x - (size + sw) / 2.0);
    CGFloat originY = (CGFloat) (center.y - (size + sw) / 2.0);

    UIImageView *squareImageView = [[UIImageView alloc] initWithImage:squareImage];
    [squareImageView setFrame:CGRectMake(originX, originY, size + sw, size + sw)];
    return squareImageView;
}

#pragma mark setter and getter

- (CATextLayer *)createPointLabelFor:(CGFloat)grade pointCenter:(CGPoint)pointCenter width:(CGFloat)width withChartData:(PNLineChartData *)chartData {
    CATextLayer *textLayer = [[CATextLayer alloc] init];
    [textLayer setAlignmentMode:kCAAlignmentCenter];
    [textLayer setForegroundColor:[chartData.pointLabelColor CGColor]];
    [textLayer setBackgroundColor:self.backgroundColor.CGColor];
//    [textLayer setBackgroundColor:[self.backgroundColor colorWithAlphaComponent:0.8].CGColor];
//    [textLayer setCornerRadius:(CGFloat) (textLayer.fontSize / 8.0)];

    if (chartData.pointLabelFont != nil) {
        [textLayer setFont:(__bridge CFTypeRef) (chartData.pointLabelFont)];
        textLayer.fontSize = [chartData.pointLabelFont pointSize];
    }

    CGFloat textHeight = (CGFloat) (textLayer.fontSize * 1.1);
    // FIXME: convert the grade to string and use its length instead of hardcoding 8
    CGFloat textWidth = width * 8;
    CGFloat textStartPosY;

    textStartPosY = pointCenter.y - textLayer.fontSize;

    [self.layer addSublayer:textLayer];

    if (chartData.pointLabelFormat != nil) {
        [textLayer setString:[[NSString alloc] initWithFormat:chartData.pointLabelFormat, grade]];
    } else {
        [textLayer setString:[[NSString alloc] initWithFormat:_yLabelFormat, grade]];
    }

    [textLayer setFrame:CGRectMake(0, 0, textWidth, textHeight)];
    [textLayer setPosition:CGPointMake(pointCenter.x, textStartPosY)];
    textLayer.contentsScale = [UIScreen mainScreen].scale;

    return textLayer;
}

- (CABasicAnimation *)fadeAnimation {
    CABasicAnimation *fadeAnimation = nil;
    if (self.displayAnimated) {
        fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeAnimation.fromValue = @0.0F;
        fadeAnimation.toValue = @1.0F;
        fadeAnimation.duration = 2.0;
    }
    return fadeAnimation;
}

- (CABasicAnimation *)pathAnimation {
    if (self.displayAnimated && !_pathAnimation) {
        _pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _pathAnimation.duration = 1.0;
        _pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        _pathAnimation.fromValue = @0.0f;
        _pathAnimation.toValue = @1.0f;
    }
    if(!self.displayAnimated) {
        _pathAnimation = nil;
    }
    return _pathAnimation;
}

@end
