//
//  PNPieChartDataItem.m
//  PNChartDemo
//
//  Created by Hang Zhang on 14-5-5.
//  Copyright (c) 2014年 kevinzhow. All rights reserved.
//

#import "PNPieChartDataItem.h"

@interface PNPieChartDataItem()

@property (nonatomic, readwrite) CGFloat   value;
@property (nonatomic, readwrite) UIColor  *color;
@property (nonatomic, readwrite) NSString *description;

@end

@implementation PNPieChartDataItem


+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color{
	PNPieChartDataItem *item = [PNPieChartDataItem new];
	item.value = value;
	item.color  = color;
	return item;
}

+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color
                       description:(NSString *)description{
	PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:value color:color];
	item.description = description;
	return item;
}

@end
