//
// Created by Jörg Polakowski on 14/12/13.
// Copyright (c) 2013 kevinzhow. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  not support PNLineChartPointStyleTriangle style recently
 */
typedef NS_ENUM(NSUInteger, PNLineChartPointStyle) {
    
    PNLineChartPointStyleNone = 0,
    PNLineChartPointStyleCycle,
    PNLineChartPointStyleTriangle,
    PNLineChartPointStyleSquare
};

@class PNLineChartDataItem;

typedef PNLineChartDataItem *(^LCLineChartDataGetter)(NSUInteger item);

@interface PNLineChartData : NSObject

@property (strong) UIColor *color;
@property NSUInteger itemCount;
@property (copy) LCLineChartDataGetter getData;

@property (nonatomic, assign) PNLineChartPointStyle inflexionPointStyle;

/**
 *  if PNLineChartPointStyle is cycle, inflexionPointWidth equal cycle's diameter
 *  if PNLineChartPointStyle is square, that means the foundation is square with
 *  inflexionPointWidth long
 */
@property (nonatomic, assign) CGFloat inflexionPointWidth;

@property (nonatomic, assign) CGFloat lineWidth;

@end
