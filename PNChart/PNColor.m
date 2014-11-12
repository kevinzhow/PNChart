//
//  PNColor.m
//  PNChart
//
//  Created by kevin on 13-6-8.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNColor.h"

@implementation PNColor

- (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return img;
}


@end
