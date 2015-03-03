//
//  PNPieChart.m
//  PNChartDemo
//
//  Created by Hang Zhang on 14-5-5.
//  Copyright (c) 2014年 kevinzhow. All rights reserved.
//

#import "PNPieChart.h"
//needed for the expected label size
#import "PNLineChart.h"

@interface PNPieChart()

@property (nonatomic) NSArray *items;
@property (nonatomic) NSArray *endPercentages;

@property (nonatomic) CGFloat outerCircleRadius;
@property (nonatomic) CGFloat innerCircleRadius;

@property (nonatomic) UIView         *contentView;
@property (nonatomic) CAShapeLayer   *pieLayer;
@property (nonatomic) NSMutableArray *descriptionLabels;


- (void)loadDefault;

- (UILabel *)descriptionLabelForItemAtIndex:(NSUInteger)index;
- (PNPieChartDataItem *)dataItemForIndex:(NSUInteger)index;
- (CGFloat)startPercentageForItemAtIndex:(NSUInteger)index;
- (CGFloat)endPercentageForItemAtIndex:(NSUInteger)index;
- (CGFloat)ratioForItemAtIndex:(NSUInteger)index;

- (CAShapeLayer *)newCircleLayerWithRadius:(CGFloat)radius
                               borderWidth:(CGFloat)borderWidth
                                 fillColor:(UIColor *)fillColor
                               borderColor:(UIColor *)borderColor
                           startPercentage:(CGFloat)startPercentage
                             endPercentage:(CGFloat)endPercentage;


@end


@implementation PNPieChart

-(id)initWithFrame:(CGRect)frame items:(NSArray *)items{
    self = [self initWithFrame:frame];
    if(self){
        _items = [NSArray arrayWithArray:items];
        _outerCircleRadius  = CGRectGetWidth(self.bounds) / 2;
        _innerCircleRadius  = CGRectGetWidth(self.bounds) / 6;
        
        _descriptionTextColor = [UIColor whiteColor];
        _descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
        _descriptionTextShadowColor  = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _descriptionTextShadowOffset =  CGSizeMake(0, 1);
        _duration = 1.0;
        
        [self loadDefault];
    }
    
    return self;
}

- (void)loadDefault{
    __block CGFloat currentTotal = 0;
    CGFloat total = [[self.items valueForKeyPath:@"@sum.value"] floatValue];
    NSMutableArray *endPercentages = [NSMutableArray new];
    [_items enumerateObjectsUsingBlock:^(PNPieChartDataItem *item, NSUInteger idx, BOOL *stop) {
        if (total == 0){
            [endPercentages addObject:@(1.0 / _items.count * (idx + 1))];
        }else{
            currentTotal += item.value;
            [endPercentages addObject:@(currentTotal / total)];
        }
    }];
    self.endPercentages = [endPercentages copy];
    
    [_contentView removeFromSuperview];
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_contentView];
    _descriptionLabels = [NSMutableArray new];
    
    _pieLayer = [CAShapeLayer layer];
    [_contentView.layer addSublayer:_pieLayer];
}

#pragma mark -

- (void)strokeChart{
    [self loadDefault];
    
    PNPieChartDataItem *currentItem;
    for (int i = 0; i < _items.count; i++) {
        currentItem = [self dataItemForIndex:i];
        
        
        CGFloat startPercnetage = [self startPercentageForItemAtIndex:i];
        CGFloat endPercentage   = [self endPercentageForItemAtIndex:i];
        
        CGFloat radius = _innerCircleRadius + (_outerCircleRadius - _innerCircleRadius) / 2;
        CGFloat borderWidth = _outerCircleRadius - _innerCircleRadius;
        CAShapeLayer *currentPieLayer =	[self newCircleLayerWithRadius:radius
                                                           borderWidth:borderWidth
                                                             fillColor:[UIColor clearColor]
                                                           borderColor:currentItem.color
                                                       startPercentage:startPercnetage
                                                         endPercentage:endPercentage];
        [_pieLayer addSublayer:currentPieLayer];
    }
    
    [self maskChart];
    
    for (int i = 0; i < _items.count; i++) {
        UILabel *descriptionLabel =  [self descriptionLabelForItemAtIndex:i];
        [_contentView addSubview:descriptionLabel];
        [_descriptionLabels addObject:descriptionLabel];
    }
}

- (UILabel *)descriptionLabelForItemAtIndex:(NSUInteger)index{
    PNPieChartDataItem *currentDataItem = [self dataItemForIndex:index];
    CGFloat distance = _innerCircleRadius + (_outerCircleRadius - _innerCircleRadius) / 2;
    CGFloat centerPercentage = ([self startPercentageForItemAtIndex:index] + [self endPercentageForItemAtIndex:index])/ 2;
    CGFloat rad = centerPercentage * 2 * M_PI;
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    NSString *titleText = currentDataItem.textDescription;
    NSString *titleValue;
    
    if (self.showAbsoluteValues) {
        titleValue = [NSString stringWithFormat:@"%.0f",currentDataItem.value];
    }else{
        titleValue = [NSString stringWithFormat:@"%.0f%%",[self ratioForItemAtIndex:index] * 100];
    }
    if(!titleText || self.showOnlyValues){
        descriptionLabel.text = titleValue;
    }
    else {
        NSString* str = [titleValue stringByAppendingString:[NSString stringWithFormat:@"\n%@",titleText]];
        descriptionLabel.text = str ;
    }
    
    CGPoint center = CGPointMake(_outerCircleRadius + distance * sin(rad),
                                 _outerCircleRadius - distance * cos(rad));
    
    descriptionLabel.font = _descriptionTextFont;
    CGSize labelSize = [descriptionLabel.text sizeWithAttributes:@{NSFontAttributeName:descriptionLabel.font}];
    descriptionLabel.frame = CGRectMake(descriptionLabel.frame.origin.x, descriptionLabel.frame.origin.y,
                                        descriptionLabel.frame.size.width, labelSize.height);
    descriptionLabel.numberOfLines   = 0;
    descriptionLabel.textColor       = _descriptionTextColor;
    descriptionLabel.shadowColor     = _descriptionTextShadowColor;
    descriptionLabel.shadowOffset    = _descriptionTextShadowOffset;
    descriptionLabel.textAlignment   = NSTextAlignmentCenter;
    descriptionLabel.center          = center;
    descriptionLabel.alpha           = 0;
    descriptionLabel.backgroundColor = [UIColor clearColor];
    return descriptionLabel;
}

- (PNPieChartDataItem *)dataItemForIndex:(NSUInteger)index{
    return self.items[index];
}

- (CGFloat)startPercentageForItemAtIndex:(NSUInteger)index{
    if(index == 0){
        return 0;
    }
    
    return [_endPercentages[index - 1] floatValue];
}

- (CGFloat)endPercentageForItemAtIndex:(NSUInteger)index{
    return [_endPercentages[index] floatValue];
}

- (CGFloat)ratioForItemAtIndex:(NSUInteger)index{
    return [self endPercentageForItemAtIndex:index] - [self startPercentageForItemAtIndex:index];
}

#pragma mark private methods

- (CAShapeLayer *)newCircleLayerWithRadius:(CGFloat)radius
                               borderWidth:(CGFloat)borderWidth
                                 fillColor:(UIColor *)fillColor
                               borderColor:(UIColor *)borderColor
                           startPercentage:(CGFloat)startPercentage
                             endPercentage:(CGFloat)endPercentage{
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:-M_PI_2
                                                      endAngle:M_PI_2 * 3
                                                     clockwise:YES];
    
    circle.fillColor   = fillColor.CGColor;
    circle.strokeColor = borderColor.CGColor;
    circle.strokeStart = startPercentage;
    circle.strokeEnd   = endPercentage;
    circle.lineWidth   = borderWidth;
    circle.path        = path.CGPath;
    
    return circle;
}

- (void)maskChart{
    CGFloat radius = _innerCircleRadius + (_outerCircleRadius - _innerCircleRadius) / 2;
    CGFloat borderWidth = _outerCircleRadius - _innerCircleRadius;
    CAShapeLayer *maskLayer = [self newCircleLayerWithRadius:radius
                                                 borderWidth:borderWidth
                                                   fillColor:[UIColor clearColor]
                                                 borderColor:[UIColor blackColor]
                                             startPercentage:0
                                               endPercentage:1];
    
    _pieLayer.mask = maskLayer;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration  = _duration;
    animation.fromValue = @0;
    animation.toValue   = @1;
    animation.delegate  = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    [maskLayer addAnimation:animation forKey:@"circleAnimation"];
}

- (void)createArcAnimationForLayer:(CAShapeLayer *)layer
                            forKey:(NSString *)key
                         fromValue:(NSNumber *)from
                           toValue:(NSNumber *)to
                          delegate:(id)delegate{
    CABasicAnimation *arcAnimation = [CABasicAnimation animationWithKeyPath:key];
    arcAnimation.fromValue         = @0;
    arcAnimation.toValue           = to;
    arcAnimation.delegate          = delegate;
    arcAnimation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [layer addAnimation:arcAnimation forKey:key];
    [layer setValue:to forKey:key];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [_descriptionLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [UIView animateWithDuration:0.2 animations:^(){
            [obj setAlpha:1];
        }];
    }];
}

- (UIView*) getLegendWithMaxWidth:(CGFloat)mWidth{
    if ([self.items count] < 1) {
        return nil;
    }
    
    /* This is a small circle that refers to the chart data */
    CGFloat legendCircle = 10;
    
    /* x and y are the coordinates of the starting point of each legend item */
    CGFloat x = 0;
    CGFloat y = 0;
    
    /* accumulated width and height */
    CGFloat totalWidth = 0;
    CGFloat totalHeight = 0;
    
    NSMutableArray *legendViews = [[NSMutableArray alloc] init];
    
    
    /* Determine the max width of each legend item */
    CGFloat maxLabelWidth = self.legendStyle == PNLegendItemStyleStacked ? (mWidth - legendCircle) : (mWidth / [self.items count] - legendCircle);
    
    /* this is used when labels wrap text and the line
     * should be in the middle of the first row */
    CGFloat singleRowHeight = [PNLineChart sizeOfString:@"Test"
                                              withWidth:MAXFLOAT
                                                   font:[UIFont systemFontOfSize:self.legendFontSize]].height;
    
    for (PNPieChartDataItem *pdata in self.items) {
        /* Expected label size*/
        CGSize labelsize = [PNLineChart sizeOfString:pdata.textDescription
                                           withWidth:maxLabelWidth
                                                font:[UIFont systemFontOfSize:self.legendFontSize]];
        

        // Add inflexion type
        [legendViews addObject:[self drawInflexion:legendCircle * .8
                                            center:CGPointMake(x + legendCircle / 2, y + singleRowHeight / 2)
                                          andColor:pdata.color]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x + legendCircle, y, maxLabelWidth, labelsize.height)];
        label.text = pdata.textDescription;
        label.font = [UIFont systemFontOfSize:self.legendFontSize];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        x += self.legendStyle == PNLegendItemStyleStacked ? 0 : labelsize.width + legendCircle;
        y += self.legendStyle == PNLegendItemStyleStacked ? labelsize.height : 0;
        
        totalWidth = self.legendStyle == PNLegendItemStyleStacked ? fmaxf(totalWidth, labelsize.width + legendCircle) : totalWidth + labelsize.width + legendCircle;
        totalHeight = self.legendStyle == PNLegendItemStyleStacked ? fmaxf(totalHeight, labelsize.height) : totalHeight + labelsize.height;
        [legendViews addObject:label];
    }
    
    UIView *legend = [[UIView alloc] initWithFrame:CGRectMake(0, 0, totalWidth, totalHeight)];
    
    for (UIView* v in legendViews) {
        [legend addSubview:v];
    }
    return legend;
}


- (UIImageView*)drawInflexion:(CGFloat)size center:(CGPoint)center andColor:(UIColor*)color
{
    //Make the size a little bigger so it includes also border stroke
    CGSize aSize = CGSizeMake(size, size);
    
    
    UIGraphicsBeginImageContextWithOptions(aSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddArc(context, size/2, size/ 2, size/2, 0, M_PI*2, YES);

    
    //Set some fill color
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    //Finally draw
    CGContextDrawPath(context, kCGPathFill);
    
    //now get the image from the context
    UIImage *squareImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //// Translate origin
    CGFloat originX = center.x - (size) / 2.0;
    CGFloat originY = center.y - (size) / 2.0;
    
    UIImageView *squareImageView = [[UIImageView alloc]initWithImage:squareImage];
    [squareImageView setFrame:CGRectMake(originX, originY, size, size)];
    return squareImageView;
}
@end
