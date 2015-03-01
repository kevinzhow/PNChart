//
//  PNGenericChart.m
//  PNChartDemo
//
//  Created by Andi Palo on 26/02/15.
//  Copyright (c) 2015 kevinzhow. All rights reserved.
//

#import "PNGenericChart.h"

@interface PNGenericChart ()



@end

@implementation PNGenericChart

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView*) drawLegend{
    return nil;
}


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

- (void) setupDefaultValues{
    self.hasLegend = YES;
    self.legendPosition = PNLegendPositionBottom;
    self.legendStyle = PNLegendItemStyleStacked;
}



/**
 *  to be implemented in subclass 
 */
- (UIView*) getLegendWithMaxWidth:(CGFloat)mWidth{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}



@end
