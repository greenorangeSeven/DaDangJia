//
//  FeeTypeView.m
//  DaDangJia
//
//  Created by Seven on 15/8/28.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "FeeTypeView.h"
#import "FeeTableView.h"

@interface FeeTypeView ()

@end

@implementation FeeTypeView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"物业缴费";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)wuyeFeeAction:(id)sender {
    FeeTableView *wuyeFeeView = [[FeeTableView alloc] init];
    wuyeFeeView.typeId = @"0";
    wuyeFeeView.title = @"物业缴费";
    [self.navigationController pushViewController:wuyeFeeView animated:YES];
    
}

- (IBAction)parkFeeAction:(id)sender {
    FeeTableView *parkFeeView = [[FeeTableView alloc] init];
    parkFeeView.typeId = @"1";
    parkFeeView.title = @"停车缴费";
    [self.navigationController pushViewController:parkFeeView animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}

@end
