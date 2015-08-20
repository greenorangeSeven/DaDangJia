//
//  RegisterStep1View.m
//  DaDangJia
//
//  Created by Seven on 15/8/19.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "RegisterStep1View.h"

@interface RegisterStep1View ()

@end

@implementation RegisterStep1View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle: @"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(nextAction:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.securitycodeBtn.layer.cornerRadius=self.securitycodeBtn.frame.size.height/2;
}

- (void)nextAction:(id)sender
{
    
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

@end
