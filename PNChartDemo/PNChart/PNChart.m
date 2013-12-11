//
//  PNChart.m
//  PNChart
//
//  Created by kevin on 10/3/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNChart.h"

@implementation PNChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
        self.type = PNLineType;
        _showLabel = YES;
        self.strokeColor = PNFreshGreen;
    }
    
    return self;
}

-(void)setUpChart{
	if (self.type == PNLineType) {
		_lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		_lineChart.backgroundColor = [UIColor clearColor];
        _lineChart.showLabel = _showLabel;
		[self addSubview:_lineChart];
		[_lineChart setYValues:_yValues];
		[_lineChart setXLabels:_xLabels];
		[_lineChart setStrokeColor:_strokeColor];
		[_lineChart strokeChart];
        _lineChart.delegate = self;


	}else if (self.type == PNBarType)
	{
		_barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		_barChart.backgroundColor = [UIColor clearColor];
        if (_barBackgroundColor) {
            _barChart.barBackgroundColor = _barBackgroundColor;
        }
        _barChart.showLabel = _showLabel;
		[self addSubview:_barChart];
		[_barChart setYValues:_yValues];
		[_barChart setXLabels:_xLabels];
		[_barChart setStrokeColor:_strokeColor];
		[_barChart strokeChart];

	}else if (self.type == PNCircleType)
    {
        _circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) andTotal:self.total andCurrent:self.current];
        _circleChart.backgroundColor = [UIColor clearColor];
        _circleChart.lineWidth = [NSNumber numberWithFloat:8.0];
        [_circleChart setStrokeColor:_strokeColor];
        [_circleChart strokeChart];
        [self addSubview:_circleChart];
    }
}



-(void)strokeChart
{
    if (_lineChart) {
		
		[_lineChart strokeChart];
        [_lineChart setStrokeColor:_strokeColor];
        
	}else if (_barChart)
	{
		
		[_barChart strokeChart];
        [_barChart setStrokeColor:_strokeColor];
        
	}else if (_circleChart)
    {
        [_circleChart strokeChart];
        [_circleChart setStrokeColor:_strokeColor];
    }else{
        [self setUpChart];
    }
	
	
}

-(void)userClickedOnLineKeyPoint:(CGPoint)point andPointIndex:(NSInteger)index{
    [_delegate userClickedOnLineKeyPoint:point andPointIndex:index];
}

-(void)userClickedOnLinePoint:(CGPoint)point {
    [_delegate userClickedOnLinePoint:point];
}

@end
