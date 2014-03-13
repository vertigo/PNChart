//
//  PNCircleChart.h
//  PNChartDemo
//
//  Created by kevinzhow on 13-11-30.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNColor.h"


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface PNCircleChart : UIView

-(void)strokeChart;
- (id)initWithFrame:(CGRect)frame andTotal:(NSNumber *)total andCurrent:(NSNumber *)current andClockwise:(BOOL)clockwise;

- (id)initWithFrame:(CGRect)frame andCurrent:(NSNumber *)current andImage:(UIImage *)image;

@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic, strong) NSNumber * total;
@property (nonatomic, strong) NSNumber * current;
@property (nonatomic, strong) NSNumber * lineWidth;
@property (nonatomic) BOOL clockwise;
@property (nonatomic) BOOL animate;
@property (nonatomic) BOOL hideLabel;

@property(nonatomic,strong) CAShapeLayer * circle;
@property(nonatomic,strong) CAShapeLayer * circleBG;

@end
