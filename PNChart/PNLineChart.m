//
//  PNLineChart.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNLineChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"


//------------------------------------------------------------------------------------------------
// private interface declaration
//------------------------------------------------------------------------------------------------
@interface PNLineChart ()

@property (nonatomic,strong) NSMutableArray *chartLineArray; // Array[CAShapeLayer]

@property (strong, nonatomic) NSMutableArray *chartPath; //Array of line path, one for each line.

@property (assign, nonatomic) CGPoint currentPoint;

@property (nonatomic, strong) UIView *verticalLineView;

- (void)setDefaultValues;

@end


//------------------------------------------------------------------------------------------------
// public interface implementation
//------------------------------------------------------------------------------------------------
@implementation PNLineChart

#pragma mark initialization

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultValues];
        self.clipsToBounds = NO;
    }
    return self;
}

#pragma mark instance methods

-(void)setYLabels:(NSArray *)yLabels
{
    
    CGFloat yStep = (_yValueMax-_yValueMin) / _yLabelNum;
	CGFloat yStepHeight = _chartCanvasHeight / _yLabelNum;
    
    
    NSInteger index = 0;
	NSInteger num = _yLabelNum+1;
	while (num > 0) {
		PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0, (_chartCanvasHeight - index * yStepHeight), _chartMargin, _yLabelHeight)];
		[label setTextAlignment:NSTextAlignmentRight];
		label.text = [NSString stringWithFormat:@"%1.f",_yValueMin + (yStep * index)];
		//[self addSubview:label];
        index +=1 ;
		num -= 1;
	}
    
}

-(void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    NSString* labelText;
    if(_showLabel){
        //_xLabelWidth = _chartCanvasWidth/[xLabels count];
        
        for(int index = 0; index < xLabels.count; index++)
        {
            labelText = xLabels[index];
            PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(2*_chartMargin +  (index * _xLabelWidth) - (_xLabelWidth / 2), _chartMargin + _chartCanvasHeight, _xLabelWidth, _chartMargin)];
            [label setTextAlignment:NSTextAlignmentCenter];
            label.text = labelText;
            
            //[self addSubview:label];
        }
        
    }else{
        //_xLabelWidth = (self.frame.size.width)/[xLabels count];
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchPoint:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchPoint:touches withEvent:event];
}

-(void)touchPoint:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    for (UIBezierPath *path in _chartPath) {
        CGPathRef originalPath = path.CGPath;
        CGPathRef strokedPath = CGPathCreateCopyByStrokingPath(originalPath, NULL, 3.0, kCGLineCapRound, kCGLineJoinRound, 3.0);
        BOOL pathContainsPoint = CGPathContainsPoint(strokedPath, NULL, touchPoint, NO);
        if (pathContainsPoint)
        {
            [_delegate userClickedOnLinePoint:touchPoint lineIndex:[_chartPath indexOfObject:path]];
            for (NSArray *linePointsArray in _pathPoints) {
                for (NSValue *val in linePointsArray) {
                    CGPoint p = [val CGPointValue];
                    if (p.x + 3.0 > touchPoint.x && p.x - 3.0 < touchPoint.x && p.y + 3.0 > touchPoint.y && p.y - 3.0 < touchPoint.y ) {
                        //Call the delegate and pass the point and index of the point
                        [_delegate userClickedOnLineKeyPoint:touchPoint lineIndex:[_pathPoints indexOfObject:linePointsArray] andPointIndex:[linePointsArray indexOfObject:val]];
                    }
                }
            }
            
        }
    }
    
}

-(void)strokeChart
{
    [self.verticalLineView removeFromSuperview];
    
    _chartPath = [[NSMutableArray alloc] init];
    
    //Draw each line
    PNLineChartData *chartData = self.chartData.firstObject;
    CAShapeLayer *chartLineShapeLayer = (CAShapeLayer *) self.chartLineArray.firstObject;

    _chartMargin = 0.85;
    CGFloat insetMarginPercentage = 0.85;
    
    CGFloat chartCanvasWidth = self.frame.size.width * insetMarginPercentage;
    CGFloat chartCanvasHeight = self.frame.size.height * insetMarginPercentage;
    _chartCanvasWidth = chartCanvasWidth;
    _chartCanvasHeight = chartCanvasHeight;
    
    CGFloat xStartPosition = ceilf((self.frame.size.width - chartCanvasWidth) / 2);
    CGFloat yStartPosition = ceilf((self.frame.size.height - chartCanvasHeight) / 2);
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath setLineWidth:2.0];
    [bezierPath setLineCapStyle:kCGLineCapButt];
    [bezierPath setLineJoinStyle:kCGLineJoinBevel];
    
    [_chartPath addObject:bezierPath];
    
    CGFloat xLabelWidth = chartCanvasWidth / chartData.itemCount;
    NSLog(@"%@", @(xLabelWidth));
    
    NSMutableArray *linePoints = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < chartData.itemCount; i++) {
        
        CGFloat yValue = chartData.getData(i).y;
        
        CGFloat innerGrade = yValue / _yValueMax;
        
        CGFloat xPoint = ceilf(i * xLabelWidth + (xLabelWidth / 2) + xStartPosition);
        CGFloat yPoint = ceilf(chartCanvasHeight - (innerGrade * chartCanvasHeight) + yStartPosition);
        
        CGPoint point = CGPointMake(xPoint, yPoint);
        
        if (i > 0) {
            [bezierPath addLineToPoint:point];
        }
        
        [bezierPath moveToPoint:point];
        [linePoints addObject:[NSValue valueWithCGPoint:point]];

    }
    
    self.verticalLineView = [[UIView alloc] initWithFrame:CGRectIntegral(CGRectMake(chartCanvasWidth + xStartPosition, yStartPosition, 2, chartCanvasHeight))];
    self.verticalLineView.backgroundColor = [UIColor redColor];
    [self addSubview:self.verticalLineView];
    
    [_pathPoints addObject:[linePoints copy]];
    // setup the color of the chart line
    if (chartData.color) {
        chartLineShapeLayer.strokeColor = [chartData.color CGColor];
    }else{
        chartLineShapeLayer.strokeColor = [PNGreen CGColor];
    }
    
    [bezierPath stroke];
    
    chartLineShapeLayer.path = bezierPath.CGPath;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];

    [chartLineShapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    chartLineShapeLayer.strokeEnd = 1.0;
}

- (void)setChartData:(NSArray *)data {
    if (data != _chartData) {
        
        NSMutableArray *yLabelsArray = [NSMutableArray arrayWithCapacity:data.count];
        CGFloat yMax = 0.0f;
        CGFloat yMin = MAXFLOAT;
        CGFloat yValue;
        
        // remove all shape layers before adding new ones
        for (CALayer *layer in self.chartLineArray) {
            [layer removeFromSuperlayer];
        }
        
        self.chartLineArray = [NSMutableArray arrayWithCapacity:data.count];
        
        for (PNLineChartData *chartData in data) {
            
            // create as many chart line layers as there are data-lines
            CAShapeLayer *chartLine = [CAShapeLayer layer];
            chartLine.lineCap   = kCALineCapButt;
            chartLine.lineJoin  = kCALineJoinBevel;
            chartLine.fillColor = [[UIColor whiteColor] CGColor];
            chartLine.lineWidth = 2.0;
            chartLine.strokeEnd = 0.0;
            
            [self.layer addSublayer:chartLine];
            [self.chartLineArray addObject:chartLine];
            
            for (NSUInteger i = 0; i < chartData.itemCount; i++) {
                yValue = chartData.getData(i).y;
                [yLabelsArray addObject:[NSString stringWithFormat:@"%2f", yValue]];
                yMax = fmaxf(yMax, yValue);
                yMin = fminf(yMin, yValue);
            }
        }
        
        // Min value for Y label
        if (yMax < 5) {
            yMax = 5.0f;
        }
        if (yMin < 0){
            yMin = 0.0f;
        }
        
        _yValueMin = yMin;
        _yValueMax = yMax;
        
        _chartData = data;
        
        if (_showLabel) {
            [self setYLabels:yLabelsArray];
        }
        
        [self setNeedsDisplay];
    }
}

#pragma mark private methods

- (void)setDefaultValues {
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds   = YES;
    self.chartLineArray  = [NSMutableArray new];
    _showLabel           = YES;
    _pathPoints = [[NSMutableArray alloc] init];
    self.userInteractionEnabled = YES;
    
    _yLabelNum = 5.0;
    _yLabelHeight = [[[[PNChartLabel alloc] init] font] pointSize];
    
    _chartMargin = 30;
    
    _chartCanvasWidth = self.frame.size.width - _chartMargin *2;
    _chartCanvasHeight = self.frame.size.height - _chartMargin * 2;
}

@end
