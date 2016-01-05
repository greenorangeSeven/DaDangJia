//
//  RegisterStep3View.m
//  DaDangJia
//
//  Created by Seven on 15/8/20.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "RegisterStep3View.h"
#import "IQKeyboardManager/KeyboardManager.framework/Headers/IQKeyboardManager.h"
#import "LoginView.h"
#import "AppDelegate.h"

@interface RegisterStep3View ()
{
    UIWebView *phoneWebView;
    NSString *identityId;
}

@property (nonatomic, strong) UIPickerView *identityPicker;

@property (nonatomic, strong) NSArray *identityNameArray;
@property (nonatomic, strong) NSArray *identityIdArray;

@end

@implementation RegisterStep3View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"身份验证";
    
    self.finishBtn.layer.cornerRadius=self.finishBtn.frame.size.height/2;
    
    self.identityNameArray = @[@"业主", @"业主家属", @"租户"];
    self.identityIdArray = @[@"0", @"1", @"2"];
    
    identityId = @"0";
    
    self.identityPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.identityPicker.showsSelectionIndicator = YES;
    self.identityPicker.delegate = self;
    self.identityPicker.dataSource = self;
    self.identityPicker.tag = 1;
    self.identityTf.inputView = self.identityPicker;
    self.identityTf.delegate = self;
}

#pragma mark -
#pragma mark Picker Data Source Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 1)
    {
        return [self.identityNameArray count];
    }
    else
    {
        return 0;
    }
}

#pragma mark Picker Delegate Methods
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 1)
    {
        return [self.identityNameArray objectAtIndex:row];;
    }
    else
    {
        return nil;
    }
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (thePickerView.tag == 1)
    {
        self.identityTf.text = [self.identityNameArray objectAtIndex:row];
        identityId = [self.identityIdArray objectAtIndex:row];
    }
}

- (UIToolbar *)keyboardToolBar:(NSInteger)fieldIndex
{
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [toolBar sizeToFit];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] init];
    doneButton.tag = fieldIndex;
    doneButton.title = @"完成";
    doneButton.style = UIBarButtonItemStyleDone;
    doneButton.action = @selector(doneClicked:);
    doneButton.target = self;
    
    
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    return toolBar;
}

- (void)doneClicked:(UITextField *)sender
{
    [self.identityTf resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.inputAccessoryView = [self keyboardToolBar:textField.tag];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
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

- (IBAction)finishAction:(id)sender {
    NSString *idCardStr = self.idCardTf.text;
    NSString *ownerNameStr = self.ownerNameTf.text;
    if ([idCardStr length] != 4) {
        [Tool showCustomHUD:@"请输入正确的身份证后四位" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([ownerNameStr length] == 0) {
        [Tool showCustomHUD:@"请输入业主姓名" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    self.finishBtn.enabled = NO;
    //生成注册URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:ownerNameStr forKey:@"regUserName"];
    [param setValue:idCardStr forKey:@"idCardLast4"];
    [param setValue:identityId forKey:@"userTypeId"];
    [param setValue:self.numberId forKey:@"numberId"];
    [param setValue:self.validateCodeStr forKey:@"validateCode"];
    [param setValue:self.mobileNoStr forKey:@"mobileNo"];
    [param setValue:self.nickName forKey:@"nickName"];
    [param setValue:self.passwordStr forKey:@"password"];
    
     NSString *allCityUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_regUser] params:param];
    
    
    NSString *regUserSign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_regUser] params:param];
    NSString *regUserUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_regUser];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:regUserUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    [request setPostValue:Appkey forKey:@"accessId"];
    [request setPostValue:ownerNameStr forKey:@"regUserName"];
    [request setPostValue:idCardStr forKey:@"idCardLast4"];
    [request setPostValue:identityId forKey:@"userTypeId"];
    [request setPostValue:self.numberId forKey:@"numberId"];
    [request setPostValue:self.validateCodeStr forKey:@"validateCode"];
    [request setPostValue:self.mobileNoStr forKey:@"mobileNo"];
    [request setPostValue:self.nickName forKey:@"nickName"];
    [request setPostValue:self.passwordStr forKey:@"password"];
    [request setPostValue:regUserSign forKey:@"sign"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestRegUser:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"注册中..." andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
        
    }
    [Tool showCustomHUD:@"网络连接超时" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
    if(self.finishBtn.enabled == NO)
    {
        self.finishBtn.enabled = YES;
    }
}
- (void)requestRegUser:(ASIHTTPRequest *)request
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
        self.finishBtn.enabled = YES;
        return;
    }
    else
    {
        UserInfo *userInfo = [Tool readJsonStrToLoginUserInfo:request.responseString];
//        //设置登录并保存用户信息
//        UserModel *userModel = [UserModel Instance];
//        [userModel saveIsLogin:YES];
//        [userModel saveAccount:self.mobileNoStr andPwd:self.passwordStr];
//        [userModel saveValue:userInfo.regUserId ForKey:@"regUserId"];
//        [userModel saveValue:userInfo.regUserName ForKey:@"regUserName"];
//        [userModel saveValue:userInfo.mobileNo ForKey:@"mobileNo"];
//        [userModel saveValue:userInfo.nickName ForKey:@"nickName"];
//        [userModel saveValue:userInfo.photoFull ForKey:@"photoFull"];
//        
//        if([userInfo.rhUserHouseList count] > 0)
//        {
//            for (int i = 0; i < [userInfo.rhUserHouseList count]; i++) {
//                UserHouse *userHouse = (UserHouse *)[userInfo.rhUserHouseList objectAtIndex:0];
//                if (i == 0) {
//                    [userModel saveValue:[userHouse.userTypeId stringValue] ForKey:@"userTypeId"];
//                    [userModel saveValue:userHouse.userTypeName ForKey:@"userTypeName"];
//                    [userModel saveValue:userHouse.numberName ForKey:@"numberName"];
//                    [userModel saveValue:userHouse.buildingName ForKey:@"buildingName"];
//                    [userModel saveValue:userHouse.cellName ForKey:@"cellName"];
//                    [userModel saveValue:userHouse.cellId ForKey:@"cellId"];
//                    [userModel saveValue:userHouse.phone ForKey:@"cellPhone"];
//                    [userModel saveValue:userHouse.numberId ForKey:@"numberId"];
//                    userHouse.isDefault = YES;
//                    userInfo.defaultUserHouse = userHouse;
//                }
//                else
//                {
//                    userHouse.isDefault = NO;
//                }
//            }
//        }
//        else
//        {
//            [userModel saveValue:@"" ForKey:@"userTypeId"];
//            [userModel saveValue:@"" ForKey:@"userTypeName"];
//            [userModel saveValue:@"" ForKey:@"numberName"];
//            [userModel saveValue:@"" ForKey:@"buildingName"];
//            [userModel saveValue:@"" ForKey:@"cellName"];
//            [userModel saveValue:@"" ForKey:@"cellId"];
//            [userModel saveValue:@"" ForKey:@"cellPhone"];
//            [userModel saveValue:@"" ForKey:@"numberId"];
//        }
//        //        [[EGOCache globalCache] setObject:userInfo forKey:UserInfoCache withTimeoutInterval:3600 * 24 * 356];
//        [[UserModel Instance] saveUserInfo:userInfo];

        [Tool showCustomHUD:@"注册成功" andView:self.view andImage:nil andAfterDelay:1.1f];
        [self performSelector:@selector(back) withObject:self afterDelay:1.2f];
    }
}

- (void)back
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [arr removeLastObject];
    [arr removeLastObject];
    [arr removeLastObject];
    self.navigationController.viewControllers = arr;
    [self.navigationController popViewControllerAnimated:YES];
//    LoginView *loginView = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
//    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginView];
//    AppDelegate *appdele = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    appdele.window.rootViewController = loginNav;
}

@end
