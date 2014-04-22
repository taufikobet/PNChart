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
     
    CGFloat chartCanvasHeight = self.frame.size.height;
    NSInteger index = 0;
    
    _xLabelWidth = (self.frame.size.width) / [_yValues count];

    for (NSString * valueString in _yValues) {
        
        float value = [valueString floatValue];

        float grade = (float)value / (float)_yValueMax;

        CGFloat xPoint = (index *  _xLabelWidth);
        CGFloat yPoint = self.frame.size.height - chartCanvasHeight;
        
        PNBar *bar = [[PNBar alloc] initWithFrame:CGRectIntegral(CGRectMake(xPoint, yPoint, _xLabelWidth, chartCanvasHeight))];

        bar.backgroundColor = [UIColor whiteColor];
        bar.barColor = [self barColorAtIndex:index];
        bar.grade = grade;
        
        [_bars addObject:bar];
        [self addSubview:bar];

        index++;
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