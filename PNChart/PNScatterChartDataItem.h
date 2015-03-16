//
//  PNScatterChartDataItem.h
//  PNChartDemo
//
//  Created by Alireza Arabi on 12/4/14.
//  Copyright (c) 2014 kevinzhow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PNScatterChartDataItem : NSObject

+ (PNScatterChartDataItem *)dataItemWithX:(CGFloat)x AndWithY:(CGFloat)y;

@property (readonly) CGFloat x; // should be within the x range
@property (readonly) CGFloat y; // should be within the y range

@end
