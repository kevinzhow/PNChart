//
// Created by Jörg Polakowski on 14/12/13.
// Copyright (c) 2013 kevinzhow. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PNLineChartDataItem;

typedef PNLineChartDataItem *(^LCLineChartDataGetter)(NSUInteger item);


@interface PNLineChartData : NSObject

@property (strong) UIColor *color;
@property NSUInteger itemCount;
@property (copy) LCLineChartDataGetter getData;
@end
