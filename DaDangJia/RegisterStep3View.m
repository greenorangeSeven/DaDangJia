//
//  RegisterStep3View.m
//  DaDangJia
//
//  Created by Seven on 15/8/20.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "RegisterStep3View.h"

@interface RegisterStep3View ()

@end

@implementation RegisterStep3View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"身份验证";
    
    self.finishBtn.layer.cornerRadius=self.finishBtn.frame.size.height/2;
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
