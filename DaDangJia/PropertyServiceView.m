//
//  PropertyServiceView.m
//  DaDangJia
//
//  Created by Seven on 15/8/26.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "PropertyServiceView.h"
#import "NoticeTableView.h"
#import "AddRepairView.h"
#import "ExpressView.h"
#import "FeeTypeView.h"

@interface PropertyServiceView ()
{
    UserInfo *userInfo;
}

@end

@implementation PropertyServiceView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物业管家";
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    //修改密码点击
    UITapGestureRecognizer *noticeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noticeTapClick)];
    [self.noticeView addGestureRecognizer:noticeTap];
    
    [self getNoticeData];
}

- (void)noticeTapClick
{
    NoticeTableView *noticeView = [[NoticeTableView alloc] init];
    [self.navigationController pushViewController:noticeView animated:YES];
}

- (void)getNoticeData
{
    //生成获取新闻列表URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.defaultUserHouse.cellId forKey:@"cellId"];
    [param setValue:@"1" forKey:@"pageNumbers"];
    [param setValue:@"1" forKey:@"countPerPages"];
    NSString *getNoticeListUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findPushInfo] params:param];
    
    [[AFOSCClient sharedClient]getPath:getNoticeListUrl parameters:Nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   
                                   NSMutableArray *noticeNews = [Tool readJsonStrToNoticeArray:operation.responseString];
                                   
                                   @try {
                                       NSInteger count = [noticeNews count];
                                       if (count > 0)
                                       {
                                           Notice *n = [noticeNews objectAtIndex:0];
                                           self.noticeTitleTf.text = n.des;
                                       }

                                   }
                                   @catch (NSException *exception) {
                                       [NdUncaughtExceptionHandler TakeException:exception];
                                   }
                                   @finally {
                                   }
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   NSLog(@"列表获取出错");
                                   //如果是刷新
                                   
                                   if ([UserModel Instance].isNetworkRunning == NO) {
                                       return;
                                   }
                                   if ([UserModel Instance].isNetworkRunning) {
                                       [Tool showCustomHUD:@"网络不给力" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                                   }
                               }];
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

- (IBAction)noticeAction:(id)sender {
    NoticeTableView *noticeView = [[NoticeTableView alloc] init];
    [self.navigationController pushViewController:noticeView animated:YES];
}

- (IBAction)addRepairAction:(id)sender {
    AddRepairView *repairView = [[AddRepairView alloc] init];
    [self.navigationController pushViewController:repairView animated:YES];
}

- (IBAction)expressAction:(id)sender {
    ExpressView *expressView = [[ExpressView alloc] init];
    [self.navigationController pushViewController:expressView animated:YES];
}

- (IBAction)payfeeAction:(id)sender {
    FeeTypeView *feeView = [[FeeTypeView alloc] init];
    [self.navigationController pushViewController:feeView animated:YES];
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
