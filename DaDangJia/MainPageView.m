//
//  MainPageView.m
//  DaDangJia
//
//  Created by Seven on 15/8/18.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "MainPageView.h"
#import "AdView.h"
#import "ADInfo.h"
#import "CommDetailView.h"
#import "PropertyServiceView.h"
#import "TuanPageView.h"
#import "WelfreListView.h"
#import "TopicListView.h"
#import "AppDelegate.h"
#import "YRSideViewController.h"

@interface MainPageView ()
{
    AdView * adView;
    UserInfo *userInfo;
    NSMutableArray *advDatas;
}

@property (strong, nonatomic) YRSideViewController *sideViewController;

@end

@implementation MainPageView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.view.frame.size.height);
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height = self.frameView.frame.size.height;
    viewFrame.size.width = self.frameView.frame.size.width;
    self.view.frame = viewFrame;
    
//    NSString *lotteryHtm = [NSString stringWithFormat:@"%@%@accessId=%@&userId=%@", api_base_url, htm_lottery, Appkey, userInfo.regUserId];
    
    [self getADVData];
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.sideViewController = [delegate sideViewController];
}

- (void)getADVData
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //生成获取广告URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:@"1141788149430600" forKey:@"typeId"];
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
    
    adView = [AdView adScrollViewWithFrame:CGRectMake(0, 0, width, 150)  \
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

- (IBAction)propertyServiceAction:(id)sender {
    [self.sideViewController setNeedSwipeShowMenu:NO];
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    PropertyServiceView *serviceView = [[PropertyServiceView alloc] init];
    [self.navigationController pushViewController:serviceView animated:YES];
}

- (IBAction)tuanAction:(id)sender {
    [self.sideViewController setNeedSwipeShowMenu:NO];
    TuanPageView *tuanView = [[TuanPageView alloc] init];
    [self.navigationController pushViewController:tuanView animated:YES];
}

- (IBAction)welfreAction:(id)sender {
    [self.sideViewController setNeedSwipeShowMenu:NO];
    WelfreListView *welfreView = [[WelfreListView alloc] init];
    [self.navigationController pushViewController:welfreView animated:YES];
}

- (IBAction)helpAction:(id)sender {
    [self.sideViewController setNeedSwipeShowMenu:NO];
    TopicListView *helpView = [[TopicListView alloc] init];
    helpView.typeName = @"帮帮忙";
    helpView.typeId = @"0";
    helpView.adId = @"1141856653531200";
    [self.navigationController pushViewController:helpView animated:YES];
}

- (IBAction)zjlAction:(id)sender {
    [self.sideViewController setNeedSwipeShowMenu:NO];
    TopicListView *zjlView = [[TopicListView alloc] init];
    zjlView.typeName = @"召集令";
    zjlView.typeId = @"1";
    zjlView.adId = @"1141857144700000";
    [self.navigationController pushViewController:zjlView animated:YES];
}

- (IBAction)hyhAction:(id)sender {
//    [self.sideViewController setNeedSwipeShowMenu:NO];
    TopicListView *helpView = [[TopicListView alloc] init];
    helpView.typeName = @"换一换";
    helpView.typeId = @"2";
    helpView.adId = @"1141857157067500";
    [self.navigationController pushViewController:helpView animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.sideViewController setNeedSwipeShowMenu:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Tool processLoginNotice:actionSheet andButtonIndex:buttonIndex andNav:self.navigationController andParent:nil];
}

@end
