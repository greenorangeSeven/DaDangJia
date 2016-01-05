//
//  SettingView.m
//  DaDangJia
//
//  Created by Seven on 15/8/26.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "SettingView.h"
#import "CommDetailView.h"
#import "OpinionView.h"
#import "VersionsView.h"
#import "XGPush.h"
#import "RecommendView.h"

@interface SettingView ()
{
    UIWebView *phoneWebView;
}

@end

@implementation SettingView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.view.frame.size.height);
    
    //退出登录
    UITapGestureRecognizer *logoutTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoutTapClick)];
    [self.logoutView addGestureRecognizer:logoutTap];
}

- (void)logoutTapClick
{
    //设置登录并保存用户信息
    UserModel *userModel = [UserModel Instance];
    [XGPush delTag:userModel.userInfo.defaultUserHouse.cellId];
    [userModel logoutUser];
    [userModel saveIsLogin:NO];
    [userModel saveAccount:@"" andPwd:@""];
    
//    UserHouse *defaultHouse = [userModel getUserInfo].defaultUserHouse;
    
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

- (IBAction)yhxyAction:(id)sender {
    NSString *userAgreementHtm = [NSString stringWithFormat:@"%@%@", api_base_url, htm_userAgreement];
    CommDetailView *detailView = [[CommDetailView alloc] init];
    detailView.titleStr = @"用户协议";
    detailView.urlStr = userAgreementHtm;
    detailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)ystkAction:(id)sender {
    NSString *privacyClauseHtm = [NSString stringWithFormat:@"%@%@", api_base_url, htm_privacyClause];
    CommDetailView *detailView = [[CommDetailView alloc] init];
    detailView.titleStr = @"隐私条款";
    detailView.urlStr = privacyClauseHtm;
    detailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)yjfkAction:(id)sender {
    OpinionView *opinionView = [[OpinionView alloc] init];
    opinionView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:opinionView animated:YES];
}

- (IBAction)tjxzAction:(id)sender {
    RecommendView *recommendView = [[RecommendView alloc] init];
    recommendView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recommendView animated:YES];
}

- (IBAction)kfrxAction:(id)sender {
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", servicephone]];
    if (!phoneWebView) {
        phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneWebView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
}

- (IBAction)gywmAction:(id)sender {
    NSString *aboutHtm = [NSString stringWithFormat:@"%@%@", api_base_url, htm_about];
    CommDetailView *detailView = [[CommDetailView alloc] init];
    detailView.titleStr = @"关于我们";
    detailView.urlStr = aboutHtm;
    detailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)bbsmAction:(id)sender {
    VersionsView *versionsView = [[VersionsView alloc] init];
    versionsView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:versionsView animated:YES];
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
