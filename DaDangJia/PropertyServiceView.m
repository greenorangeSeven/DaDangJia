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
#import "JSBadgeView.h"
#import "AdView.h"
#import "ADInfo.h"
#import "CommDetailView.h"

@interface PropertyServiceView ()
{
    UserInfo *userInfo;
    JSBadgeView *billBadgeView;
    JSBadgeView *repairBadgeView;
    JSBadgeView *expressBadgeView;
    
    AdView * adView;
    NSMutableArray *advDatas;
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
    
    [self getADVData];
    
    [self findMyBill];
    [self getExpressTotal];
    [self getRepairTotal];
}

- (void)getADVData
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //生成获取广告URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:@"1144155067262200" forKey:@"typeId"];
        if (userInfo.defaultUserHouse.cellId != nil || [userInfo.defaultUserHouse.cellId length] > 0) {
            [param setValue:userInfo.defaultUserHouse.cellId forKey:@"cellId"];
        }
        [param setValue:@"1" forKey:@"timeCon"];
        NSString *getADDataUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findAdInfoList] params:param];
        
        [[AFOSCClient sharedClient]getPath:getADDataUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           advDatas = [Tool readJsonStrToAdinfoArray:operation.responseString];
                                           NSInteger length = [advDatas count];
                                           
                                           if (length > 0)
                                           {
                                               [self initAdView];
                                           }
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool showCustomHUD:@"网络不给力" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                                       }
                                   }];
    }
}

- (void)initAdView
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    NSMutableArray *imagesURL = [[NSMutableArray alloc] init];
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    if ([advDatas count] > 0) {
        for (ADInfo *ad in advDatas) {
            [imagesURL addObject:ad.imgUrlFull];
            [titles addObject:ad.adName];
        }
    }
    
    //如果你的这个广告视图是添加到导航控制器子控制器的View上,请添加此句,否则可忽略此句
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    adView = [AdView adScrollViewWithFrame:CGRectMake(0, 0, width, 136)  \
                              imageLinkURL:imagesURL\
                       placeHoderImageName:@"placeHoder.jpg" \
                      pageControlShowStyle:UIPageControlShowStyleLeft];
    
    //    是否需要支持定时循环滚动，默认为YES
    //    adView.isNeedCycleRoll = YES;
    
    [adView setAdTitleArray:nil withShowStyle:AdTitleShowStyleNone];
    //    设置图片滚动时间,默认3s
    //    adView.adMoveTime = 2.0;
    
    //图片被点击后回调的方法
    adView.callBack = ^(NSInteger index,NSString * imageURL)
    {
        NSLog(@"被点中图片的索引:%ld---地址:%@",index,imageURL);
        ADInfo *adv = (ADInfo *)[advDatas objectAtIndex:index];
        NSString *adDetailHtm = [NSString stringWithFormat:@"%@%@%@", api_base_url, htm_adDetail ,adv.adId];
        CommDetailView *detailView = [[CommDetailView alloc] init];
        detailView.titleStr = @"详情";
        detailView.urlStr = adDetailHtm;
        detailView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailView animated:YES];
    };
    [self.view addSubview:adView];
}

- (void)noticeTapClick
{
    NoticeTableView *noticeView = [[NoticeTableView alloc] init];
    [self.navigationController pushViewController:noticeView animated:YES];
}

- (void)findMyBill
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //查询指定房间所绑定的用户信息
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:userInfo.defaultUserHouse.numberId forKey:@"numberId"];
//        [param setValue:@"0" forKey:@"typeId"];
        [param setValue:@"100" forKey:@"countPerPages"];
        [param setValue:@"1" forKey:@"pageNumbers"];
        [param setValue:@"0" forKey:@"stateId"];
        
        NSString *findBillDetailsUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findBillDetailsByPage] params:param];
        [[AFOSCClient sharedClient]getPath:findBillDetailsUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                           NSError *error;
                                           NSDictionary *billJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                           
                                           int totalRecord = [[[billJsonDic objectForKey:@"data"] objectForKey:@"totalRecord"] intValue];
                                           if(totalRecord > 0)
                                           {
                                               billBadgeView = [[JSBadgeView alloc] initWithParentView:self.billBtn alignment:JSBadgeViewAlignmentTopRight];
                                               billBadgeView.badgeText = [NSString stringWithFormat:@"%d", totalRecord];
                                           }
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           
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
}

- (void)getExpressTotal
{
    //生成获取新闻列表URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.mobileNo forKey:@"mobileNo"];
    [param setValue:@"0" forKey:@"stateId"];
    [param setValue:@"1" forKey:@"pageNumbers"];
    [param setValue:@"1" forKey:@"countPerPages"];
    NSString *getExpressListUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_Express] params:param];
    
    [[AFOSCClient sharedClient]getPath:getExpressListUrl parameters:Nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   @try {
                                       NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                       NSError *error;
                                       NSDictionary *billJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                       
                                       int totalRecord = [[[billJsonDic objectForKey:@"data"] objectForKey:@"totalRecord"] intValue];
                                       if(totalRecord > 0)
                                       {
                                           expressBadgeView = [[JSBadgeView alloc] initWithParentView:self.expressBtn alignment:JSBadgeViewAlignmentTopRight];
                                           expressBadgeView.badgeText = [NSString stringWithFormat:@"%d", totalRecord];
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

- (void)getRepairTotal
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.defaultUserHouse.cellId forKey:@"cellId"];
    [param setValue:userInfo.regUserId forKey:@"userId"];
    [param setValue:@"1" forKey:@"pageNumbers"];
    [param setValue:@"1" forKey:@"countPerPages"];
    [param setValue:@"0,1,2" forKey:@"stateId"];
    NSString *getRepairListUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_FindRepairWorkByPage] params:param];
    
    [[AFOSCClient sharedClient]getPath:getRepairListUrl parameters:Nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   @try {
                                       NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                       NSError *error;
                                       NSDictionary *billJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                       
                                       int totalRecord = [[[billJsonDic objectForKey:@"data"] objectForKey:@"totalRecord"] intValue];
                                       if(totalRecord > 0)
                                       {
                                           repairBadgeView = [[JSBadgeView alloc] initWithParentView:self.repairBtn alignment:JSBadgeViewAlignmentTopRight];
                                           repairBadgeView.badgeText = [NSString stringWithFormat:@"%d", totalRecord];
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
