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
    }
    
    return self;
}

-(void)setUpChart{
	if (self.type == PNLineType) {
		_lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		_lineChart.backgroundColor = [UIColor clearColor];
		[self addSubview:_lineChart];
		[_lineChart setYValues:_yValues];
		[_lineChart setXLabels:_xLabels];
		[_lineChart setStrokeColor:_strokeColor];
		[_lineChart strokeChart];

	}else if (self.type == PNBarType)
	{
		_barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		_barChart.backgroundColor = [UIColor clearColor];
		[self addSubview:_barChart];
		[_barChart setYValues:_yValues];
		[_barChart setXLabels:_xLabels];
		[_barChart setStrokeColor:_strokeColor];
		[_barChart strokeChart];

	}
}



-(void)strokeChart
{
	[self setUpChart];
	
}



@end
