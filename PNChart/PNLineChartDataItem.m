//
// Created by Jörg Polakowski on 14/12/13.
// Copyright (c) 2013 kevinzhow. All rights reserved.
//

#import "PNLineChartDataItem.h"

@interface PNLineChartDataItem ()

- (id)initWithY:(CGFloat)y;

@property (readwrite) CGFloat y; // should be within the y range

@end

@implementation PNLineChartDataItem

+ (PNLineChartDataItem *)dataItemWithY:(CGFloat)y
{
    return [[PNLineChartDataItem alloc] initWithY:y];
}

- (id)initWithY:(CGFloat)y
{
    if ((self = [super init])) {
        self.y = y;
    }

    return self;
}

@end
