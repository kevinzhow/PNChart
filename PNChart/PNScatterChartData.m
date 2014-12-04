//
//  PNScatterChartData.m
//  PNChartDemo
//
//  Created by Alireza Arabi on 12/4/14.
//  Copyright (c) 2014 kevinzhow. All rights reserved.
//

#import "PNScatterChartData.h"

@implementation PNScatterChartData

- (id)init
{
    self = [super init];
    if (self) {
        [self setDefaultValues];
    }
    
    return self;
}

- (void)setDefaultValues
{
    _inflexionPointStyle = PNScatterChartPointStyleCircle;
    _fillColor = [UIColor grayColor];
    _strokeColor = [UIColor blackColor];
    _size = 10 ;
}

- (CAShapeLayer*) drawingPoints
{
    if (_inflexionPointStyle == PNScatterChartPointStyleCircle) {
        float radius = _size;
        CAShapeLayer *circle = [CAShapeLayer layer];
        // Make a circular shape
        circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                                 cornerRadius:radius].CGPath;
        // Configure the apperence of the circle
        circle.fillColor = [_fillColor CGColor];
        circle.strokeColor = [_strokeColor CGColor];
        circle.lineWidth = 1;
        
        // Add to parent layer
        return circle;
    }
    else if (_inflexionPointStyle == PNScatterChartPointStyleSquare) {
        float side = _size;
        CAShapeLayer *square = [CAShapeLayer layer];
        // Make a circular shape
        square.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, side, side)].CGPath ;
        // Configure the apperence of the circle
        square.fillColor = [_fillColor CGColor];
        square.strokeColor = [_strokeColor CGColor];
        square.lineWidth = 1;
        
        // Add to parent layer
        return square;
        
    }
    else {
        // you cann add your own scatter chart poin here
    }
    return nil ;

}

@end
