//
//  MainFrameView.m
//  DaDangJia
//
//  Created by Seven on 15/8/18.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "MainFrameView.h"
#import "AppDelegate.h"
#import "YRSideViewController.h"
#import "SettingView.h"

@interface MainFrameView ()

@property (strong, nonatomic) YRSideViewController *sideViewController;

@end

@implementation MainFrameView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.sideViewController = [delegate sideViewController];
    
    [self initNavigationItem1];
    
    //下属控件初始化
    self.mainPage = [[MainPageView alloc] init];
    self.mainPage.frameView = self.mainView;
    [self addChildViewController:self.mainPage];
    [self.mainView addSubview:self.mainPage.view];
}

- (void)initNavigationItem1
{
    UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 98, 24)];
    [titleImage setImage:[UIImage imageNamed:@"maintitlelogo"]];
    self.navigationItem.titleView = titleImage;
    
    self.title = nil;
    
    UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [lBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [lBtn setImage:[UIImage imageNamed:@"maintop_l"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [rBtn setImage:[UIImage imageNamed:@"maintop_r"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)initNavigationItem2
{
    self.navigationItem.titleView = nil;
    
    self.title = @"便民服务";
    
//    UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [lBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [lBtn setImage:[UIImage imageNamed:@"maintop_l"] forState:UIControlStateNormal];
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
//    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initNavigationItem3
{
    self.navigationItem.titleView = nil;
    
    self.title = @"随手拍";
    
    self.navigationItem.leftBarButtonItem = nil;
    
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initNavigationItem4
{
    self.navigationItem.titleView = nil;
    
    self.title = @"邻里";
    
    self.navigationItem.leftBarButtonItem = nil;
    
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initNavigationItem5
{
    self.navigationItem.titleView = nil;
    
    self.title = @"周边";
    
    self.navigationItem.leftBarButtonItem = nil;
    
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)leftBtnAction:(id)sender
{
    [self.sideViewController showLeftViewController:YES];
}

- (void)rightBtnAction:(id)sender
{
    [self.sideViewController setNeedSwipeShowMenu:NO];
    [self.sideViewController hideSideViewController:YES];
    UINavigationController *mainTab = (UINavigationController *)self.sideViewController.rootViewController;
    SettingView *settingView = [[SettingView alloc] init];
    settingView.hidesBottomBarWhenPushed = YES;
    [mainTab pushViewController:settingView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)item1Action:(id)sender {
    [self initNavigationItem1];
    
    [self.item1Btn setImage:[UIImage imageNamed:@"main_pro"] forState:UIControlStateNormal];
    [self.item1Lb setTextColor:[UIColor colorWithRed:188.0/255 green:204.0/255 blue:131.0/255 alpha:1.0]];
    
    [self.item2Btn setImage:[UIImage imageNamed:@"bianmin_nor"] forState:UIControlStateNormal];
    [self.item2Lb setTextColor:[UIColor colorWithRed:174.0/255 green:158.0/255 blue:146.0/255 alpha:1.0]];
    
    [self.item3Btn setImage:[UIImage imageNamed:@"zhaoxiang_nor"] forState:UIControlStateNormal];
    
    [self.item4Btn setImage:[UIImage imageNamed:@"linli_nor"] forState:UIControlStateNormal];
    [self.item4Lb setTextColor:[UIColor colorWithRed:174.0/255 green:158.0/255 blue:146.0/255 alpha:1.0]];
    
    [self.item5Btn setImage:[UIImage imageNamed:@"zhoubian_nor"] forState:UIControlStateNormal];
    [self.item5Lb setTextColor:[UIColor colorWithRed:174.0/255 green:158.0/255 blue:146.0/255 alpha:1.0]];


    self.mainPage.view.hidden = NO;
    self.conveniencePage.view.hidden = YES;
    self.readilyPage.view.hidden = YES;
    self.topicPage.view.hidden = YES;
    self.nearbyPage.view.hidden = YES;
}

- (IBAction)item2Action:(id)sender {
    [self initNavigationItem2];
    
    [self.item1Btn setImage:[UIImage imageNamed:@"main_nor"] forState:UIControlStateNormal];
    [self.item1Lb setTextColor:[UIColor colorWithRed:174.0/255 green:158.0/255 blue:146.0/255 alpha:1.0]];
    
    [self.item2Btn setImage:[UIImage imageNamed:@"bianmin_pro"] forState:UIControlStateNormal];
    [self.item2Lb setTextColor:[UIColor colorWithRed:188.0/255 green:204.0/255 blue:131.0/255 alpha:1.0]];
    
    [self.item3Btn setImage:[UIImage imageNamed:@"zhaoxiang_nor"] forState:UIControlStateNormal];
    
    [self.item4Btn setImage:[UIImage imageNamed:@"linli_nor"] forState:UIControlStateNormal];
    [self.item4Lb setTextColor:[UIColor colorWithRed:174.0/255 green:158.0/255 blue:146.0/255 alpha:1.0]];
    
    [self.item5Btn setImage:[UIImage imageNamed:@"zhoubian_nor"] forState:UIControlStateNormal];
    [self.item5Lb setTextColor:[UIColor colorWithRed:174.0/255 green:158.0/255 blue:146.0/255 alpha:1.0]];

    
    if (self.conveniencePage == nil) {
        self.conveniencePage = [[ConvenienceView alloc] init];
        self.conveniencePage.frameView = self.mainView;
        [self addChildViewController:self.conveniencePage];
        [self.mainView addSubview:self.conveniencePage.view];
    }
    self.mainPage.view.hidden = YES;
    self.conveniencePage.view.hidden = NO;
    self.readilyPage.view.hidden = YES;
    self.topicPage.view.hidden = YES;
    self.nearbyPage.view.hidden = YES;
}

- (IBAction)item3Action:(id)sender {
    
    [self initNavigationItem3];
    
    [self.item1Btn setImage:[UIImage imageNamed:@"main_nor"] forState:UIControlStateNormal];
    [self.item1Lb setTextColor:[UIColor colorWithRed:174.0/255 green:158.0/255 blue:146.0/255 alpha:1.0]];
    
    [self.item2Btn setImage:[UIImage imageNamed:@"bianmin_nor"] forState:UIControlStateNormal];
    [self.item2Lb setTextColor:[UIColor colorWithRed:174.0/255 green:158.0/255 blue:146.0/255 alpha:1.0]];
    
    [self.item3Btn setImage:[UIImage imageNamed:@"zhaoxiang_pro"] forState:UIControlStateNormal];
    
    [self.item4Btn setImage:[UIImage imageNamed:@"linli_nor"] forState:UIControlStateNormal];
    [self.item4Lb setTextColor:[UIColor colorWithRed:174.0/255 green:158.0/255 blue:146.0/255 alpha:1.0]];
    
    [self.item5Btn setImage:[UIImage imageNamed:@"zhoubian_nor"] forState:UIControlStateNormal];
    [self.item5Lb setTextColor:[UIColor colorWithRed:174.0/255 green:158.0/255 blue:146.0/255 alpha:1.0]];

    
    if (self.readilyPage == nil) {
        self.readilyPage = [[ReadilyView alloc] init];
        self.readilyPage.frameView = self.mainView;
        [self addChildViewController:self.readilyPage];
        [self.mainView addSubview:self.readilyPage.view];
    }
    self.mainPage.view.hidden = YES;
    self.conveniencePage.view.hidden = YES;
    self.readilyPage.view.hidden = NO;
    self.topicPage.view.hidden = YES;
    self.nearbyPage.view.hidden = YES;
}

- (IBAction)item4Action:(id)sender {
    [self initNavigationItem4];
    
    [self.item1Btn setImage:[UIImage imageNamed:@"main_nor"] forState:UIControlStateNormal];
    [self.item1Lb setTextColor:[UIColor colorWithRed:174.0/255 green:158.0/255 blue:146.0/255 alpha:1.0]];
    
    [self.item2Btn setImage:[UIImage imageNamed:@"bianmin_nor"] forState:UIControlStateNormal];
    [self.item2Lb setTextColor:[UIColor colorWithRed:174.0/255 green:158.0/255 blue:146.0/255 alpha:1.0]];
    
    [self.item3Btn setImage:[UIImage imageNamed:@"zhaoxiang_nor"] forState:UIControlStateNormal];
    
    [self.item4Btn setImage:[UIImage imageNamed:@"linli_pro"] forState:UIControlStateNormal];
    [self.item4Lb setTextColor:[UIColor colorWithRed:188.0/255 green:204.0/255 blue:131.0/255 alpha:1.0]];
    
    [self.item5Btn setImage:[UIImage imageNamed:@"zhoubian_nor"] forState:UIControlStateNormal];
    [self.item5Lb setTextColor:[UIColor colorWithRed:174.0/255 green:158.0/255 blue:146.0/255 alpha:1.0]];
    
    if (self.topicPage == nil) {
        self.topicPage = [[TopicPageView alloc] init];
        self.topicPage.frameView = self.mainView;
        [self addChildViewController:self.topicPage];
        [self.mainView addSubview:self.topicPage.view];
    }
    self.mainPage.view.hidden = YES;
    self.conveniencePage.view.hidden = YES;
    self.readilyPage.view.hidden = YES;
    self.topicPage.view.hidden = NO;
    self.nearbyPage.view.hidden = YES;
}

- (IBAction)item5Action:(id)sender {
    [self initNavigationItem5];
    
    [self.item1Btn setImage:[UIImage imageNamed:@"main_nor"] forState:UIControlStateNormal];
    [self.item1Lb setTextColor:[UIColor colorWithRed:174.0/255 green:158.0/255 blue:146.0/255 alpha:1.0]];
    
    [self.item2Btn setImage:[UIImage imageNamed:@"bianmin_nor"] forState:UIControlStateNormal];
    [self.item2Lb setTextColor:[UIColor colorWithRed:174.0/255 green:158.0/255 blue:146.0/255 alpha:1.0]];
    
    [self.item3Btn setImage:[UIImage imageNamed:@"zhaoxiang_nor"] forState:UIControlStateNormal];
    
    [self.item4Btn setImage:[UIImage imageNamed:@"linli_nor"] forState:UIControlStateNormal];
    [self.item4Lb setTextColor:[UIColor colorWithRed:174.0/255 green:158.0/255 blue:146.0/255 alpha:1.0]];
    
    [self.item5Btn setImage:[UIImage imageNamed:@"zhoubian_pro"] forState:UIControlStateNormal];
    [self.item5Lb setTextColor:[UIColor colorWithRed:188.0/255 green:204.0/255 blue:131.0/255 alpha:1.0]];
    
    if (self.nearbyPage == nil) {
        self.nearbyPage = [[NearbyView alloc] init];
        self.nearbyPage.frameView = self.mainView;
        [self addChildViewController:self.nearbyPage];
        [self.mainView addSubview:self.nearbyPage.view];
    }
    self.mainPage.view.hidden = YES;
    self.conveniencePage.view.hidden = YES;
    self.readilyPage.view.hidden = YES;
    self.topicPage.view.hidden = YES;
    self.nearbyPage.view.hidden = NO;
}
@end
