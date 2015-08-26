//
//  SettingView.m
//  DaDangJia
//
//  Created by Seven on 15/8/26.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "SettingView.h"

@interface SettingView ()

@end

@implementation SettingView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    //退出登录
    UITapGestureRecognizer *logoutTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoutTapClick)];
    [self.logoutView addGestureRecognizer:logoutTap];
}

- (void)logoutTapClick
{
    //设置登录并保存用户信息
    UserModel *userModel = [UserModel Instance];
    [userModel logoutUser];
    [userModel saveIsLogin:NO];
    [userModel saveAccount:@"" andPwd:@""];
    
    UserHouse *defaultHouse = [userModel getUserInfo].defaultUserHouse;
    
    [Tool showCustomHUD:@"已退出登录" andView:self.view andImage:nil andAfterDelay:1.1f];
    [self performSelector:@selector(back) withObject:self afterDelay:1.2f];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
