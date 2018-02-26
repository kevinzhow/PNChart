//
// Created by Jörg Polakowski on 14/12/13.
// Copyright (c) 2013 kevinzhow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PNLineChartPointStyle) {
    PNLineChartPointStyleNone = 0,
    PNLineChartPointStyleCircle = 1,
    PNLineChartPointStyleSquare = 3,
    PNLineChartPointStyleTriangle = 4
};

@class PNLineChartDataItem;

typedef PNLineChartDataItem *(^LCLineChartDataGetter)(NSUInteger item);

@interface PNLineChartColorRange : NSObject<NSCopying>

@property(nonatomic) NSRange range;
@property(nonatomic) BOOL inclusive;
@property(nonatomic, retain) UIColor *color;

- (id)initWithRange:(NSRange)range color:(UIColor *)color;
- (id)initWithRange:(NSRange)range color:(UIColor *)color inclusive:(BOOL)isInclusive;

@end

@interface PNLineChartData : NSObject

@property (strong) UIColor *color;
@property (nonatomic) CGFloat alpha;
@property NSUInteger itemCount;
@property (copy) LCLineChartDataGetter getData;
@property (strong, nonatomic) NSString *dataTitle;

@property (nonatomic) BOOL showPointLabel;
@property (nonatomic) UIColor *pointLabelColor;
@property (nonatomic) UIFont *pointLabelFont;
@property (nonatomic) NSString *pointLabelFormat;

@property (nonatomic, assign) PNLineChartPointStyle inflexionPointStyle;
@property (nonatomic) UIColor *inflexionPointColor;

/**
 * if rangeColor is set and the lineChartData values are within any
 * of the given range then use the rangeColor.color otherwise use
 * self.color for the rest of the graph
 */
@property(strong) NSArray<PNLineChartColorRange *> *rangeColors;

/**
 * If PNLineChartPointStyle is circle, this returns the circle's diameter.
 * If PNLineChartPointStyle is square, each point is a square with each side equal in length to this value.
 */
@property (nonatomic, assign) CGFloat inflexionPointWidth;

@property (nonatomic, assign) CGFloat lineWidth;

@end
