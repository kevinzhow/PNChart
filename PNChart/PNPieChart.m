//
//  PNPieChart.m
//  PNChartDemo
//
//  Created by Hang Zhang on 14-5-5.
//  Copyright (c) 2014年 kevinzhow. All rights reserved.
//

#import "PNPieChart.h"

@interface PNPieChart()

@property (nonatomic, readwrite) NSArray	*items;
@property (nonatomic) CGFloat total;
@property (nonatomic) CGFloat currentTotal;

@property (nonatomic) CGFloat outerCircleRadius;
@property (nonatomic) CGFloat innerCircleRadius;

@property (nonatomic) UIView  *contentView;
@property (nonatomic) CAShapeLayer *pieLayer;
@property (nonatomic) NSMutableArray *descriptionLabels;

- (void)loadDefault;

- (UILabel *)descriptionLabelForItemAtIndex:(NSUInteger)index;
- (PNPieChartDataItem *)dataItemForIndex:(NSUInteger)index;

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
		_outerCircleRadius = CGRectGetWidth(self.bounds)/2;
		_innerCircleRadius  = CGRectGetWidth(self.bounds)/6;
		
		_descriptionTextColor = [UIColor whiteColor];
		_descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
        _descriptionTextShadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _descriptionTextShadowOffset =  CGSizeMake(0, 1);
		_duration = 1.0;
        
		[self loadDefault];
	}
	
	return self;
}


- (void)loadDefault{
	_currentTotal = 0;
	_total       = 0;
	
	[_contentView removeFromSuperview];
	_contentView = [[UIView alloc] initWithFrame:self.bounds];
	[self addSubview:_contentView];
    [_descriptionLabels removeAllObjects];
	_descriptionLabels = [NSMutableArray new];
	
	_pieLayer = [CAShapeLayer layer];
	[_contentView.layer addSublayer:_pieLayer];
}

#pragma mark -

- (void)strokeChart{
	[self loadDefault];
	
	[self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		_total +=((PNPieChartDataItem *)obj).value;
	}];
	
	PNPieChartDataItem *currentItem;
	CGFloat currentValue = 0;
	for (int i = 0; i < _items.count; i++) {
		currentItem = [self dataItemForIndex:i];
		
		
		CGFloat startPercnetage = currentValue/_total;
		CGFloat endPercentage   = (currentValue + currentItem.value)/_total;
		
		CAShapeLayer *currentPieLayer =	[self newCircleLayerWithRadius:_innerCircleRadius + (_outerCircleRadius - _innerCircleRadius)/2
                                                           borderWidth:_outerCircleRadius - _innerCircleRadius
                                                             fillColor:[UIColor clearColor]
                                                           borderColor:currentItem.color
                                                       startPercentage:startPercnetage
                                                         endPercentage:endPercentage];
		[_pieLayer addSublayer:currentPieLayer];
		
		currentValue+=currentItem.value;
		
	}
	
	[self maskChart];
	
	currentValue = 0;
    for (int i = 0; i < _items.count; i++) {
		currentItem = [self dataItemForIndex:i];
		UILabel *descriptionLabel =  [self descriptionLabelForItemAtIndex:i];
		[_contentView addSubview:descriptionLabel];
		currentValue+=currentItem.value;
        [_descriptionLabels addObject:descriptionLabel];
	}
}

- (UILabel *)descriptionLabelForItemAtIndex:(NSUInteger)index{
	PNPieChartDataItem *currentDataItem = [self dataItemForIndex:index];
    CGFloat distance = _innerCircleRadius + (_outerCircleRadius - _innerCircleRadius) / 2;
    CGFloat centerPercentage =(_currentTotal + currentDataItem.value /2 ) / _total;
    CGFloat rad = centerPercentage * 2 * M_PI;
    
	_currentTotal += currentDataItem.value;
	
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    NSString *titleText = currentDataItem.textDescription;
    if(!titleText){
        titleText = [NSString stringWithFormat:@"%.0f%%",currentDataItem.value/ _total * 100];
        descriptionLabel.text = titleText ;
    }
    else {
        NSString* str = [NSString stringWithFormat:@"%.0f%%\n",currentDataItem.value/ _total * 100];
        str = [str stringByAppendingString:titleText];
        descriptionLabel.text = str ;
    }
    
    CGPoint center = CGPointMake(_outerCircleRadius + distance * sin(rad),
                                 _outerCircleRadius - distance * cos(rad));
    
    descriptionLabel.font = _descriptionTextFont;
    CGSize labelSize = [descriptionLabel.text sizeWithAttributes:@{NSFontAttributeName:descriptionLabel.font}];
    descriptionLabel.frame = CGRectMake(
                             descriptionLabel.frame.origin.x, descriptionLabel.frame.origin.y,
                             descriptionLabel.frame.size.width, labelSize.height);
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.textColor = _descriptionTextColor;
    descriptionLabel.shadowColor = _descriptionTextShadowColor;
    descriptionLabel.shadowOffset = _descriptionTextShadowOffset;
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.center = center;
    descriptionLabel.alpha = 0;
    descriptionLabel.backgroundColor = [UIColor clearColor];
	return descriptionLabel;
}

- (PNPieChartDataItem *)dataItemForIndex:(NSUInteger)index{
	return self.items[index];
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
	CAShapeLayer *maskLayer =	[self newCircleLayerWithRadius:_innerCircleRadius + (_outerCircleRadius - _innerCircleRadius)/2
                                                 borderWidth:_outerCircleRadius - _innerCircleRadius
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

- (void)createArcAnimationForLayer:(CAShapeLayer *)layer ForKey:(NSString *)key fromValue:(NSNumber *)from toValue:(NSNumber *)to Delegate:(id)delegate
{
	CABasicAnimation *arcAnimation = [CABasicAnimation animationWithKeyPath:key];
	arcAnimation.fromValue = @0;
	[arcAnimation setToValue:to];
	[arcAnimation setDelegate:delegate];
	[arcAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
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
@end
