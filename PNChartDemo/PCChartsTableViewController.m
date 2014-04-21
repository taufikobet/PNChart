//
//  PCChartsTableViewController.m
//  PNChartDemo
//
//  Created by kevinzhow on 13-12-1.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PCChartsTableViewController.h"
#import "PCChartViewController.h"

@interface PCChartsTableViewController ()
@end

@implementation PCChartsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController * viewController = [segue destinationViewController];
    viewController.automaticallyAdjustsScrollViewInsets = YES;
    viewController.edgesForExtendedLayout = UIRectEdgeNone;
    
}

-(void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex andPointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}

-(void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCChartType chartType;
    
    switch (indexPath.row) {
        case 0:
            chartType = PCChartTypeLine;
            break;
        case 1:
            chartType = PCChartTypeBar;
            break;
        case 2:
            chartType = PCChartTypeCircle;
            break;
        default:
            break;
    }
    
    PCChartViewController *viewController = [[PCChartViewController alloc] initWithChartType:chartType];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
