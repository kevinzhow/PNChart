//
//  PNCircleChart.h
//  PNChartDemo
//
//  Created by kevinzhow on 13-11-30.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PNCircleChart : UIView

-(void)strokeChart;
- (id)initWithFrame:(CGRect)frame andTotal:(NSNumber *)total andCurrent:(NSNumber *)current;

@property (nonatomic, strong) UIColor * strokeColor;

@property (nonatomic, strong) NSNumber * total;
@property (nonatomic, strong) NSNumber * current;



@end
