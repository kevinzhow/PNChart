//
//  PNGenericChart.h
//  PNChartDemo
//
//  Created by Andi Palo on 26/02/15.
//  Copyright (c) 2015 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PNLegendPosition) {
    PNLegendPositionTop = 0,
    PNLegendPositionBottom = 1,
    PNLegendPositionLeft = 2,
    PNLegendPositionRight = 3
};

typedef NS_ENUM(NSUInteger, PNLegendItemStyle) {
    PNLegendItemStyleStacked = 0,
    PNLegendItemStyleSerial = 1
};

@interface PNGenericChart : UIView

@property (assign, nonatomic) BOOL hasLegend;
@property (assign, nonatomic) PNLegendPosition legendPosition;
@property (assign, nonatomic) PNLegendItemStyle legendStyle;

@property (assign, nonatomic) UIFont *legendFont;
@property (assign, nonatomic) UIColor *legendFontColor;
@property (assign, nonatomic) NSUInteger labelRowsInSerialMode;

/**
 *  returns the Legend View, or nil if no chart data is present.
 *  The origin of the legend frame is 0,0 but you can set it with setFrame:(CGRect)
 *
 *  @param mWidth Maximum width of legend. Height will depend on this and font size
 *
 *  @return UIView of Legend
 */
- (UIView*) getLegendWithMaxWidth:(CGFloat)mWidth;


- (void) setupDefaultValues;
@end
