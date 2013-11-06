//
//  PNChart.m
//  bigbang-ios
//
//  Created by kevin on 10/3/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNChart.h"
#import "PNChartLabel.h"

@implementation PNChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        _chartLine = [CAShapeLayer layer];
      
        _chartLine.strokeColor = [PNGreen CGColor];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth   = 3.0;
        _chartLine.strokeEnd   = 0.0;
        
        [self.layer addSublayer:_chartLine];
    }
    
    
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    _xLabelWidth = (SCREEN_WIDTH - chartMargin - 30.0 - ([xLabels count] -1) * xLabelMargin)/5.0;
    
    for (NSString * labelText in xLabels) {
        NSInteger index = [xLabels indexOfObject:labelText];
        PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(index * (xLabelMargin + _xLabelWidth) + 30.0, self.frame.size.height - 30.0, _xLabelWidth, 20.0)];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.text = labelText;
        [self addSubview:label];
    }
    
}

-(void)setYLabels:(NSArray *)yLabels
{
    int max = 0;
    for (NSString * valueString in yLabels) {
        NSInteger value = [valueString integerValue];
        if (value > max) {
            max = value;
        }
        
    }
    
    //Min value for Y label
    if (max < 5) {
        max = 5;
    }
    
    _yValueMax = max;
    
    NSLog(@"Y Max is %d", _yValueMax );
    float level = max /5.0;

    NSInteger index = 0;
    
    
    for (NSString * valueString in _yValues) {
       
        CGFloat chartCavanHeight = self.frame.size.height - chartMargin * 2 - 40.0 ;
        CGFloat levelHeight = chartCavanHeight /5.0;
        PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight - index * levelHeight + (levelHeight - yLabelHeight) , 20.0, yLabelHeight)];
        [label setTextAlignment:NSTextAlignmentRight];
        label.text = [NSString stringWithFormat:@"%1.f",level * index];
        [self addSubview:label];
        index +=1 ;
    }
}


-(void)strokeChart
{
    
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    
    CGFloat firstValue = [[_yValues firstObject] floatValue];
    
    CGFloat xPosition = (xLabelMargin + _xLabelWidth)   ;
    
    CGFloat chartCavanHeight = self.frame.size.height - chartMargin * 2 - 40.0;
    
    float grade = (float)firstValue / (float)_yValueMax;
    [progressline moveToPoint:CGPointMake( xPosition, chartCavanHeight - grade * chartCavanHeight + 20.0)];
    [progressline setLineWidth:3.0];
    [progressline setLineCapStyle:kCGLineCapRound];
    [progressline setLineJoinStyle:kCGLineJoinRound];
    NSInteger index = 0;
    for (NSString * valueString in _yValues) {
        NSInteger value = [valueString integerValue];
        
        float grade = (float)value / (float)_yValueMax;
        NSLog(@"index is %d and value is %d ymax is %d grade is %f",index, value, _yValueMax,grade);
        if (index != 0) {
            
            [progressline addLineToPoint:CGPointMake(index * xPosition  + 30.0+ _xLabelWidth /2.0, chartCavanHeight - grade * chartCavanHeight + 20.0)];
            
            [progressline moveToPoint:CGPointMake(index * xPosition + 30.0 + _xLabelWidth /2.0, chartCavanHeight - grade * chartCavanHeight + 20.0 )];
            
            [progressline stroke];
        }
        
        
        NSLog(@"Xvalue is %f Y value is %f",index * xPosition  + 30.0+ _xLabelWidth /2.0,  chartCavanHeight - grade * chartCavanHeight + 20.0 );
        index += 1;
    }
    
    _chartLine.path = progressline.CGPath;
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    _chartLine.strokeEnd = 1.0;
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    // Drawing code
//     [PNGreen set];
//    CGContextSetLineWidth(context, 2.0);
//    CGContextSetLineJoin(context, kCGLineJoinRound);
//    CGContextSetLineCap(context, kCGLineCapRound);
//    CGContextStrokePath(context);
//    
//    [[UIColor colorWithWhite:0.8 alpha:1.0] setFill];
//    
//   
//    UIBezierPath *progressline = [UIBezierPath bezierPath];
//    
//    CGFloat firstValue = [[_yValues firstObject] floatValue];
//    
//    CGFloat xPosition = (xLabelMargin + _xLabelWidth)   ;
//    
//    CGFloat chartCavanHeight = self.frame.size.height - chartMargin * 2 - 40.0;
//    
//    float grade = (float)firstValue / (float)_yValueMax;
//    [progressline moveToPoint:CGPointMake( xPosition, chartCavanHeight - grade * chartCavanHeight + 20.0)];
//    [progressline setLineWidth:3.0];
//    [progressline setLineCapStyle:kCGLineCapRound];
//    [progressline setLineJoinStyle:kCGLineJoinRound];
//    NSInteger index = 0;
//    for (NSString * valueString in _yValues) {
//        NSInteger value = [valueString integerValue];
//        
//        float grade = (float)value / (float)_yValueMax;
//        NSLog(@"index is %d and value is %d ymax is %d grade is %f",index, value, _yValueMax,grade);
//        if (index != 0) {
//            
//            [progressline addLineToPoint:CGPointMake(index * xPosition  + 30.0+ _xLabelWidth /2.0, chartCavanHeight - grade * chartCavanHeight + 20.0)];
//            
//            [progressline moveToPoint:CGPointMake(index * xPosition + 30.0 + _xLabelWidth /2.0, chartCavanHeight - grade * chartCavanHeight + 20.0 )];
//            
//            [progressline stroke];
//        }
//        
//        
//        NSLog(@"Xvalue is %f Y value is %f",index * xPosition  + 30.0+ _xLabelWidth /2.0,  chartCavanHeight - grade * chartCavanHeight + 20.0 );
//        index += 1;
//    }
//    
//    
//    
//    
//}


@end
