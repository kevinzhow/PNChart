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

@implementation PNLineChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds   = YES;
        _chartLine           = [CAShapeLayer layer];
        _chartLine.lineCap   = kCALineCapRound;
        _chartLine.lineJoin  = kCALineJoinBevel;
        _chartLine.fillColor = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth = 3.0;
        _chartLine.strokeEnd = 0.0;
        _showLabel           = YES;
        _pathPoints = [[NSMutableArray alloc] init];
        self.userInteractionEnabled = YES;
        _xLabelHeight = 20.0;
        _chartCavanHeight = self.frame.size.height - chartMargin * 2 - _xLabelHeight*2 ;
		[self.layer addSublayer:_chartLine];
    }
    
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    
    float max = 0;
    for (NSString * valueString in yValues) {
        float value = [valueString floatValue];
        if (value > max) {
            max = value;
        }
    }
    
    //Min value for Y label
    if (max < 5) {
        max = 5;
    }
    
    _yValueMax = (float)max;
    
    if (_showLabel) {
        [self setYLabels:yValues];
    }
    
}

-(void)setYLabels:(NSArray *)yLabels
{
    
    float level = _yValueMax / 5.0;
	
    NSInteger index = 0;
	NSInteger num = [yLabels count] + 1;
	while (num > 0) {
		CGFloat levelHeight = _chartCavanHeight /5.0;
		PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0,_chartCavanHeight - index * levelHeight + (levelHeight - yLabelHeight) , 20.0, yLabelHeight)];
		[label setTextAlignment:NSTextAlignmentRight];
		label.text = [NSString stringWithFormat:@"%1.f",level * index];
		[self addSubview:label];
        index +=1 ;
		num -= 1;
	}

}

-(void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    
    if(_showLabel){
        _xLabelWidth = (self.frame.size.width - chartMargin - 30.0)/[xLabels count];
        for (NSString * labelText in xLabels) {
            NSInteger index = [xLabels indexOfObject:labelText];
            PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(index * _xLabelWidth + 30.0, self.frame.size.height - 30.0, _xLabelWidth, 20.0)];
            [label setTextAlignment:NSTextAlignmentCenter];
            label.text = labelText;
            [self addSubview:label];
        }
    }else{
        _xLabelWidth = (self.frame.size.width)/[xLabels count];
    }
    
}

-(void)setStrokeColor:(UIColor *)strokeColor
{
	_strokeColor = strokeColor;
	_chartLine.strokeColor = [strokeColor CGColor];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self chechPoint:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self chechPoint:touches withEvent:event];
}

-(void)chechPoint:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    CGPathRef originalPath = _progressline.CGPath;
    CGPathRef strokedPath = CGPathCreateCopyByStrokingPath(originalPath, NULL, 3.0, kCGLineCapRound, kCGLineJoinRound, 3.0);
    BOOL pathContainsPoint = CGPathContainsPoint(strokedPath, NULL, touchPoint, NO);
    if (pathContainsPoint)
    {
        [_delegate userClickedOnLinePoint:touchPoint];
        for (NSValue *val in _pathPoints) {
            CGPoint p = [val CGPointValue];
            if (p.x + 3.0 > touchPoint.x && p.x - 3.0 < touchPoint.x && p.y + 3.0 > touchPoint.y && p.y - 3.0 < touchPoint.y ) {
                [_delegate userClickedOnLineKeyPoint:touchPoint andPointIndex:[_pathPoints indexOfObject:val]];
            }
        }
    }
}

-(void)strokeChart
{
    UIGraphicsBeginImageContext(self.frame.size);
    
    _progressline = [UIBezierPath bezierPath];
    
    CGFloat firstValue = [[_yValues objectAtIndex:0] floatValue];
    
    CGFloat xPosition = _xLabelWidth;
    
    if(!_showLabel){
        _chartCavanHeight = self.frame.size.height  - _xLabelHeight*2;
        xPosition = 0;
    }
    
    float grade = (float)firstValue / (float)_yValueMax;
    

    [_progressline moveToPoint:CGPointMake( xPosition, _chartCavanHeight - grade * _chartCavanHeight + _xLabelHeight)];
    [_pathPoints addObject:[NSValue valueWithCGPoint:CGPointMake( xPosition, _chartCavanHeight - grade * _chartCavanHeight + _xLabelHeight)]];
    [_progressline setLineWidth:3.0];
    [_progressline setLineCapStyle:kCGLineCapRound];
    [_progressline setLineJoinStyle:kCGLineJoinRound];
    NSInteger index = 0;
    for (NSString * valueString in _yValues) {
        float value = [valueString floatValue];
        
        float grade = (float)value / (float)_yValueMax;
        if (index != 0) {
            
            
            CGPoint point = CGPointMake(index * _xLabelWidth  + 30.0 + _xLabelWidth /2.0, _chartCavanHeight - (grade * _chartCavanHeight) + _xLabelHeight);
            [_pathPoints addObject:[NSValue valueWithCGPoint:point]];
            [_progressline addLineToPoint:point];
            [_progressline moveToPoint:point];
        }
        
        index += 1;
    }
    [_progressline stroke];
    
    _chartLine.path = _progressline.CGPath;
	if (_strokeColor) {
		_chartLine.strokeColor = [_strokeColor CGColor];
	}else{
		_chartLine.strokeColor = [PNGreen CGColor];
	}
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    _chartLine.strokeEnd = 1.0;
    
    UIGraphicsEndImageContext();
}



@end
