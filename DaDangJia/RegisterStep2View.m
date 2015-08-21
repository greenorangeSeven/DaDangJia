//
//  RegisterStep2View.m
//  DaDangJia
//
//  Created by Seven on 15/8/20.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "RegisterStep2View.h"
#import "RegisterStep3View.h"

@interface RegisterStep2View ()

@end

@implementation RegisterStep2View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"住户信息";
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle: @"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(nextAction:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)nextAction:(id)sender
{
    RegisterStep3View *step3View = [[RegisterStep3View alloc] init];
    [self.navigationController pushViewController:step3View animated:YES];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}

@end
