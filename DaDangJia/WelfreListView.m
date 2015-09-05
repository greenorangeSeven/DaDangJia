//
//  WelfreListView.m
//  DaDangJia
//
//  Created by Seven on 15/9/4.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "WelfreListView.h"
#import "AdView.h"
#import "RedPacket.h"
#import "CouponCell.h"
#import "Coupon.h"
#import "UIImageView+WebCache.h"
#import "LootRedPacketView.h"
#import "UIViewController+CWPopup.h"

@interface WelfreListView ()
{
    AdView * adView;
    UserInfo *userInfo;
    NSMutableArray *redPacketDatas;
}

@end

@implementation WelfreListView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"福利包";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    //    设置无分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    allCount = 0;
    //添加的代码
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, self.view.frame.size.width, 320)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    coupons = [[NSMutableArray alloc] initWithCapacity:20];
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    [self getRedPacketData];
    [self reload:YES];
}

- (void)getRedPacketData
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {

        //生成获取红包URL
        NSString *getRPDataUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findRedpackageRuleOnTime] params:nil];
        
        [[AFOSCClient sharedClient]getPath:getRPDataUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                       NSError *error;
                                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                       
                                       NSArray *datas = [json objectForKey:@"data"];
                                       
                                       @try {
                                           redPacketDatas = [NSMutableArray arrayWithArray:[Tool readJsonToObjArray:datas andObjClass:[RedPacket class]]];
                                           NSInteger length = [redPacketDatas count];
                                           
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
    if ([redPacketDatas count] > 0) {
        for (RedPacket *rp in redPacketDatas) {
            [imagesURL addObject:rp.imgFull];
            [titles addObject:rp.rpName];
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
        RedPacket *rp = [redPacketDatas objectAtIndex:index];
        LootRedPacketView *samplePopupViewController = [[LootRedPacketView alloc] initWithNibName:@"LootRedPacketView" bundle:nil];
        samplePopupViewController.parentView = self;
        samplePopupViewController.redPacket = rp;
        [self presentPopupViewController:samplePopupViewController animated:YES completion:^(void) {
            NSLog(@"popup view presented");
        }];

    };
    [self.headerView addSubview:adView];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    _refreshHeaderView = nil;
    [coupons removeAllObjects];
    coupons = nil;
    [super viewDidUnload];
}

- (void)clear
{
    allCount = 0;
    [coupons removeAllObjects];
    isLoadOver = NO;
}

- (void)reload:(BOOL)noRefresh
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        if (isLoading || isLoadOver) {
            return;
        }
        if (!noRefresh) {
            allCount = 0;
        }
        int pageIndex = allCount/20 + 1;
        
        //生成获取新闻列表URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:@"0" forKey:@"isClose"];
        [param setValue:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageNumbers"];
        [param setValue:@"20" forKey:@"countPerPages"];
        NSString *getCouponListUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findCouponInfoByPage] params:param];
        
        [[AFOSCClient sharedClient]getPath:getCouponListUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                       NSError *error;
                                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                       NSArray *resultsList = [[json objectForKey:@"data"] objectForKey:@"resultsList"];
                                       NSMutableArray *couponNews = [NSMutableArray arrayWithArray:[Tool readJsonToObjArray:resultsList andObjClass:[Coupon class]]];
                                       
                                       isLoading = NO;
                                       if (!noRefresh) {
                                           [self clear];
                                       }
                                       
                                       @try {
                                           NSInteger count = [couponNews count];
                                           allCount += count;
                                           if (count < 20)
                                           {
                                               isLoadOver = YES;
                                           }
                                           [coupons addObjectsFromArray:couponNews];
                                           [self.tableView reloadData];
                                           [self doneLoadingTableViewData];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           [self doneLoadingTableViewData];
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"列表获取出错");
                                       //如果是刷新
                                       [self doneLoadingTableViewData];
                                       
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       isLoading = NO;
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool showCustomHUD:@"网络不给力" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                                       }
                                   }];
        isLoading = YES;
    }
}

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([UserModel Instance].isNetworkRunning) {
        if (isLoadOver) {
            return coupons.count == 0 ? 1 : coupons.count;
        }
        else
            return coupons.count + 1;
    }
    else
        return coupons.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (row < [coupons count])
    {
        return 150.0;
    }
    else
    {
        return 40.0;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    cell.backgroundColor = [Tool getBackgroundColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if ([coupons count] > 0) {
        if (row < [coupons count])
        {
            CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:CouponCellIdentifier];
            if (!cell) {
                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CouponCell" owner:self options:nil];
                for (NSObject *o in objects) {
                    if ([o isKindOfClass:[CouponCell class]]) {
                        cell = (CouponCell *)o;
                        break;
                    }
                }
            }
            Coupon *c = [coupons objectAtIndex:row];
            cell.nameLb.text = c.couponName;
            cell.desLb.text = c.des;
            [cell.imgIv sd_setImageWithURL:[NSURL URLWithString:c.imgFull] placeholderImage:[UIImage imageNamed:@"loadpic.png"]];
            cell.getBtn.layer.cornerRadius = cell.getBtn.frame.size.height/2;
            [cell.getBtn addTarget:self action:@selector(getCouponAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.getBtn.tag = row;
            return cell;
        }
        else
        {
            return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:isLoadOver andLoadOverString:@"已经加载全部" andLoadingString:(isLoading ? loadingTip : loadNext20Tip) andIsLoading:isLoading];
        }
    }
    else
    {
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:isLoadOver andLoadOverString:@"暂无数据" andLoadingString:(isLoading ? loadingTip : loadNext20Tip) andIsLoading:isLoading];
    }
}

//表格行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    //点击“下面20条”
    if (row >= [coupons count]) {
        //启动刷新
        if (!isLoading) {
            [self performSelector:@selector(reload:)];
        }
    }
    else
    {
//        Notice *n = [notices objectAtIndex:[indexPath row]];
//        NSString *pushDetailHtm = [NSString stringWithFormat:@"%@%@%@", api_base_url, htm_pushDetailHtm ,n.pushId];
//        CommDetailView *detailView = [[CommDetailView alloc] init];
//        detailView.titleStr = @"详情";
//        detailView.urlStr = pushDetailHtm;
//        [self.navigationController pushViewController:detailView animated:YES];
    }
}

- (void)getCouponAction:(id)sender
{
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    UIButton *tap = (UIButton *)sender;
    NSInteger row = tap.tag;
    Coupon *c = [coupons objectAtIndex:row];
    //领取优惠券
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:c.couponId forKey:@"couponId"];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    NSString *heartUrl =[Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_receivingCoupon] params:param];
    [[AFOSCClient sharedClient]getPath:heartUrl parameters:Nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   @try {
                                       NSLog(@"%@", operation.responseString);
                                       NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                       NSError *error;
                                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                       
                                       NSString *state = [[json objectForKey:@"header"] objectForKey:@"state"];
                                       NSString *msg = [[json objectForKey:@"header"] objectForKey:@"msg"];
                                       if([state isEqualToString:@"0000"])
                                       {
                                           [Tool showCustomHUD:@"成功领取该优惠券" andView:self.view andImage:@"37x-Failure.png" andAfterDelay:2];
                                           return;
                                       }
                                       [Tool showCustomHUD:msg andView:self.view andImage:@"37x-Failure.png" andAfterDelay:2];
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
                                       [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                   }
                               }];
}

#pragma 下提刷新
- (void)reloadTableViewDataSource
{
    _reloading = YES;
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
    [self refresh];
}

// tableView添加拉更新
- (void)egoRefreshTableHeaderDidTriggerToBottom
{
    if (!isLoading) {
        [self performSelector:@selector(reload:)];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}
- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}
- (void)refresh
{
    if ([UserModel Instance].isNetworkRunning) {
        isLoadOver = NO;
        [self reload:NO];
    }
}

- (void)dealloc
{
    [self.tableView setDelegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

@end
