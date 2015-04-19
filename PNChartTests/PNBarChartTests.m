//
//  PNBarChartTests.m
//  PNChartDemo
//
//  Created by Viktoras Laukevičius on 18/04/15.
//  Copyright (c) 2015 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import <Expecta.h>
#import "PNBarChart.h"
#import "PNBar.h"

@interface PNBarChartTests : XCTestCase

@property (nonatomic, strong) PNBarChart *barChart;

@end

@implementation PNBarChartTests

- (void)setUp
{
    [super setUp];
    CGRect frame = CGRectMake(10, 20, 320, 200);
    self.barChart = [[PNBarChart alloc] initWithFrame:frame];
}

- (void)tearDown
{
    self.barChart = nil;
    [super tearDown];
}

- (void)testXAxisLabels
{
    self.barChart.xLabels = @[@"TOne", @"TTwo", @"TThree", @"TFour"];
    expect(self.barChart.subviews.count).equal(4);
    for (NSUInteger idx = 0; idx < 4; idx++) {
        UILabel *xAxisLabel = self.barChart.subviews[idx];
        expect(xAxisLabel.text).to.equal(self.barChart.xLabels[idx]);
    }
}

- (void)testYAxisLabels
{
    self.barChart.yLabelFormatter = ^(CGFloat value) {
        return [NSString stringWithFormat:@"Value %zi", (NSUInteger)value];
    };
    self.barChart.yValues = @[@1, @10, @5, @4, @7];
    NSArray *expectedResults = @[@10, @8, @6, @5, @3, @1];
    for (NSUInteger idx = 0; idx < 4; idx++) {
        UILabel *yAxisLabel = self.barChart.subviews[idx];
        expect(yAxisLabel.text).to.equal([NSString stringWithFormat:@"Value %@", expectedResults[idx]]);
    }
}

- (void)testLabelsVisibility
{
    self.barChart.showLabel = NO;
    self.barChart.yLabelFormatter = ^(CGFloat value) {
        return [NSString stringWithFormat:@"Value %zi", (NSUInteger)value];
    };
    self.barChart.xLabels = @[@"TOne", @"TTwo", @"TThree", @"TFour"];
    self.barChart.yValues = @[@1, @10, @5, @4, @7];
    expect(self.barChart.subviews.count).to.equal(0);
}

- (void)testChartBars
{
    self.barChart.barBackgroundColor = [UIColor greenColor];
    self.barChart.yLabelFormatter = ^(CGFloat value) {
        return [NSString stringWithFormat:@"Value %zi", (NSUInteger)value];
    };
    self.barChart.yValues = @[@1, @2, @3];
    NSArray *strokeColour = @[[UIColor greenColor], [UIColor redColor], [UIColor purpleColor]];
    self.barChart.strokeColors = strokeColour;
    [self.barChart strokeChart];
    for (NSUInteger idx = 0; idx < self.barChart.bars.count; idx++) {
        PNBar *bar = self.barChart.bars[idx];
        expect(bar.backgroundColor).to.equal([UIColor greenColor]);
        expect(bar.barColor).to.equal(strokeColour[idx]);
    }
}

- (void)testStrokeColor
{
    self.barChart.yLabelFormatter = ^(CGFloat value) {
        return [NSString stringWithFormat:@"Value %zi", (NSUInteger)value];
    };
    self.barChart.yValues = @[@1, @2, @3];
    self.barChart.strokeColor = [UIColor magentaColor];
    self.barChart.strokeColors = @[[UIColor greenColor], [UIColor redColor]];
    [self.barChart strokeChart];
    for (NSUInteger idx = 0; idx < self.barChart.bars.count; idx++) {
        PNBar *bar = self.barChart.bars[idx];
        expect(bar.barColor).equal(self.barChart.strokeColor);
    }
}

- (void)testMaxValue
{
    self.barChart.yLabelFormatter = ^(CGFloat value) {
        return [NSString stringWithFormat:@"Value %zi", (NSUInteger)value];
    };
    self.barChart.yMaxValue = 8;
    self.barChart.yValues = @[@10, @8, @7, @3];
    NSArray *expectedResults = @[@8, @6, @4, @2];
    for (NSUInteger idx = 0; idx < expectedResults.count; idx++) {
        UILabel *yAxisLabel = self.barChart.subviews[idx];
        expect(yAxisLabel.text).to.equal([NSString stringWithFormat:@"Value %@", expectedResults[idx]]);
    }
}

@end
