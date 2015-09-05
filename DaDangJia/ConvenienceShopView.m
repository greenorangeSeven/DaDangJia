//
//  ConvenienceShopView.m
//  DaDangJia
//
//  Created by Seven on 15/8/22.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "ConvenienceShopView.h"
#import "ConvenienceShopCell.h"
#import "ShopInfo.h"
#import "UIImageView+WebCache.h"
#import "ConvenienceDetailView.h"

@interface ConvenienceShopView ()

@end

@implementation ConvenienceShopView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.type.shopTypeName;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        if (IS_IOS8) {
            [self.locationManager requestAlwaysAuthorization];
        }
        self.locationManager.delegate = self;
    }else {
        latitude = 0.0;
        longitude = 0.0;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self reload:YES];
    }
    // 开始定位
    [self.locationManager startUpdatingLocation];
    
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
    
    shops = [[NSMutableArray alloc] initWithCapacity:20];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(_locService == nil)
    {
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
        [self startLocation];
    }
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    latitude = 0.0;
    longitude = 0.0;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self reload:YES];
}

-(void)startLocation
{
    NSLog(@"进入定位");
    [Tool showHUD:@"加载中..." andView:self.view andHUD:hud];
    [_locService startUserLocationService];
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"start locate");
    
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"改变位置");
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D mycoord = userLocation.location.coordinate;
    myPoint = BMKMapPointForCoordinate(mycoord);
    //    如果经纬度大于0表单表示定位成功，停止定位
    if (mycoord.latitude > 0) {
        latitude = mycoord.latitude;
        longitude = mycoord.longitude;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self reload:YES];
        [_locService stopUserLocationService];
    }
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    latitude = 0.0;
    longitude = 0.0;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self reload:YES];
}

- (void)doneManualRefresh
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.tableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
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
    self.locationManager = nil;
    self.locationManager.delegate = nil;
    _locService = nil;
    _locService.delegate = nil;
    
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    _refreshHeaderView = nil;
    [shops removeAllObjects];
    shops = nil;
    [super viewDidUnload];
}

- (void)clear
{
    allCount = 0;
    [shops removeAllObjects];
    isLoadOver = NO;
}

- (void)reload:(BOOL)noRefresh
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        if (isLoading || isLoadOver) {
            return;
        }
        [Tool showHUD:@"加载中..." andView:self.view andHUD:hud];
        if (!noRefresh) {
            allCount = 0;
        }
        int pageIndex = allCount/20 + 1;
        
        //生成获取商家列表URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:self.type.shopTypeId forKey:@"shopTypeId"];
        [param setValue:@"0" forKey:@"stateId"];
        [param setValue:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageNumbers"];
        [param setValue:@"20" forKey:@"countPerPages"];
        if(latitude > 0)
        {
            [param setValue:[NSString stringWithFormat:@"%f", latitude] forKey:@"latitude"];
            [param setValue:[NSString stringWithFormat:@"%f", longitude] forKey:@"longitude"];
        }
        
        NSString *getShopListUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findShopInfoByPage] params:param];
        
        [[AFOSCClient sharedClient]getPath:getShopListUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       NSMutableArray *shopNews = [Tool readJsonStrToShopInfoArray:operation.responseString];
                                       isLoading = NO;
                                       if (!noRefresh) {
                                           [self clear];
                                       }
                                       @try {
                                           NSInteger count = [shopNews count];
                                           allCount += count;
                                           if (count < 20)
                                           {
                                               isLoadOver = YES;
                                           }
                                           [shops addObjectsFromArray:shopNews];
                                           [self.tableView reloadData];
                                           [self doneLoadingTableViewData];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           if (hud != nil) {
                                               [hud hide:YES];
                                           }
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
            return shops.count == 0 ? 1 : shops.count;
        }
        else
            return shops.count + 1;
    }
    else
        return shops.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (row < [shops count])
    {
        return 108.0;
    }
    else
    {
        return 47.0;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if ([shops count] > 0) {
        if (row < [shops count])
        {
            ConvenienceShopCell *cell = [tableView dequeueReusableCellWithIdentifier:ConvenienceShopCellIdentifier];
            if (!cell) {
                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"ConvenienceShopCell" owner:self options:nil];
                for (NSObject *o in objects) {
                    if ([o isKindOfClass:[ConvenienceShopCell class]]) {
                        cell = (ConvenienceShopCell *)o;
                        break;
                    }
                }
            }
            ShopInfo *shop = [shops objectAtIndex:row];
            [cell.distanceBtn setTitle:[NSString stringWithFormat:@" %.2fkm", shop.distance] forState:UIControlStateNormal];
            
            
            cell.nameLb.text = shop.shopName;
            cell.addressLb.text = [NSString stringWithFormat:@"地址:%@", shop.shopAddress];
            cell.phoneLb.text = [NSString stringWithFormat:@"电话:%@", shop.phone];            
            [cell.imgIv sd_setImageWithURL:[NSURL URLWithString:shop.imgUrlFull] placeholderImage:[UIImage imageNamed:@"placeHoder"]];
            
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
    if (row >= [shops count]) {
        //启动刷新
        if (!isLoading) {
            [self performSelector:@selector(reload:)];
        }
    }
    else
    {
        ShopInfo *s = [shops objectAtIndex:[indexPath row]];
        if (s) {
            ConvenienceDetailView *shopDetail = [[ConvenienceDetailView alloc] init];
            shopDetail.shopInfo = s;
            [self.navigationController pushViewController:shopDetail animated:YES];
        }
    }
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

@end
