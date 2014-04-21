//
//  PCChartViewController.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PCChartViewController.h"
#import "PNChart.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"


@interface PCChartViewController ()
@property (nonatomic, strong) PNLineChart *lineChart;
@property (nonatomic, strong) PNBarChart *barChart;
@property (nonatomic, strong) PNCircleChart *circleChart;

@end

@implementation PCChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
//    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    /*
    {
        //Add LineChart
        UILabel * lineChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 30)];
        lineChartLabel.text = @"Line Chart";
        lineChartLabel.textColor = PNFreshGreen;
        lineChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        lineChartLabel.textAlignment = NSTextAlignmentCenter;
        
        self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.lineChart.backgroundColor = [UIColor clearColor];
        
        [self.lineChart setXLabels:@[@"NOV",@"DEC",@"JAN",@"FEB"]];
        
        // Line Chart Nr.1
        NSArray * yData = @[@3, @1, @5, @6];
        PNLineChartData *data01 = [PNLineChartData new];
        data01.color = PNFreshGreen;
        data01.itemCount = self.lineChart.xLabels.count;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [[yData objectAtIndex:index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        self.lineChart.chartData = @[data01];
        [self.lineChart strokeChart];
        
        self.lineChart.delegate = self;
        
        [self.view addSubview:lineChartLabel];
        [self.view addSubview:self.lineChart];
        
        self.title = @"Line Chart";
    }
    */
    
    {
        //Add BarChart
        
        UILabel * barChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 30)];
        barChartLabel.text = @"Bar Chart";
        barChartLabel.textColor = PNFreshGreen;
        barChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        barChartLabel.textAlignment = NSTextAlignmentCenter;
        
        self.barChart = [[PNBarChart alloc] initWithFrame:self.view.frame];
        self.barChart.backgroundColor = [UIColor clearColor];
        self.barChart.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]];
        [self.barChart setYValues:@[@1,@24,@12,@18,@30,@10,@21]];
        [self.barChart setStrokeColors:@[PNGreen,PNGreen,PNRed,PNGreen,PNGreen,PNYellow,PNGreen]];
        
        [self.view addSubview:barChartLabel];
        [self.view addSubview:self.barChart];
        
        self.title = @"Bar Chart";
    }

    /*
    {
        
        //Add CircleChart
        
        
        UILabel * circleChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 30)];
        circleChartLabel.text = @"Circle Chart";
        circleChartLabel.textColor = PNFreshGreen;
        circleChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        circleChartLabel.textAlignment = NSTextAlignmentCenter;
        
        self.circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 80.0, SCREEN_WIDTH, SCREEN_HEIGHT) andTotal:[NSNumber numberWithInt:100] andCurrent:[NSNumber numberWithInt:60]];
        self.circleChart.backgroundColor = [UIColor clearColor];
        [self.circleChart setStrokeColor:PNGreen];
        [self.circleChart strokeChart];
        
        [self.view addSubview:circleChartLabel];
        [self.view addSubview:self.circleChart];
        self.title = @"Circle Chart";
        
    }
    */
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.barChart strokeChart];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.barChart strokeChart];
}

-(void)viewDidLayoutSubviews
{
}

@end
