//
//  PNBarChart.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNBarChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"


@interface PNBarChart () {
    NSMutableArray *_xChartLabels;
    NSMutableArray *_yChartLabels;
}

- (UIColor *)barColorAtIndex:(NSUInteger)index;

@end

@implementation PNBarChart

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
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

- (void)setupDefaultValues
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds   = YES;
    _showLabel           = YES;
    _barBackgroundColor  = PNLightGrey;
    _labelTextColor      = [UIColor grayColor];
    _labelFont           = [UIFont systemFontOfSize:11.0f];
    _xChartLabels        = [NSMutableArray array];
    _yChartLabels        = [NSMutableArray array];
    _bars                = [NSMutableArray array];
    _xLabelSkip          = 1;
    _yLabelSum           = 4;
    _labelMarginTop      = 0;
    _chartMargin         = 15.0;
    _barRadius           = 2.0;
    _showChartBorder     = NO;
    _yChartLabelWidth    = 18;
    _rotateForXAxisText  = false;
}

- (void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;

    //make the _yLabelSum value dependant of the distinct values of yValues to avoid duplicates on yAxis
    int yLabelsDifTotal = (int)[NSSet setWithArray:yValues].count;
    _yLabelSum = yLabelsDifTotal % 2 == 0 ? yLabelsDifTotal : yLabelsDifTotal + 1;

    if (_yMaxValue) {
        _yValueMax = _yMaxValue;
    } else {
        [self getYValueMax:yValues];
    }
    
    if (_yChartLabels) {
        [self viewCleanupForCollection:_yChartLabels];
    }else{
        _yLabels = [NSMutableArray new];
    }
    
    if (_showLabel) {
        //Add y labels
        
        float yLabelSectionHeight = (self.frame.size.height - _chartMargin * 2 - kXLabelHeight) / _yLabelSum;
        
        for (int index = 0; index < _yLabelSum; index++) {
            
            NSString *labelText = _yLabelFormatter((float)_yValueMax * ( (_yLabelSum - index) / (float)_yLabelSum ));
            
            PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0,
                                                                                  yLabelSectionHeight * index + _chartMargin - kYLabelHeight/2.0,
                                                                                  _yChartLabelWidth,
                                                                                  kYLabelHeight)];
            label.font = _labelFont;
            label.textColor = _labelTextColor;
            [label setTextAlignment:NSTextAlignmentRight];
            label.text = labelText;
            
            [_yChartLabels addObject:label];
            [self addSubview:label];
            
        }
    }
}

-(void)updateChartData:(NSArray *)data{
    self.yValues = data;
    [self updateBar];
}

- (void)getYValueMax:(NSArray *)yLabels
{
    int max = [[yLabels valueForKeyPath:@"@max.intValue"] intValue];

    //ensure max is even
    _yValueMax = max % 2 == 0 ? max : max + 1;

    if (_yValueMax == 0) {
        _yValueMax = _yMinValue;
    }
}

- (void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    
    if (_xChartLabels) {
        [self viewCleanupForCollection:_xChartLabels];
    }else{
        _xChartLabels = [NSMutableArray new];
    }
    
    if (_showLabel) {
        _xLabelWidth = (self.frame.size.width - _chartMargin * 2) / [xLabels count];
        int labelAddCount = 0;
        for (int index = 0; index < _xLabels.count; index++) {
            labelAddCount += 1;
            
            if (labelAddCount == _xLabelSkip) {
                NSString *labelText = [_xLabels[index] description];
                PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0, 0, _xLabelWidth, kXLabelHeight)];
                label.font = _labelFont;
                label.textColor = _labelTextColor;
                [label setTextAlignment:NSTextAlignmentCenter];
                label.text = labelText;
                //[label sizeToFit];
                CGFloat labelXPosition;
                if (_rotateForXAxisText){
                    label.transform = CGAffineTransformMakeRotation(M_PI / 4);
                    labelXPosition = (index *  _xLabelWidth + _chartMargin + _xLabelWidth /1.5);
                }
                else{
                    labelXPosition = (index *  _xLabelWidth + _chartMargin + _xLabelWidth /2.0 );
                }
                label.center = CGPointMake(labelXPosition,
                                           self.frame.size.height - kXLabelHeight - _chartMargin + label.frame.size.height /2.0 + _labelMarginTop);
                labelAddCount = 0;
                
                [_xChartLabels addObject:label];
                [self addSubview:label];
            }
        }
    }
}


- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
}

- (void)updateBar
{
    
    //Add bars
    CGFloat chartCavanHeight = self.frame.size.height - _chartMargin * 2 - kXLabelHeight;
    NSInteger index = 0;
    
    for (NSNumber *valueString in _yValues) {
        
        PNBar *bar;
        
        if (_bars.count == _yValues.count) {
            bar = [_bars objectAtIndex:index];
        }else{
            CGFloat barWidth;
            CGFloat barXPosition;
            
            if (_barWidth) {
                barWidth = _barWidth;
                barXPosition = index *  _xLabelWidth + _chartMargin + _xLabelWidth /2.0 - _barWidth /2.0;
            }else{
                barXPosition = index *  _xLabelWidth + _chartMargin + _xLabelWidth * 0.25;
                if (_showLabel) {
                    barWidth = _xLabelWidth * 0.5;
                    
                }
                else {
                    barWidth = _xLabelWidth * 0.6;
                    
                }
            }
            
            bar = [[PNBar alloc] initWithFrame:CGRectMake(barXPosition, //Bar X position
                                                          self.frame.size.height - chartCavanHeight - kXLabelHeight - _chartMargin, //Bar Y position
                                                          barWidth, // Bar witdh
                                                          chartCavanHeight)]; //Bar height
            
            //Change Bar Radius
            bar.barRadius = _barRadius;
            
            //Change Bar Background color
            bar.backgroundColor = _barBackgroundColor;
            
            //Bar StrokColor First
            if (self.strokeColor) {
                bar.barColor = self.strokeColor;
            }else{
                bar.barColor = [self barColorAtIndex:index];
            }
            // Add gradient
            bar.barColorGradientStart = _barColorGradientStart;
            
            //For Click Index
            bar.tag = index;
            
            [_bars addObject:bar];
            [self addSubview:bar];
        }
        
        //Height Of Bar
        float value = [valueString floatValue];
        
        float grade = (float)value / (float)_yValueMax;
        
        if (isnan(grade)) {
            grade = 0;
        }
        bar.grade = grade;
        
        index += 1;
    }
}

- (void)strokeChart
{
    //Add Labels

    [self viewCleanupForCollection:_bars];


    //Update Bar
    
    [self updateBar];
    
    //Add chart border lines

    if (_showChartBorder) {
        _chartBottomLine = [CAShapeLayer layer];
        _chartBottomLine.lineCap      = kCALineCapButt;
        _chartBottomLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartBottomLine.lineWidth    = 1.0;
        _chartBottomLine.strokeEnd    = 0.0;

        UIBezierPath *progressline = [UIBezierPath bezierPath];

        [progressline moveToPoint:CGPointMake(_chartMargin, self.frame.size.height - kXLabelHeight - _chartMargin)];
        [progressline addLineToPoint:CGPointMake(self.frame.size.width - _chartMargin,  self.frame.size.height - kXLabelHeight - _chartMargin)];

        [progressline setLineWidth:1.0];
        [progressline setLineCapStyle:kCGLineCapSquare];
        _chartBottomLine.path = progressline.CGPath;


        _chartBottomLine.strokeColor = PNLightGrey.CGColor;


        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 0.5;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @0.0f;
        pathAnimation.toValue = @1.0f;
        [_chartBottomLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];

        _chartBottomLine.strokeEnd = 1.0;

        [self.layer addSublayer:_chartBottomLine];

        //Add left Chart Line

        _chartLeftLine = [CAShapeLayer layer];
        _chartLeftLine.lineCap      = kCALineCapButt;
        _chartLeftLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartLeftLine.lineWidth    = 1.0;
        _chartLeftLine.strokeEnd    = 0.0;

        UIBezierPath *progressLeftline = [UIBezierPath bezierPath];

        [progressLeftline moveToPoint:CGPointMake(_chartMargin, self.frame.size.height - kXLabelHeight - _chartMargin)];
        [progressLeftline addLineToPoint:CGPointMake(_chartMargin,  _chartMargin)];

        [progressLeftline setLineWidth:1.0];
        [progressLeftline setLineCapStyle:kCGLineCapSquare];
        _chartLeftLine.path = progressLeftline.CGPath;


        _chartLeftLine.strokeColor = PNLightGrey.CGColor;


        CABasicAnimation *pathLeftAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathLeftAnimation.duration = 0.5;
        pathLeftAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathLeftAnimation.fromValue = @0.0f;
        pathLeftAnimation.toValue = @1.0f;
        [_chartLeftLine addAnimation:pathLeftAnimation forKey:@"strokeEndAnimation"];

        _chartLeftLine.strokeEnd = 1.0;

        [self.layer addSublayer:_chartLeftLine];
    }
}


- (void)viewCleanupForCollection:(NSMutableArray *)array
{
    if (array.count) {
        [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [array removeAllObjects];
    }
}


#pragma mark - Class extension methods

- (UIColor *)barColorAtIndex:(NSUInteger)index
{
    if ([self.strokeColors count] == [self.yValues count]) {
        return self.strokeColors[index];
    }
    else {
        return self.strokeColor;
    }
}


#pragma mark - Touch detection

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchPoint:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}


- (void)touchPoint:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    UIView *subview = [self hitTest:touchPoint withEvent:nil];

    if ([subview isKindOfClass:[PNBar class]] && [self.delegate respondsToSelector:@selector(userClickedOnBarAtIndex:)]) {
        [self.delegate userClickedOnBarAtIndex:subview.tag];
    }
}


@end
