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
#import "PNBar.h"

@implementation PNBarChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds   = YES;
        _showLabel           = YES;
        _barBackgroundColor  = PNLightGrey;
    }
    
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
    
    _xLabelWidth = (self.frame.size.width - chartMargin*2)/[_yValues count];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
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
    
    _yValueMax = (int)max;
    
	
}

-(void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    
    if (_showLabel) {
        _xLabelWidth = (self.frame.size.width - chartMargin*2)/[xLabels count];
        for (NSString * labelText in xLabels) {
            NSInteger index = [xLabels indexOfObject:labelText];
            PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake((index *  _xLabelWidth + chartMargin), self.frame.size.height - 30.0, _xLabelWidth, 20.0)];
            [label setTextAlignment:NSTextAlignmentCenter];
            label.text = labelText;
            [self addSubview:label];
        }
    }
    
}

-(void)setStrokeColor:(UIColor *)strokeColor
{
	_strokeColor = strokeColor;
}

-(void)strokeChart
{

    CGFloat chartCavanHeight = self.frame.size.height - chartMargin * 2 - 40.0;
    NSInteger index = 0;
	
    for (NSString * valueString in _yValues) {
        float value = [valueString floatValue];
        
        float grade = (float)value / (float)_yValueMax;
		PNBar * bar;
        if (_showLabel) {
            bar = [[PNBar alloc] initWithFrame:CGRectMake((index *  _xLabelWidth + chartMargin + _xLabelWidth * 0.25), self.frame.size.height - chartCavanHeight - 30.0, _xLabelWidth * 0.5, chartCavanHeight)];
        }else{
            bar = [[PNBar alloc] initWithFrame:CGRectMake((index *  _xLabelWidth + chartMargin + _xLabelWidth * 0.25), self.frame.size.height - chartCavanHeight , _xLabelWidth * 0.6, chartCavanHeight)];
        }
		bar.backgroundColor = _barBackgroundColor;
		bar.barColor = _strokeColor;
		bar.grade = grade;
		[self addSubview:bar];
        
        index += 1;
    }
}

@end
