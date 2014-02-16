//
//  PNColor.h
//  PNChart
//
//  Created by kevin on 13-6-8.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 *  System Versioning Preprocessor Macros
 */

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define PNGrey         [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0f]
#define PNLightBlue    [UIColor colorWithRed:94.0/255.0 green:147.0/255.0 blue:196.0/255.0 alpha:1.0f]
#define PNGreen        [UIColor colorWithRed:77.0/255.0 green:186.0/255.0 blue:122.0/255.0 alpha:1.0f]
#define PNTitleColor   [UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:113.0/255.0 alpha:1.0f]
#define PNButtonGrey   [UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0f]
#define PNFreshGreen   [UIColor colorWithRed:77.0/255.0 green:196.0/255.0 blue:122.0/255.0 alpha:1.0f]
#define PNRed          [UIColor colorWithRed:245.0/255.0 green:94.0/255.0 blue:78.0/255.0 alpha:1.0f]
#define PNMauve        [UIColor colorWithRed:88.0/255.0 green:75.0/255.0 blue:103.0/255.0 alpha:1.0f]
#define PNBrown        [UIColor colorWithRed:119.0/255.0 green:107.0/255.0 blue:95.0/255.0 alpha:1.0f]
#define PNBlue         [UIColor colorWithRed:82.0/255.0 green:116.0/255.0 blue:188.0/255.0 alpha:1.0f]
#define PNDarkBlue     [UIColor colorWithRed:121.0/255.0 green:134.0/255.0 blue:142.0/255.0 alpha:1.0f]
#define PNYellow       [UIColor colorWithRed:242.0/255.0 green:197.0/255.0 blue:117.0/255.0 alpha:1.0f]
#define PNWhite        [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f]
#define PNDeepGrey     [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0f]
#define PNPinkGrey     [UIColor colorWithRed:200.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0f]
#define PNHealYellow   [UIColor colorWithRed:245.0/255.0 green:242.0/255.0 blue:238.0/255.0 alpha:1.0f]
#define PNLightGrey    [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0f]
#define PNCleanGrey    [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0f]
#define PNLightYellow  [UIColor colorWithRed:241.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f]
#define PNDarkYellow   [UIColor colorWithRed:152.0/255.0 green:150.0/255.0 blue:159.0/255.0 alpha:1.0f]
#define PNPinkDark     [UIColor colorWithRed:170.0/255.0 green:165.0/255.0 blue:165.0/255.0 alpha:1.0f]
#define PNCloudWhite   [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0f]
#define PNBlack        [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0f]
#define PNStarYellow   [UIColor colorWithRed:252.0/255.0 green:223.0/255.0 blue:101.0/255.0 alpha:1.0f]
#define PNTwitterColor [UIColor colorWithRed:0.0/255.0 green:171.0/255.0 blue:243.0/255.0 alpha:1.0]
#define PNWeiboColor   [UIColor colorWithRed:250.0/255.0 green:0.0/255.0 blue:33.0/255.0 alpha:1.0]
#define PNiOSGreenColor   [UIColor colorWithRed:98.0/255.0 green:247.0/255.0 blue:77.0/255.0 alpha:1.0]


@interface PNColor : NSObject


- (UIImage *)imageFromColor:(UIColor *)color;


@end
