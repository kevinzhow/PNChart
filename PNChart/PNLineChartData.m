//
// Created by Jörg Polakowski on 14/12/13.
// Copyright (c) 2013 kevinzhow. All rights reserved.
//

#import "PNLineChartData.h"

@implementation PNLineChartData

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
    _inflexionPointStyle = PNLineChartPointStyleNone;
    _inflexionPointWidth = 6.f;
    _lineWidth = 2.f;
}

@end
