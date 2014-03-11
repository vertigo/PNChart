//
//  PNBarChart.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNBarChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"
#import "PNBar.h"

@interface PNBarChart() {
    NSMutableArray* _bars;
    NSMutableArray* _labels;
}

- (UIColor *)barColorAtIndex:(NSUInteger)index;
@end

@implementation PNBarChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds   = YES;
        _showLabel           = YES;
        _barBackgroundColor  = PNLightGrey;
        _labels              = [NSMutableArray array];
        _bars                = [NSMutableArray array];
    }

    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];

    _xLabelWidth = (self.frame.size.width - chartMargin*2)/[_yValues count];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    for (NSString * valueString in yLabels) {
        NSInteger value = [valueString integerValue];
        if (value > max) {
            max = value;
        }

    }

    //Min value for Y label
    if (max < 5) {
        max = 5;
    }

    _yValueMax = (int)max;
}

-(void)setXLabels:(NSArray *)xLabels
{
    [self viewCleanupForCollection:_labels];
    _xLabels = xLabels;

    if (_showLabel) {
        if (self.isHorizontal) {
            
            float optimumLabelWidth = 0.0f;
            
            for (NSString *labelValue in xLabels) {
                // FIXME: replace [UIFont boldSystemFontOfSize:11.0f] with a constant used by PNChartLabel
                CGSize idealSize = [labelValue sizeWithFont:[UIFont boldSystemFontOfSize:11.0f] constrainedToSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
                
                if (idealSize.width > optimumLabelWidth) {
                    optimumLabelWidth = idealSize.width;
                }
            }
            
            //FIXME: replace 40.0f with a maxLabelWidth constant
            if (40.0f < optimumLabelWidth) {
                optimumLabelWidth = 40.0f;
            }
            
            _xLabelHeight = (self.frame.size.height - chartMargin*2)/[xLabels count];
            _xLabelWidth = optimumLabelWidth;
            
            for(int index = 0; index < xLabels.count; index++)
            {
                NSString* labelText = xLabels[index];
                PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(chartMargin,
                                                                                      (index *  _xLabelHeight + chartMargin), //self.frame.size.height - 30.0,
                                                                                      40.0f,
                                                                                      _xLabelHeight)];
                [label setTextAlignment:NSTextAlignmentCenter];
                label.text = labelText;
                [_labels addObject:label];
                [self addSubview:label];
            }
        } else {
            _xLabelWidth = (self.frame.size.width - chartMargin*2)/[xLabels count];
            
            for(int index = 0; index < xLabels.count; index++)
            {
                NSString* labelText = xLabels[index];
                PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake((index *  _xLabelWidth + chartMargin), self.frame.size.height - 30.0, _xLabelWidth, 20.0)];
                [label setTextAlignment:NSTextAlignmentCenter];
                label.text = labelText;
                [_labels addObject:label];
                [self addSubview:label];
            }
        }
    }
}

-(void)setStrokeColor:(UIColor *)strokeColor
{
	_strokeColor = strokeColor;
}

-(void)strokeChart
{
    [self viewCleanupForCollection:_bars];
    CGFloat chartCavanHeight = self.frame.size.height - chartMargin * 2 - 40.0;
    CGFloat chartCavanWidth = self.frame.size.width - chartMargin * 2 - 40.0;
    NSInteger index = 0;

    for (NSString * valueString in _yValues) {
        float value = [valueString floatValue];

        float grade = (float)value / (float)_yValueMax;
        PNBar * bar;
        float xPos, yPos, width, height;
        
        if (self.isHorizontal) {
            xPos = self.frame.size.width - chartCavanWidth + _xLabelWidth;
            yPos = (index * _xLabelHeight + chartMargin + _xLabelHeight * 0.25);
            width = chartCavanWidth - _xLabelWidth;
            height = _xLabelHeight * 0.6;
            
            if (_showLabel) {
                xPos -= 30.0f;
            }
        } else {
            xPos = (index * _xLabelWidth + chartMargin + _xLabelWidth * 0.25);
            yPos = self.frame.size.height - chartCavanHeight;
            width = _xLabelWidth * 0.5;
            height = chartCavanHeight;
            
            if (_showLabel) {
                yPos -= 30.0f;
            }
        }
        
        bar = [[PNBar alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
        bar.isHorizontal = self.isHorizontal;
        
        bar.backgroundColor = _barBackgroundColor;
        bar.barColor = [self barColorAtIndex:index];
        bar.grade = grade;
        [_bars addObject:bar];
        [self addSubview:bar];

        index += 1;
    }
}

- (void)viewCleanupForCollection:(NSMutableArray*)array
{
    if (array.count) {
        [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [array removeAllObjects];
    }
}

#pragma mark - Class extension methods

- (UIColor *)barColorAtIndex:(NSUInteger)index
{
    if ([self.strokeColors count] == [self.yValues count]) {
        return self.strokeColors[index];
    } else {
        return self.strokeColor;
    }
}

@end
