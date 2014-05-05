//
//  PNPieChart.h
//  PNChartDemo
//
//  Created by Hang Zhang on 14-5-5.
//  Copyright (c) 2014年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNPieChartDataItem.h"

@interface PNPieChart : UIView

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;

@property (nonatomic, readonly) NSArray	*items;

@property (nonatomic) UIFont  *descriptionTextFont;  //defualt is [UIFont fontWithName:@"Avenir-Medium" size:18.0];
@property (nonatomic) UIColor *descriptionTextColor; //defualt is [UIColor whiteColor]
@property (nonatomic) UIColor *descriptionTextShadowColor; //defualt is [[UIColor blackColor] colorWithAlphaComponent:0.4]
@property (nonatomic) CGSize   descriptionTextShadowOffset; //defualt is CGSizeMake(0, 1)
@property (nonatomic) NSTimeInterval duration;//defualt is 1.0

- (void)strokeChart;

@end
