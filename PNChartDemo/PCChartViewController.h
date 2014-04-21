//
//  PCChartViewController.h
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PCChartType)
{
    PCChartTypeLine,
    PCChartTypeBar,
    PCChartTypeCircle
};

@interface PCChartViewController : UIViewController

-(instancetype)initWithChartType:(PCChartType)chartType;

@end
