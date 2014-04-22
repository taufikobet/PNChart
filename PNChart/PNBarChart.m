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

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *lowerBoundHorizontalLineView;
@property (nonatomic, strong) UIView *upperBoundHorizontalLineView;
@property (nonatomic, strong) UIView *verticalLineView;
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
        _barBackgroundColor  = PNWhite;
        _labels              = [NSMutableArray array];
        _bars                = [NSMutableArray array];
    }

    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];

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

        for(int index = 0; index < xLabels.count; index++)
        {
            NSString* labelText = xLabels[index];
            PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake((index *  _xLabelWidth + chartMargin), self.frame.size.height - 30.0, _xLabelWidth, 20.0)];
            [label setTextAlignment:NSTextAlignmentCenter];
            label.text = labelText;
            [_labels addObject:label];
            //[self addSubview:label];
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
    
    [self.verticalLineView removeFromSuperview];
    [self.upperBoundHorizontalLineView removeFromSuperview];
    [self.lowerBoundHorizontalLineView removeFromSuperview];
    [self.backgroundView removeFromSuperview];
    
    CGFloat insetMarginPercentage = 0.85;
    
    CGFloat chartCanvasWidth = self.frame.size.width * insetMarginPercentage;
    CGFloat chartCanvasHeight = self.frame.size.height * insetMarginPercentage;
    CGFloat xStartPosition = ceilf((self.frame.size.width - chartCanvasWidth) / 2);
    CGFloat yStartPosition = ceilf((self.frame.size.height - chartCanvasHeight) / 2);
    
    NSInteger index = 0;
    
    _xLabelWidth = chartCanvasWidth / [_yValues count];

    for (NSString * valueString in _yValues) {
        
        float value = [valueString floatValue];

        float grade = (float)value / (float)_yValueMax;

        CGFloat xPoint = (index * _xLabelWidth) + xStartPosition;
        CGFloat yPoint = self.frame.size.height - chartCanvasHeight - yStartPosition;
        
        PNBar *bar = [[PNBar alloc] initWithFrame:CGRectIntegral(CGRectMake(xPoint + _xLabelWidth/4, yPoint, _xLabelWidth/2, chartCanvasHeight))];

        bar.backgroundColor = [UIColor whiteColor];
        bar.barColor = [self barColorAtIndex:index];
        bar.grade = grade;
        
        [_bars addObject:bar];
        [self addSubview:bar];

        index++;
    }
    
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectIntegral(CGRectMake(xStartPosition, yStartPosition, chartCanvasWidth, chartCanvasHeight))];
    self.backgroundView.backgroundColor = [UIColor redColor];
    self.backgroundView.alpha = 0.5;
    
    //[self addSubview:self.backgroundView];
    
    self.lowerBoundHorizontalLineView = [[UIView alloc] initWithFrame:CGRectIntegral(CGRectMake(xStartPosition, yStartPosition + chartCanvasHeight, chartCanvasWidth + 1, 2))];
    self.lowerBoundHorizontalLineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.lowerBoundHorizontalLineView];
    
    self.upperBoundHorizontalLineView = [[UIView alloc] initWithFrame:CGRectIntegral(CGRectMake(xStartPosition, yStartPosition - 1, chartCanvasWidth + 1, 2))];
    self.upperBoundHorizontalLineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.upperBoundHorizontalLineView];
    
    self.verticalLineView = [[UIView alloc] initWithFrame:CGRectIntegral(CGRectMake(xStartPosition, yStartPosition, 2, chartCanvasHeight))];
    self.verticalLineView.backgroundColor = PNBlue;
    [self addSubview:self.verticalLineView];
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