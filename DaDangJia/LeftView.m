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

@interface LeftView ()

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginAction:(id)sender {
    [self.sideViewController hideSideViewController:YES];
    UINavigationController *mainTab = (UINavigationController *)self.sideViewController.rootViewController;
    LoginView *inviteView = [[LoginView alloc] init];
    inviteView.hidesBottomBarWhenPushed = YES;
    [mainTab pushViewController:inviteView animated:YES];
}
@end
