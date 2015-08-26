//
//  LoginView.m
//  DaDangJia
//
//  Created by Seven on 15/8/18.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "LoginView.h"
#import "XGPush.h"
#import "FindPasswordView.h"
#import "RegisterStep1View.h"

@interface LoginView ()

@end

@implementation LoginView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 98, 24)];
    [titleImage setImage:[UIImage imageNamed:@"maintitlelogo"]];
    self.navigationItem.titleView = titleImage;
    
    self.loginBtn.layer.cornerRadius=self.loginBtn.frame.size.height/2;
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

- (IBAction)loginAction:(id)sender {
    NSString *userNameStr = self.userNameTf.text;
    NSString *pwdStr = self.passwordTf.text;
    if (userNameStr == nil || [userNameStr length] == 0) {
        [Tool showCustomHUD:@"请输入您的用户名" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (pwdStr == nil || [pwdStr length] == 0) {
        [Tool showCustomHUD:@"请输入您的密码" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    self.loginBtn.enabled = NO;
    //生成登陆URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userNameStr forKey:@"mobileNo"];
    [param setValue:pwdStr forKey:@"password"];
    NSString *loginUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_login] params:param];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:loginUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestLogin:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"登录中..." andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
    }
    [Tool showCustomHUD:@"网络连接超时" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
    if(self.loginBtn.enabled == NO)
    {
        self.loginBtn.enabled = YES;
    }
}
- (void)requestLogin:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    
    [request setUseCookiePersistence:YES];
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *state = [[json objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == NO) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                     message:[[json objectForKey:@"header"] objectForKey:@"msg"]
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        self.loginBtn.enabled = YES;
        return;
    }
    else
    {
        NSLog(@"%@", request.responseString);
        UserInfo *userInfo = [Tool readJsonStrToLoginUserInfo:request.responseString];
        //设置登录并保存用户信息
        UserModel *userModel = [UserModel Instance];
        [userModel saveIsLogin:YES];
        userInfo.defaultUserHouse = nil;
        
        [userModel saveAccount:self.userNameTf.text andPwd:self.passwordTf.text];
        [userModel saveValue:userInfo.regUserId ForKey:@"regUserId"];
        [userModel saveValue:userInfo.regUserName ForKey:@"regUserName"];
        [userModel saveValue:userInfo.mobileNo ForKey:@"mobileNo"];
        [userModel saveValue:userInfo.nickName ForKey:@"nickName"];
        [userModel saveValue:userInfo.photoFull ForKey:@"photoFull"];
        if([userInfo.rhUserHouseList count] > 0)
        {
            for (int i = 0; i < [userInfo.rhUserHouseList count]; i++) {
                UserHouse *userHouse = (UserHouse *)[userInfo.rhUserHouseList objectAtIndex:i];
                if ([userHouse.userStateId intValue] == 1){
                    //                if (i == 0) {
                    [userModel saveValue:[userHouse.userTypeId stringValue] ForKey:@"userTypeId"];
                    [userModel saveValue:userHouse.userTypeName ForKey:@"userTypeName"];
                    [userModel saveValue:userHouse.numberName ForKey:@"numberName"];
                    [userModel saveValue:userHouse.buildingName ForKey:@"buildingName"];
                    [userModel saveValue:userHouse.cellName ForKey:@"cellName"];
                    [userModel saveValue:userHouse.cellId ForKey:@"cellId"];
                    [userModel saveValue:userHouse.phone ForKey:@"cellPhone"];
                    [userModel saveValue:userHouse.numberId ForKey:@"numberId"];
                    userHouse.isDefault = YES;
                    userInfo.defaultUserHouse = userHouse;
                    [userModel saveIsLogin:YES];
                    [XGPush setTag:userInfo.defaultUserHouse.cellId];
                    break;
                }
                else
                {
                    userHouse.isDefault = NO;
                }
            }
        }
        else
        {
            [userModel saveValue:@"" ForKey:@"userTypeId"];
            [userModel saveValue:@"" ForKey:@"userTypeName"];
            [userModel saveValue:@"" ForKey:@"numberName"];
            [userModel saveValue:@"" ForKey:@"buildingName"];
            [userModel saveValue:@"" ForKey:@"cellName"];
            [userModel saveValue:@"" ForKey:@"cellId"];
            [userModel saveValue:@"" ForKey:@"cellPhone"];
            [userModel saveValue:@"" ForKey:@"numberId"];
        }
        [[UserModel Instance] saveUserInfo:userInfo];
        [Tool showCustomHUD:@"欢迎回来" andView:self.view andImage:nil andAfterDelay:1.1f];
        [self performSelector:@selector(back) withObject:self afterDelay:1.2f];
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registerAction:(id)sender {
    RegisterStep1View *registerView = [[RegisterStep1View alloc] init];
    [self.navigationController pushViewController:registerView animated:YES];
}

- (IBAction)findPasswordAction:(id)sender {
    FindPasswordView *findView = [[FindPasswordView alloc] init];
    [self.navigationController pushViewController:findView animated:YES];
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
