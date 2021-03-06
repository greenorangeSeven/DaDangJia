//
//  FindPasswordView.m
//  DaDangJia
//
//  Created by Seven on 15/8/19.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "FindPasswordView.h"
#import "NSString+STRegex.h"

@interface FindPasswordView ()
{
    NSTimer *_timer;
    int countDownTime;
}

@end

@implementation FindPasswordView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找回密码";
    
    self.securitycodeBtn.layer.cornerRadius=self.securitycodeBtn.frame.size.height/2;
    self.saveBtn.layer.cornerRadius=self.saveBtn.frame.size.height/2;
}

- (IBAction)saveAction:(id)sender {
    NSString *mobileNoStr = self.mobileNoTf.text;
    NSString *validateCodeStr = self.securitycodeTf.text;
    NSString *pwdStr = self.newsPwdTf.text;
    NSString *pwdAgainStr = self.newsPwdATf.text;
    if (![mobileNoStr isValidPhoneNum]) {
        [Tool showCustomHUD:@"手机号错误" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (validateCodeStr == nil || [validateCodeStr length] == 0) {
        [Tool showCustomHUD:@"请输入验证码" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (pwdStr == nil || [pwdStr length] == 0) {
        [Tool showCustomHUD:@"请输入新密码" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([pwdStr isEqualToString:pwdAgainStr] == NO) {
        [Tool showCustomHUD:@"两次密码输入不一致" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    self.saveBtn.enabled = NO;
    //生成登陆URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:mobileNoStr forKey:@"mobileNo"];
    [param setValue:pwdStr forKey:@"newPassword"];
    [param setValue:validateCodeStr forKey:@"validateCode"];
    NSString *findPasswordUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findPassword] params:param];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:findPasswordUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestFind:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"找回中..." andView:self.view andHUD:request.hud];
}

- (void)requestFind:(ASIHTTPRequest *)request
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
        self.saveBtn.enabled = YES;
        return;
    }
    else
    {
        
        [Tool showCustomHUD:@"找回成功" andView:self.view andImage:nil andAfterDelay:1.1f];
        [self performSelector:@selector(back) withObject:self afterDelay:1.2f];
    }
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

- (IBAction)sendSecurityCodeAction:(id)sender {
    NSString *mobileNoStr = self.mobileNoTf.text;
    if (![mobileNoStr isValidPhoneNum]) {
        [Tool showCustomHUD:@"手机号错误" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    self.securitycodeBtn.enabled = NO;
    //生成验证码URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:mobileNoStr forKey:@"mobileNo"];
    NSString *createChangeCodeListUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_createFindPwdCode] params:param];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:createChangeCodeListUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestCreateRegCode:)];
    request.tag = 3;
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"验证码发送中" andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
    }
    [Tool showCustomHUD:@"网络连接超时" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
    if(self.securitycodeBtn.enabled == NO)
    {
        self.securitycodeBtn.enabled = YES;
    }
    if(self.saveBtn.enabled == NO)
    {
        self.saveBtn.enabled = YES;
    }
}

- (void)requestCreateRegCode:(ASIHTTPRequest *)request
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
        self.securitycodeBtn.enabled = YES;
        return;
    }
    else
    {
        [Tool showCustomHUD:@"验证码发送成功" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        [self startValidateCodeCountDown];
    }
}

- (void)startValidateCodeCountDown
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];
    countDownTime = 60;
}

- (void)timerFunc
{
    if (countDownTime > 0) {
        self.securitycodeBtn.enabled = NO;
        [self.securitycodeBtn setTitle:[NSString stringWithFormat:@"获取验证码(%d)" ,countDownTime] forState:UIControlStateDisabled];
        [self.securitycodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }
    else
    {
        self.securitycodeBtn.enabled = YES;
        [self.securitycodeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [self.securitycodeBtn setTitleColor:[UIColor colorWithRed:251/255.0 green:67/255.0 blue:79/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_timer invalidate];
    }
    countDownTime --;
}

@end
