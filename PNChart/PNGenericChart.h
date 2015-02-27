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
@property (assign, nonatomic) CGFloat legendFontSize;

- (UIView*) drawLegend;

@end
