//
// Created by Jörg Polakowski on 14/12/13.
// Copyright (c) 2013 kevinzhow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNLineChartDataItem : NSObject

@property (readonly) CGFloat y; // should be within the y range

+ (PNLineChartDataItem *)dataItemWithY:(CGFloat)y;

@end
