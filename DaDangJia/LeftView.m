//
//  LeftView.m
//  DaDangJia
//
//  Created by Seven on 15/8/19.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "LeftView.h"
#import "LoginView.h"
#import "AppDelegate.h"
#import "YRSideViewController.h"
#import "MainFrameView.h"
#import "UIImageView+WebCache.h"
#import "UserInfoView.h"
#import "SettingView.h"
#import "MyIntegralView.h"
#import "MyGroupBuyView.h"
#import "MyRedPacketView.h"
#import "MyCouponView.h"
#import "MyPublicClassView.h"
#import "MyCollectView.h"
#import "MyPublicView.h"

@interface LeftView ()
{
    UserInfo *userInfo;
    int integral;
}

@property (strong, nonatomic) YRSideViewController *sideViewController;

@end

@implementation LeftView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - 54);
        
    self.faceIv.layer.masksToBounds=YES;
    self.faceIv.layer.cornerRadius = self.faceIv.frame.size.width/2;
//    self.loginBtn.layer.cornerRadius=self.loginBtn.frame.size.height/2;
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.sideViewController = [delegate sideViewController];
    
    [self addTapAction];
}

- (void)addTapAction
{
    //积分点击
    UITapGestureRecognizer *integralTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(integralTapClick)];
    [self.integralLb addGestureRecognizer:integralTap];
}

- (void)integralTapClick
{
    [self.sideViewController setNeedSwipeShowMenu:NO];
    [self.sideViewController hideSideViewController:YES];
    UINavigationController *mainTab = (UINavigationController *)self.sideViewController.rootViewController;
    MyIntegralView *integralView = [[MyIntegralView alloc] init];
    integralView.integral = integral;
    integralView.hidesBottomBarWhenPushed = YES;
    [mainTab pushViewController:integralView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.sideViewController setNeedSwipeShowMenu:YES];
    
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    userInfo = [[UserModel Instance] getUserInfo];
    if(userInfo != nil)
    {
        [self findRegUserInfoByUserId];
        [self.faceIv sd_setImageWithURL:[NSURL URLWithString:userInfo.photoFull] placeholderImage:[UIImage imageNamed:@"main_wygj"]];
        
        self.nickNameLb.text = userInfo.nickName;
        
    }
    else
    {
        [self.faceIv setImage:[UIImage imageNamed:@"main_wygj"]];
        self.nickNameLb.text = @"点击登录";
        self.userInfoLb.text = @"";
    }
}

- (void)findRegUserInfoByUserId
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.regUserId forKey:@"userId"];
    
    NSString *findRegUserInfoUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findRegUserInfoByUserId] params:param];
    [[AFOSCClient sharedClient] getPath:findRegUserInfoUrl parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
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
                                        
                                    }
                                    else
                                    {
                                        integral = [[[json objectForKey:@"data"] objectForKey:@"integral"] intValue];
                                        self.userInfoLb.text = [NSString stringWithFormat:@"%@    %d积分", userInfo.mobileNo, integral];
                                    }
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"列表获取出错");
                                    if ([UserModel Instance].isNetworkRunning == NO) {
                                        return;
                                    }
                                    if ([UserModel Instance].isNetworkRunning) {
                                        [Tool showCustomHUD:@"网络不给力" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                                    }
                                }];
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
    [self.sideViewController setNeedSwipeShowMenu:NO];
    [self.sideViewController hideSideViewController:YES];
    UINavigationController *mainTab = (UINavigationController *)self.sideViewController.rootViewController;
    if([[UserModel Instance] isLogin])
    {
        UserInfoView *userInfoView = [[UserInfoView alloc] init];
        userInfoView.hidesBottomBarWhenPushed = YES;
        [mainTab pushViewController:userInfoView animated:YES];
    }
    else
    {
        LoginView *inviteView = [[LoginView alloc] init];
        inviteView.hidesBottomBarWhenPushed = YES;
        [mainTab pushViewController:inviteView animated:YES];
    }
    
}

- (IBAction)settingAction:(id)sender {
    [self.sideViewController setNeedSwipeShowMenu:NO];
    [self.sideViewController hideSideViewController:YES];
    UINavigationController *mainTab = (UINavigationController *)self.sideViewController.rootViewController;
    SettingView *settingView = [[SettingView alloc] init];
    settingView.hidesBottomBarWhenPushed = YES;
    [mainTab pushViewController:settingView animated:YES];
}

- (IBAction)myGroupByAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    [self.sideViewController setNeedSwipeShowMenu:NO];
    [self.sideViewController hideSideViewController:YES];
    UINavigationController *mainTab = (UINavigationController *)self.sideViewController.rootViewController;
    MyGroupBuyView *groupBuyView = [[MyGroupBuyView alloc] init];
    groupBuyView.hidesBottomBarWhenPushed = YES;
    [mainTab pushViewController:groupBuyView animated:YES];
}

- (IBAction)myRedPacketAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    [self.sideViewController setNeedSwipeShowMenu:NO];
    [self.sideViewController hideSideViewController:YES];
    UINavigationController *mainTab = (UINavigationController *)self.sideViewController.rootViewController;
    MyRedPacketView *redPacketView = [[MyRedPacketView alloc] init];
    redPacketView.hidesBottomBarWhenPushed = YES;
    [mainTab pushViewController:redPacketView animated:YES];
}

- (IBAction)myCouponAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    [self.sideViewController setNeedSwipeShowMenu:NO];
    [self.sideViewController hideSideViewController:YES];
    UINavigationController *mainTab = (UINavigationController *)self.sideViewController.rootViewController;
    MyCouponView *couponView = [[MyCouponView alloc] init];
    couponView.hidesBottomBarWhenPushed = YES;
    [mainTab pushViewController:couponView animated:YES];
}

- (IBAction)myPublicAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    [self.sideViewController setNeedSwipeShowMenu:NO];
    [self.sideViewController hideSideViewController:YES];
    UINavigationController *mainTab = (UINavigationController *)self.sideViewController.rootViewController;
    MyPublicClassView *myPublicView = [[MyPublicClassView alloc] init];
    myPublicView.hidesBottomBarWhenPushed = YES;
    [mainTab pushViewController:myPublicView animated:YES];
//    MyPublicView *myPublicView = [[MyPublicView alloc] init];
//    myPublicView.hidesBottomBarWhenPushed = YES;
//    [mainTab pushViewController:myPublicView animated:YES];
    
}

- (IBAction)myCollectAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    [self.sideViewController setNeedSwipeShowMenu:NO];
    [self.sideViewController hideSideViewController:YES];
    UINavigationController *mainTab = (UINavigationController *)self.sideViewController.rootViewController;
    MyCollectView *myCollectView = [[MyCollectView alloc] init];
    myCollectView.hidesBottomBarWhenPushed = YES;
    [mainTab pushViewController:myCollectView animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.sideViewController setNeedSwipeShowMenu:NO];
    [self.sideViewController hideSideViewController:YES];
    UINavigationController *mainTab = (UINavigationController *)self.sideViewController.rootViewController;
    [Tool processLoginNotice:actionSheet andButtonIndex:buttonIndex andNav:mainTab andParent:nil];
}

@end
