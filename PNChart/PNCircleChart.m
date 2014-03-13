//
//  PNCircleChart.m
//  PNChartDemo
//
//  Created by kevinzhow on 13-11-30.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNCircleChart.h"
#import "UICountingLabel.h"

@interface PNCircleChart () {
    UICountingLabel *_gradeLabel;
    UIImageView *_imageView;
}

@end

@implementation PNCircleChart

- (UIColor *)labelColor
{
    if (!_labelColor) {
        _labelColor = PNDeepGrey;
    }
    return _labelColor;
}


- (id)initWithFrame:(CGRect)frame andTotal:(NSNumber *)total andCurrent:(NSNumber *)current andClockwise:(BOOL)clockwise {
    self = [super initWithFrame:frame];
    
    if (self) {
        _total = total;
        _current = current;
        _strokeColor = PNFreshGreen;
		_clockwise = clockwise;
		_animate = YES;
		_hideLabel = NO;
		
		CGFloat startAngle = clockwise ? -90.0f : 270.0f;
		CGFloat endAngle = clockwise ? -90.01f : 270.01f;
        
        _lineWidth = [NSNumber numberWithFloat:8.0];
        UIBezierPath* circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x,self.center.y) radius:self.frame.size.height*0.5 startAngle:DEGREES_TO_RADIANS(startAngle) endAngle:DEGREES_TO_RADIANS(endAngle) clockwise:clockwise];
        
        _circle               = [CAShapeLayer layer];
        _circle.path          = circlePath.CGPath;
        _circle.lineCap       = kCALineCapRound;
        _circle.fillColor     = [UIColor clearColor].CGColor;
        _circle.lineWidth     = [_lineWidth floatValue];
        _circle.zPosition     = 1;

        _circleBG             = [CAShapeLayer layer];
        _circleBG.path        = circlePath.CGPath;
        _circleBG.lineCap     = kCALineCapRound;
        _circleBG.fillColor   = [UIColor clearColor].CGColor;
        _circleBG.lineWidth   = [_lineWidth floatValue];
        _circleBG.strokeColor = PNLightYellow.CGColor;
        _circleBG.strokeEnd   = 1.0;
        _circleBG.zPosition   = -1;
        
        [self.layer addSublayer:_circle];
        [self.layer addSublayer:_circleBG];

		_gradeLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, 0, 50.0, 50.0)];
		_gradeLabel.hidden = _hideLabel;
        
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame andCurrent:(NSNumber *)current andImage:(UIImage *)image {
	
    self = [self initWithFrame:frame andTotal:@100 andCurrent:current andClockwise:YES];
	
	if (self) {
		_animate = NO;
		
		_imageView = [[UIImageView alloc] initWithImage:image];
	}
	
	return self;
}

-(void)strokeChart
{
    //Add count label
    
    [_gradeLabel setTextAlignment:NSTextAlignmentCenter];
    [_gradeLabel setFont:[UIFont fontWithName:@"Helvetica Neue Light" size:18.0f ]];
    [_gradeLabel setTextColor:self.labelColor];
    [_gradeLabel setCenter:CGPointMake(self.center.x,self.center.y)];
    _gradeLabel.method = UILabelCountingMethodEaseInOut;
    _gradeLabel.format = @"%d%%";
	
    [self addSubview:_gradeLabel];
	
	if (_imageView) {
		[_imageView setCenter:CGPointMake(self.center.x, self.center.y)];
		[self addSubview:_imageView];
		
		[_gradeLabel setCenter:CGPointMake(self.center.x + self.frame.size.width * 0.1, self.center.y + self.frame.size.height * 0.85)];
	}
   
    
    
    //Add circle params
    
    _circle.lineWidth   = [_lineWidth floatValue];
    _circleBG.lineWidth = [_lineWidth floatValue];
    _circleBG.strokeEnd = 1.0;
    _circle.strokeColor = _strokeColor.CGColor;
    
	if (_animate) {
		//Add Animation
		CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
		pathAnimation.duration = 1.0;
		pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
		pathAnimation.toValue = [NSNumber numberWithFloat:[_current floatValue]/[_total floatValue]];
		[_circle addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
	}
	
    _circle.strokeEnd   = [_current floatValue]/[_total floatValue];
    
	if (_animate) {
		[_gradeLabel countFrom:0 to:[_current floatValue]/[_total floatValue]*100 withDuration:1.0];
	} else {
		if([_gradeLabel.format rangeOfString:@"%(.*)d" options:NSRegularExpressionSearch].location != NSNotFound || [_gradeLabel.format rangeOfString:@"%(.*)i"].location != NSNotFound )
        {
            _gradeLabel.text = [NSString stringWithFormat:_gradeLabel.format,[_current intValue]];
        } else {
            _gradeLabel.text = [NSString stringWithFormat:_gradeLabel.format,[_current floatValue]];
        }
	}
   
}

@end
