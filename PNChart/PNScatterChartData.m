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
        [self setupDefaultValues];
    }
    
    return self;
}

- (void)setupDefaultValues
{
    _inflexionPointStyle = PNScatterChartPointStyleCircle;
    _fillColor = [UIColor grayColor];
    _strokeColor = [UIColor clearColor];
    _size = 3 ;
}

@end
