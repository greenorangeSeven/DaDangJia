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

@interface LeftView ()
{
    UserInfo *userInfo;
}

@property (strong, nonatomic) YRSideViewController *sideViewController;

@end

@implementation LeftView

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.faceIv.layer.masksToBounds=YES;
    self.faceIv.layer.cornerRadius = self.faceIv.frame.size.width/2;
//    self.loginBtn.layer.cornerRadius=self.loginBtn.frame.size.height/2;
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.sideViewController = [delegate sideViewController];
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
        [self.faceIv sd_setImageWithURL:[NSURL URLWithString:userInfo.photoFull] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
        
        self.nickNameLb.text = userInfo.nickName;
        self.userInfoLb.text = [NSString stringWithFormat:@"%@    %@", userInfo.mobileNo, userInfo.regUserName];
    }
    else
    {
        [self.faceIv setImage:[UIImage imageNamed:@"default_head.png"]];
        self.nickNameLb.text = @"";
        self.userInfoLb.text = @"";
    }
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

@end
