//
//  PNRadarChartDataItem.m
//  PNChartDemo
//
//  Created by Lei on 15/7/1.
//  Copyright (c) 2015年 kevinzhow. All rights reserved.
//

#import "PNRadarChartDataItem.h"

@implementation PNRadarChartDataItem

+ (instancetype)dataItemWithValue:(CGFloat)value
                      description:(NSString *)description {
    PNRadarChartDataItem *item = [PNRadarChartDataItem new];
    item.value = value;
    item.textDescription = description;
    return item;
}

- (void)setValue:(CGFloat)value {
    if (value<0) {
        _value = 0;
        NSLog(@"Value value can not be negative");
    }
    _value = value;
}

@end
